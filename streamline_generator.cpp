#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
#include <CGAL/Stream_lines_2.h>
#include <CGAL/Runge_kutta_integrator_2.h>
#include <CGAL/Regular_grid_2.h>
#include <iostream>
#include <fstream>

typedef CGAL::Exact_predicates_inexact_constructions_kernel K;
typedef CGAL::Regular_grid_2<K> Field;
typedef CGAL::Runge_kutta_integrator_2<Field> Runge_kutta_integrator;
typedef CGAL::Stream_lines_2<Field, Runge_kutta_integrator> Strl;
typedef Strl::Point_iterator_2 Point_iterator;
typedef Strl::Stream_line_iterator_2 Strl_iterator;
typedef Strl::Point_2 Point_2;
typedef Strl::Vector_2 Vector_2;

int main(int argc, char* argv[]){
        Runge_kutta_integrator runge_kutta_integrator;

        // Check the number of parameters
        if (argc < 3) {
                std::cerr << "Usage: " << argv[0] << " INPUT_FILE OUTPUT_FILE" << std::endl;
                return 1;
        }
        /* read input file */
        std::ifstream infile(argv[1], std::ios::in);
        double iXSize, iYSize;
        unsigned int x_samples, y_samples;
        iXSize = iYSize = 512;
        infile >> x_samples;
        infile >> y_samples;
        Field regular_grid_2(x_samples, y_samples, iXSize, iYSize);


        /* fill the grid with the appropriate values */
        for (unsigned int i=0; i<x_samples; i++)
                for (unsigned int j=0; j<y_samples; j++) {
                        double xval, yval;
                        infile >> xval;
                        infile >> yval;
                        regular_grid_2.set_field(i, j, Vector_2(xval, yval));
                }
        infile.close();


        /* generate streamlines*/
        std::cout << "Processando...\n";
        double dSep = 3.5;
        double dRat = 1.6;
        Strl Stream_lines(regular_grid_2, runge_kutta_integrator,dSep,dRat);
        std::cout << "Streamlines geradas\n";


        /* write streamlines to output file */
        std::ofstream fw(argv[2],std::ios::out);
        fw << Stream_lines.number_of_lines() << "\n";
        for(Strl_iterator sit = Stream_lines.begin(); sit != Stream_lines.end(); sit++) {
                // TODO: utilizar stringstreams pra poupar esse for que apenas conta o numero de pontos
                int p_counter = 0;
                for(Point_iterator pit = sit->first; pit != sit->second; pit++) {
                        p_counter++;
                }
                fw << p_counter << "\n";
                for(Point_iterator pit = sit->first; pit != sit->second; pit++) {
                        Point_2 p = *pit;
                        fw << p.x() << " " << p.y() << "\n";
                }
        }
        fw.close();
}
