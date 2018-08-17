function displayGame( playerFleet, opponentFleet, playerHits, playerMisses, opponentHits, opponentMisses, turn )
%displayGame: Creates visual representation of the overall game.
%   displayGame( playerFleet, opponentFleet, playerHits, playerMisses,
%   opponentHits, opponentMisses, turn ) plots the locations of the ships
%   for both sides as well as hit and miss markers for both sides.
%
%   Input Arguments:
%   playerFleet = The board and ships of the player
%   opponentFleet = The board and ships of the opponent
%   playerHits = The positions of the player's hits on the opponent
%   playerMisses = The position of the player's misses on the opponent
%   opponentHits = The positions of the opponent's hits on the player
%   opponentMisses = The position of the opponent's misses on the player
%   turn = The current turn number
    
    % Prepare Window if turn 0
    if ( ~turn )
        setupBoard(0);
    end

    % Draw Opponent Side
    if ( ~turn )
        % Prepare opponent side if turn 0
        setupBoard(1);
    else
        % Update opponent side otherwise
        subplot(2,1,1);
        % Clear any excess data
        cla;
    end
    
    % Draw the grid, visible ships, and marks
    hold on;
    drawGrid();
    drawVisible(opponentFleet,playerHits);
    drawMarks(playerHits, playerMisses);
    hold off;
    
    % Draw Player Side
    if ( ~turn )
        % Prepare player side if turn 0
        setupBoard(2);
    else
        % Update player side otherwise
        subplot(2,1,2);
        % Clear any excess data
        cla;
    end
    
    % Draw the grid, player ships, and marks
    hold on;
    drawGrid();
    drawFleet(playerFleet);
    drawMarks(opponentHits, opponentMisses);
    hold off;

end

function setupBoard(num)
%setupBoard: Prepares the figure window and the relevant subplots according
%to the num (functions as mode)

    % Prepare the figure window
    if ( num == 0 )
        % Format the figure (color, position, shape, title)
        figure('Color',[0.8 0.8 0.8], 'menu','none',...
            'position',[50 100 360 720],...
            'name','Battleship','NumberTitle','off');
    % Prepare the proper subplot
    else
        subplot(2,1,num);
        % Format the plot (color, titles, axes, shape)
        set(gca,'Color',[ 26/255 102/255 153/255 ]);
        if ( num == 1 )
            title('Opponent Board');
        elseif ( num == 2)
            title('Player Board');
        end
        set(gca,'XTick',0.5:10.5,...
            'XTickLabel',{'1','2','3','4','5','6','7','8','9','10'},...
            'XAxisLocation','top');
        set(gca,'YTick',0.5:10.5,....
            'YTickLabel',{'A','B','C','D','E','F','G','H','I','J'},...
            'YDir','reverse');
        %set(gca,'XTick',0.5:10.5,'XAxisLocation','top');
        %set(gca,'YTick',0.5:10.5,'YDir','reverse');
        axis([ 0 10 0 10 ]);
        axis square;
        box on;
    end
end

function drawGrid()
%drawGrid: Draws the gridlines
    for ii = 1:9
        plot( ii*ones(1,100), linspace(0,10,100),...
            '-','color',[ 62/255 162/255 229/255 ]);
        plot( linspace(0,10,100), ii*ones(1,100),...
            '-','color',[ 62/255 162/255 229/255 ]);
    end
end

function drawMarks(h,m)
%drawMarks: Draws the marks (hits and misses) according to their locations

    % Global variables imported
    global boardSize;

    % Loop across the rows..
    for ii = 1:boardSize
        % Loop across the cols..
        for jj = 1:boardSize
            % If a marker is found, then plot according marker
            if ( h(ii,jj) )
                %hit
                plot( jj-0.5, ii-0.5, 'rx', 'markersize', 20);
            elseif ( m(ii,jj) )
                %miss
                plot( jj-0.5, ii-0.5, 'wx', 'markersize', 20);
            end
        end
    end
end

function drawVisible(board, hits)
%drawVisible: Draws the opponents ships only if sunk

    % Global variables imported
    global boardSize lShip;
    
    % Loop across the rows..
    for ii = 1:boardSize
        % Loop across the cols..
        jj = 1;
        while ( jj <= boardSize )
            % If a ship segment is found, extract relevant information
            if ( board(ii,jj) ~= 0 )
                %current ship type
                iCS = board(ii,jj);
                %length of current ship
                lCS = lShip(iCS);
                
                % If next segment in the row contains the ship..
                if ( jj+lCS-1 <= boardSize ) && ( board(ii,jj+lCS-1) == iCS )
                    % ..extract position of the ship to tempoary board 1
                    tempB1 = zeros(boardSize);
                    tempB1(ii,jj:jj+lCS-1) = 1;
                    % ..extract position of corresponding hits to tempoary
                    % board 2
                    tempB2 = zeros(boardSize);
                    tempB2(ii,jj:jj+lCS-1) = hits(ii,jj:jj+lCS-1);
                    % ..if hits cover the length of the ship, ship has sunk
                    if ( isequal(tempB1,tempB2) )
                        % ..display ship accordingly
                        drawFleet(tempB2)
                    end
                    % Alter iterator to jump to the next unseen space
                    % (note: no need to look through the next few spaces as
                    % they will register false postives and utilize
                    % processor as the next spaces have just been checked,
                    % regardless of if ship was determined sunk or not)
                    jj = jj + lCS - 1;
                end
            end
            % Update col variable
            jj = jj + 1;
        end
    end
    % Loop across the cols..
    for ii = 1:boardSize
        % Loop across the rows..
        jj = 1;
        while ( jj <= boardSize )
            % If a ship segment is found, extract relevant information
            if ( board(jj,ii) ~= 0 )
                %current ship type
                iCS = board(jj,ii);
                %length of current ship
                lCS = lShip(iCS);
                
                % If next segment in the col contains the ship..
                if ( jj+lCS-1 <= boardSize ) && ( board(jj+lCS-1,ii) == iCS )
                    % ..extract position of the ship to tempoary board 1
                    tempB1 = zeros(boardSize);
                    tempB1(jj:jj+lCS-1,ii) = 1;
                    % ..extract position of corresponding hits to tempoary
                    % board 2
                    tempB2 = zeros(boardSize);
                    tempB2(jj:jj+lCS-1,ii) = hits(jj:jj+lCS-1,ii);
                    % ..if hits cover the length of the ship, ship has sunk
                    if ( isequal(tempB1,tempB2) )
                        % ..display ship accordingly
                        drawFleet(tempB2)
                    end
                    % Alter iterator to jump to the next unseen space
                    % (note: no need to look through the next few spaces as
                    % they will register false postives and utilize
                    % processor as the next spaces have just been checked,
                    % regardless of if ship was determined sunk or not)
                    jj = jj + lCS - 1;
                end
            end
            % Update row variable
            jj = jj + 1;
        end
    end
end

function drawFleet(board)
%drawFleet: Draws the ships according to their location in the data

    % Global variables imported
    global boardSize;

    % Loop across the rows..
    for ii = 1:boardSize
        % Loop across the cols..
        jj = 1;
        while ( jj <= boardSize )
            % If a ship segment is found, then plot according marker
            if board(ii,jj)
                plot( jj - 0.5, ii - 0.5,...
                    'ks', 'markersize', 20, 'markerfacecolor','k');
            end
            % Update col variable
            jj = jj + 1;
        end
    end
end


