# DEPENDÊNCIAS
- CGAL (no Debian: ```sudo apt-get install libcgal-dev```)
- MATLAB


# COMPILANDO
```
g++ streamline_generator.cpp --std=c++11 -lCGAL -lgmp -frounding-math -I/usr/local/include/CGAL -o streamline_generator
```


# UTILIZAÇÃO

## 1º PASSO: GERAÇÃO DE VECTOR FLOW
- Arquivo de entrada: um vector flow
esse arquivo segue a especificação... TODO: explicar melhor isso
- TODO: gerar vector flow a partir de uma imagem

## 2º PASSO: GERAÇÃO DA STREAMLINE
Execute o streamline_generator passando como argumentos o arquivo de entrada e um nome para o arquivo de saída.
```
./streamline_generator ex1_4.cin streamlines.txt
```
O arquivo gerado segue o seguinte formato:
A primeira linha contém um inteiro N, que é o número de streamlines geradas.
Depois, para cada uma das linhas há um inteiro P, indicando quantos pontos fazem parte da streamline. Para cada um desses pontos, há uma linha de dois valores (X e Y), que são as coordenadas do ponto.

## 3º PASSO: GERANDO A ANIMAÇÃO
No MATLAB, execute o script animate.m, passando por parâmetro o nome do arquivo gerado no passo anterior e o SegLen.

```animate('streamlines.txt', 18)```
