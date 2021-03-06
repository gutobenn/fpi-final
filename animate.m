function f = animate(filename, SegLen, widthFactor, optimized, colorset, customcolor)
    % Init some constants
    BLACK = [0 0 0];
    BLUE = [0.2 0.2 1];
    WHITE = [255 254 254];
    YELLOW = [1.0 0.8 0.0];     
    GREEN1 = [0.0, 1.0, 0.2];
    BLUE1 = [0.0 0.0 0.4];
    GREEN = [0.0 0.8 0.2];
    ROXO = [0.2 0.0 0.4];    
    GREEN3 = [0.2 1.0 0.2];
	BLUE3 = [0.0 0.0 0.8];    
    YELLOW4 = [1 1 0.2];
    ROXO4 = [0.6 0 0.6];
    CYAN = [0 1 1];
    RED = [0.8 0 0.2];
    
    if(colorset > 0)
        COLORS = [[BLACK; BLUE; BLUE; WHITE; YELLOW; YELLOW]
                  [BLACK; BLUE1; BLUE1; WHITE; GREEN1; GREEN1]
                  [BLACK; ROXO; ROXO; WHITE; GREEN; GREEN]
                  [BLACK; BLUE3; BLUE3; WHITE; GREEN3; GREEN3]
                  [BLACK; ROXO4; ROXO4; WHITE; YELLOW4; YELLOW4]
                  [BLACK; RED; RED; WHITE; CYAN; CYAN]];
        colorset = colorset - 1;
    else
        [c1, c2, c3] = fourColorRapFinding(customcolor, [0 25 100 75], 180);
        COLORS = [BLACK; customcolor; customcolor; WHITE; c3; c3];
        colorset = 0;
    end
        
    Rows = 512;
    Cols = 512;
    Channels = 3;
    
    if rem(SegLen,6) ~= 0
        disp('SegLen must be multiple of 6!')
        return;
    end
    
    % Create black image
    I(1:Rows, 1:Cols, 1:Channels) = 127;
    
    fileID = fopen(filename,'r');
    % Read the number of streamlines
    N = fscanf(fileID, '%d', 1);
    for i=1:N
        % Read the number of points for current streamline
        P = fscanf(fileID, '%d', 1);
        
        points = [];
        for j=1:P
            % Read current point coordinates and insert into 'points'
            X = uint16(1 + fscanf(fileID, '%f', 1));
            Y = uint16(1 + fscanf(fileID, '%f', 1));
            points = [points; [X Y]];
        end
        
        % draw with optimization
        if optimized > 0
            s = 1;
            while s < P
                disp( sprintf( 'Streamline %d / %d    Ponto %d / %d', i, N, s, P ) );
                min_counter = Rows * Cols;
                best_offset_found = 0;
                % simulate three SegLen sizes (SegLen -6 , SegLen, SegLen +
                % 6) for a SegLen
                for offset=-1:1
                    adjustedSegLen = SegLen + offset*6;
                    counter = 0;
                    for j=s:( min(s+adjustedSegLen-1, P))
                        X = points(j,1);
                        Y = points(j,2);
                        index = colorset*6 + floor(rem(j,adjustedSegLen) * (6/adjustedSegLen)+1);
                        for c=1:Channels
                            width = floor(1 + widthFactor*SegLen);
                            for m=-width:width
                                for n=-width:width
                                    if (abs(m) > abs(n) && (X+m >= 1 && Y+n >= 1 && X+m <= Rows && Y+n <= Cols))
                                        %if ( (( isequal(COLORS(index,c),WHITE) || isequal(COLORS(index,c),YELLOW)) && ( isequal(I(X+m, Y+n), WHITE) || isequal(I(X+m, Y+n),YELLOW))) || ((isequal(COLORS(index),BLACK) || isequal(COLORS(index),BLUE)) && (isequal(I(X+m, Y+n),BLACK) || isequal(I(X+m, Y+n),BLUE) )) )
                                        tone1 = COLORS(1,c);
                                        tone2 = COLORS(2,c);
                                        tone3 = COLORS(4,c);
                                        tone4 = COLORS(6,c);
                                        if ( (( isequal(COLORS(index,c),tone3) || isequal(COLORS(index,c),tone4)) && ( isequal(I(X+m, Y+n), tone3) || isequal(I(X+m, Y+n),tone4))) || ((isequal(COLORS(index),tone1) || isequal(COLORS(index),tone2)) && (isequal(I(X+m, Y+n),tone1) || isequal(I(X+m, Y+n),tone2) )) )
                                          counter = counter + 1;
                                        end
                                    end
                                end
                            end
                        end
                        %disp( sprintf( 'offset %d  counter %d   best_offset %d   min_counter %d', offset, counter, best_offset_found, min_counter) );

                    end
                    if(counter < min_counter)
                        min_counter = counter;
                        best_offset_found = offset;
                    end
                end      
                
                % then draw the best found
                bestSegLen = SegLen + best_offset_found*6; 
                for j=s:(min(s+bestSegLen-1,P))
                    X = points(j,1);
                    Y = points(j,2);
                    index = colorset*6 + floor(rem(j,bestSegLen) * (6/bestSegLen)+1);
                    for c=1:Channels
                        width = floor(1 + widthFactor*SegLen);
                        for m=-width:width
                            for n=-width:width
                                if (abs(m) > abs(n) && (X+m >= 1 && Y+n >= 1 && X+m <= Rows && Y+n <= Cols))
                                    I(X+m,Y+n,c) = COLORS(index,c);
                                end
                            end
                        end
                    end
                end
                s = s + bestSegLen;
            end
        else        
            % draw it (with a circular (actually, triangular)neighborhood)
            % without optimization
            for j=1:P
                X = points(j,1);
                Y = points(j,2);
                index = colorset*6 + floor(rem(j,SegLen) * (6/SegLen)+1);
                for c=1:Channels
                    width = floor(1 + widthFactor*SegLen);
                    for m=-width:width
                        for n=-width:width
                            if (abs(m) > abs(n) && (X+m >= 1 && Y+n >= 1 && X+m <= Rows && Y+n <= Cols))
                                I(X+m,Y+n,c) = COLORS(index,c);
                            end
                        end
                    end
                end
            end
        end
    end
    fclose(fileID);
    
    imshow(I);
end
