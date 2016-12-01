function f = animate(filename, SegLen, widthFactor)
    % Init some constants
    BLACK = [0 0 0];
    BLUE = [0 102 255];
    WHITE = [255 254 254];
    YELLOW = [210 210 0];
    COLORS = [BLACK; BLUE; BLUE; WHITE; YELLOW; YELLOW];
    
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
        for j=1:P
            % Read current point coordinates
            X = uint16(2 + fscanf(fileID, '%f', 1));
            Y = uint16(2 + fscanf(fileID, '%f', 1));
            % and then draw it (with a circular (actually, triangular)
            % neighborhood)
            index = floor(rem(j,SegLen) * (6/SegLen)+1);
            for c=1:Channels
                height = floor(1 + widthFactor*SegLen);
                for m=-height:height
                    for n=-height:height
                        if (abs(m) > abs(n) && (X+m >= 1 && Y+n >= 1 && X+m <= Rows && Y+n <= Cols))
                            I(X+m,Y+n,c) = COLORS(index,c);
                        end
                    end
                end
            end
        end
    end
    fclose(fileID);
    
    imshow(I);
end
