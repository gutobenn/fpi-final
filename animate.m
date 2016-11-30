function f = animate(filename)
    % Init some constants
    BLACK = [0 8 27];
    BLUE = [0 102 255];
    WHITE = [255 254 254];
    YELLOW = [210 210 0];
    COLORS = [BLACK; BLUE; BLUE; WHITE; YELLOW; YELLOW];
    
    Rows = 513; % TODO: or 512?
    Cols = 513;
    Channels = 3;
    
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
            X = uint16(1 + fscanf(fileID, '%f', 1));
            Y = uint16(1 + fscanf(fileID, '%f', 1));
            % and then draw it
            index = round(rem(j,6)+1);
            for c=1:Channels
                I(X,Y,c) = COLORS(index,c);
            end
        end
    end
    fclose(fileID);
    
    % TODO: include neighborhood to make it stronger?
    
    imshow(I);
end
