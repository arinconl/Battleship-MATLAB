function [ board ] = makeBoard( mode )
%makeBoard: Creates a battleship board randomly, or user-specified
%according to the input mode.
%   board = makeBoard( mode ) takes in a mode (1 for user-specified, 2 for
%   pseudo-random generation) and creates a battleship board accordingly.
%
%   Input Arguments:
%   mode = method of board creation: 1, user-specified; 2 random generation
%
%   Output Arguments:
%   board = a legal board data type (housed as a matrix)   

    % Global variables imported
    global boardSize iShip lShip tShip;
   
    function [ board ] = blankBoard()
    %blankBoard: Creates a board of zeros of proper size
        
        board = zeros(boardSize);
        
    end

    % Initially create a blank board
    board = blankBoard();
    
    % Display iterator variable, used in calling displayBoardOnly
    % t=0 corresponds to load a new figure, t>0 corresponds to update plot
    t = 0;
    
    % For the amount of ships..
    for ii = 1:length(iShip)
        
        % ..call getPlacement() for the current type of ship
        getPlacement(ii);

    end

    function getPlacement( n )
    %getPlacement: Obtains coordinates for location of a new ship from the
    %user, and only allows for correct placement of ships.
        
        function placeShip()
        %placeShip: Using the specified and approved coordinates, places
        %the current ship type into the select row or column starting at
        %the provided coordinate (thus, the coordinate will represent the
        %top-left-most segement of a ship)
            
            % Depending on the alignment..
            switch sAlign
                % ..place the ship vertically
                case 0
                    board( sCoord(1):sCoord(1) + lShip(n) - 1, sCoord(2)) = iShip(n);
                % ..place the ship horizontally
                case 1
                    board( sCoord(1), sCoord(2):sCoord(2) + lShip(n) - 1) = iShip(n);
            end
            
        end
        
        function [ c ] = canPlace()
        %canPlace: Using the provided coordinate and orientation
        %information, checks if the current ship type can legally be placed
        %in such a manner, if unable to, returns -1.
            
            % Depending on the orientation value..
            switch sAlign
                case 0
                % ..check if sufficient vertical space
                    tempL = sCoord(1) + lShip(n) - 1;
                    if ( tempL < boardSize )
                    %enough space
                        c = 2;
                    elseif ( tempL == boardSize )
                    %exactly enough space
                        c = 1;
                    elseif ( tempL > boardSize )
                    %not enough space, no need to continue
                        c = 0;
                        return;
                    else
                        c = -1;
                        return;
                    end
                    % Assuming enough space, store the current values of 
                    % thespace the ship will be placed in, into
                    % temporaryShip (tempS)
                    tempS = board(sCoord(1):sCoord(1) + lShip(n) - 1, sCoord(2));
                % ..check if sufficient horizontal space
                case 1
                    tempL = sCoord(2) + lShip(n) - 1;
                    if ( tempL < boardSize )
                    %enough space
                        c = 2;
                    elseif ( tempL == boardSize )
                    %exactly enough space
                        c = 1;
                    elseif ( tempL > boardSize )
                    %not enough space, no need to continue
                        c = 0;
                        return;
                    else
                        c = -1;
                        return;
                    end
                    % Assuming enough space, store the current values of 
                    % thespace the ship will be placed in, into
                    % temporaryShip (tempS)
                    tempS = board(sCoord(1), sCoord(2):sCoord(2) + lShip(n) - 1);
            end

            % Checks the position in question (tempS) and if any of the
            % spots contain a segment of a ship, then the ship cannot be
            % placed there
            if ( any(tempS) || any(tempS') )
            %cannot place ship here
                c = -1;
                return;
            end               

        end
        
        % Check current mode..
        switch mode
            % ..user input mode
            case 1
                clc;
                % Display the current state of the board to the user
                fprintf('Current state of the board:\n');
                displayBoardOnly(board, t);
                % Provide information on current ship type
                fprintf('Where would you like to place your %s (takes up %i spaces)? \n', tShip{n}, lShip(n));
                % Ask for coordinate input
                sCoord = getInput();
                % Ask for orientation input
                sAlign = input('Place it vertical or horizontal? ', 's');
                % Verification that user input vertical/horizontal
                % (shorthand check)
                while ( isempty(sAlign) || ~any( [ strcmpi( sAlign(1), 'h'), strcmpi( sAlign(1), 'v') ] ) )
                    sAlign = input('Place it vertical or horizontal? ', 's');
                end
                
                % Translate orientation char to corresponding numeric
                if strcmpi( sAlign(1), 'h')
                    sAlign = 1;
                elseif strcmpi( sAlign(1), 'v')
                    sAlign = 0;
                end

                % Verify that those values can be used
                while ( canPlace() <= 0 )
                    % Perform same process in request of new coordinate
                    fprintf('Coordinates can''t be used!\n');
                    fprintf('Where would you like to place your %s (takes up %i spaces)? ', tShip{n}, lShip(n));
                    sCoord = getInput();
                    sAlign = input('Place it vertical or horizontal? ', 's');
                    while ( isempty(sAlign) || ~any( [ strcmpi( sAlign(1), 'h'), strcmpi( sAlign(1), 'v') ] ) )
                        sAlign = input('Place it vertical or horizontal? ', 's');
                    end
                    if strcmpi( sAlign(1), 'h')
                        sAlign = 1;
                    elseif strcmpi( sAlign(1), 'v')
                        sAlign = 0;
                    end
                end
                
                % Place ships at user-specified  location
                placeShip();
                
                % Increment display counter
                t = t + 1;
            % ..randomly generate 
            case 2
                % Choose random values for coordinate and orientation
                sCoord = [ randi(10) randi(10) ];
                sAlign = randi(2)-1;
                % Verify that those values can be used
                while ( canPlace() <= 0 )
                    sCoord = [ randi(10) randi(10) ];
                    sAlign = randi(2)-1;
                end
                
                % Place ships at specified random location
                placeShip();
                
        end
        
    end

end


