function [f,g] = fourGrayRapFinding(L0, RAP)

    % Passar um vetor [R/255 G/255 B/255] para L0
    % Passar [0 25 100 75] para RAP
    
    rap0 = [0 25 100 75];
    rap1 = [25 100 75 0];
    rap2 = [100 75 0 25];
    rap3 = [75 0 25 100];
    rap = [rap0 rap1 rap2 rap3];
    
    disp('Input color: ');
    disp(L0);
       
    labColor = rgb2lab(L0);
    disp('L0: ');
    disp(labColor(1));
   
    menorDif = 999;
    iNearest = -1;
    
    %j = 1;
    for i = 1:4
        %disp(rap(j));
        if abs(labColor(1) - RAP(i)) < menorDif
            menorDif = abs(labColor(1) - RAP(i));
            iNearest = i;
        end
       % j = j + 4;
    end
    
    disp('menorDif:');
    disp(menorDif);
    disp('iNearest');
    disp(iNearest);
    
    %L1 = RAP(mod((iNearest-1+1),4)+1);
    %L2 = RAP(mod((iNearest-1+2),4)+1);
    %L3 = RAP(mod((iNearest-1+3),4)+1);
    if iNearest == 1 || iNearest == 3
        RAP(iNearest+1) = labColor(1);
    end
    %newRap = [labColor(1) L1 L2 L3];
    %disp('newRap');
    %disp(newRap);
    disp('RAP');
    disp(RAP);
    f = RAP;
    g = iNearest;