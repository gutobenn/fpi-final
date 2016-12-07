function [f,g,h] = fourColorRapFinding(C0, RAP, degree)
    LabC0 = rgb2lab(C0);
    disp('LabC0:');
    disp(LabC0);
    [LL, iNearest] = fourGrayRapFinding(C0, RAP);
    disp('LL:');
    disp(LL);
    
    LabC1 = [LL(2), LabC0(2), LabC0(3)];
    disp('LabC1:');
    disp(LabC1);
    LabC2 = [LL(3), LabC0(2), LabC0(3)];
    disp('LabC2:');
    disp(LabC2);
    LabC3 = [LL(4), LabC0(2), LabC0(3)];
    disp('LabC3:');
    disp(LabC3);
    
    if (iNearest == 0 || iNearest == 2) && degree == 180
       %LabC2 e LabC3
        LabC2(3) = -LabC2(3)
        LabC3(3) = -LabC3(3)
    else
        %LabC1 e LabC2
        LabC1(3) = -LabC1(3)
        LabC2(3) = -LabC2(3)
    end
    
    disp('C1:');
    C1 = lab2rgb(LabC1);
    for i = 1:3
        if C1(i) < 0
          C1(i) = 0.0;
        elseif C1(i) > 1.0
            C1(i) = 1.0;
        end
    end
    disp(C1);
    disp('C2:');
    C2 = lab2rgb(LabC2);
    for i = 1:3
        if C2(i) < 0
          C2(i) = 0.0;
        elseif C2(i) > 1.0
            C2(i) = 1.0;
        end
    end
    disp(C2);
    disp('C3:');
    C3 = lab2rgb(LabC3);
    for i = 1:3
        if C3(i) < 0
          C3(i) = 0.0;
        elseif C3(i) > 1.0
            C3(i) = 1.0;
        end
    end
    disp(C3);
    
    f = C1;
    g = C2;
    h = C3;