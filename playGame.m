function [ result ] = playGame( mode, players )
%playGame: The driving function that manages all the gameplay.
%   playGame ( mode, players ) drives every portion of the gameplay. It
%   provides the calls for board generation depending on input mode, and
%   prepares the requisite data types. It then drives the turn-based
%   gameplay by alternating moves between the players as well as making the
%   calls to display the game. Finally, it terminates the game whenever a
%   player is considered to have won.
%
%   Input Arguments:
%   mode = Determines if game is running in quickplay, regular play, or
%   netplay.
%   players = Provides the number of players in the particular game mode.

    % Global variables imported
    global boardSize;
    
    switch mode
        % Quickplay..
        case 0
            % ..randomly generate boards
            playerBoard = makeBoard(2);
            opponentBoard = makeBoard(2);
        % Single-Player..
        case 1
            % Request method of board generation from user
            clc;
            fprintf('Would you like to\n');
            fprintf(' 1: Create a Board\n');
            fprintf(' 2: Generate a Board\n');
            fprintf(' 3: Load a Board\n');
            % Input
            choice = input('Make a Selection: ');
            % Verification
            while ( isempty(choice) || ( length(choice) ~= 1 ) || ( choice < 1 ) || ( choice > 3 ) || ( mod(choice,1) ) )
                choice = input('Erroneous Input. Please enter another selection: ');
            end
            
            if ( choice < 3 )
                % Player-input board
                playerBoard = makeBoard(choice);
            elseif ( choice == 3 )
                % Load a saved board
                % Input
                num = input('Pick the board Number to load: ');
                % Verification pt1
                while ( isempty(num) || ( num<0 ) || ( mod(num,1) ) )
                    num = input('Erroneous Input. Please enter another number: ');
                end
                % Verification pt2
                while ~( exist(['Boards\b',num2str(num),'.txt'],'file') )
                    fprintf('Board #%i does not exist.\n',num);
                    num = input('Pick the board Number to load: ');
                end
                % Load board
                playerBoard = load(['Boards\b',num2str(num),'.txt']);
            end
            % Generate opponent board
            opponentBoard = makeBoard(2);
            
            % Close any straggling figures
            close all;
    end
    
    % Initialize hit and miss data types
    playerHits = zeros(10);
    playerMisses = zeros(10);
    opponentHits = zeros(10);
    opponentMisses = zeros(10);
    
    % Initialize stats (for fleet numbers)
    playerAmount = [ sum(sum(~(~opponentBoard))) ];
    opponentAmount = [ sum(sum(~(~opponentBoard))) ];
    playerStreak = 0;
    opponentStreak = 0;
    playerHighest = 0;
    opponentHighest = 0;
    playerHitRate = 0;
    opponentHitRate = 0;
    playerMissRate = 0;
    opponentMissRate = 0;
    
    % Initialize turn counter
    turn = 0;
    while(true)
        clc;
        % If turn = 0, display the initial state of the game
        if (~turn)
            displayGame( playerBoard, opponentBoard, playerHits, playerMisses, opponentHits, opponentMisses, turn);
        end
        % If player one's turn
        if ( ~mod(turn,2) )
            fprintf('Player One\n');
            fprintf('Prepare to fire! Click on any square on the opponent''s field!\n(Clicking on your side will select the corresponding square on the opponent''s field)\n');
            %move = getInput();
            % Receive input from mouse click
            [ x, y ] = ginput(1);
            move = [ floor(y+1) ceil(x) ];
            % Verification ( within bounds, and not a previously made move )
            while ( ( ( move(1) < 1 ) || ( move(1) > 10 ) ) || ( ( move(2) < 1 ) || ( move(2) > 10 ) ) || playerHits(move(1),move(2)) || playerMisses(move(1),move(2)) )
                %move = getInput();
                [ x, y ] = ginput(1);
                move = [ floor(y+1) ceil(x) ];
            end
            % If a hit, mark as a hit
            if opponentBoard(move(1),move(2))
                playerHits(move(1),move(2)) = 1;
                % Increment Streak Value
                playerStreak = playerStreak + 1;
            % Else, was a miss, mark as such
            else
                playerMisses(move(1),move(2)) = 1;
                % Edit Streak Values
                if ( playerStreak > playerHighest )
                    playerHighest = playerStreak;
                end
                playerStreak = 0;
            end
            % Update number in fleet at current turn
            opponentAmount = [ opponentAmount ( sum(sum(~(~opponentBoard))) - sum(sum(playerHits)) ) ];
            %waitforbuttonpress
        % If player two's turn
        else
            fprintf('Player Two\n');
            % Check for number of players..
            switch players
                % ..single player, thus CPU makes the move
                case 1
                    % Randomly decide move
                    move = [ randi(10) randi(10) ];
                    % Verification ( not a previously made move )
                    while ( opponentHits(move(1),move(2)) || opponentMisses(move(1),move(2)) )
                        move = [ randi(10) randi(10) ];
                    end
                    % If a hit, mark as a hit
                    if playerBoard(move(1),move(2))
                        opponentHits(move(1),move(2)) = 1;
                        % Increment Streak Value
                        opponentStreak = opponentStreak + 1;
                    % Else, was a miss, mark as such
                    else
                        opponentMisses(move(1),move(2)) = 1;
                        % Edit Streak Values
                        if ( opponentStreak > opponentHighest )
                            opponentHighest = opponentStreak;
                        end
                        opponentStreak = 0;
                    end
                    %pause( pi/exp(1) );
                % ..multiplayer, check for opponent's move
                case 2
                    %not used (only if netplay is enabled)
            end
            % Update number in fleet at current turn
            playerAmount = [ playerAmount ( sum(sum(~(~playerBoard))) - sum(sum(opponentHits)) ) ];
        end
        
        % Increment turn counter
        turn = turn + 1;
        % Display the current state of the board
        displayGame( playerBoard, opponentBoard, playerHits, playerMisses, opponentHits, opponentMisses, turn);
        
        % Check if a player has won
        victor = checkWin(playerBoard, opponentBoard, playerHits, playerMisses, opponentHits, opponentMisses);
        % If there exists a winner..
       	if ( victor )
            % ..display winner based on player number
            switch victor
                case 1
                    fprintf('\nPlayer One is Victorious!\n');
                    result = 1;
                case 2
                    fprintf('\nPlayer Two is Victorious!\n');
                    result = 0;
            end
            % Display end-game statistics          
            displayShipStats( playerAmount, opponentAmount);
            stats = table( [ ( sum(sum(playerHits)) + sum(sum(playerMisses)) );...
                ( sum(sum(opponentHits)) + sum(sum(opponentMisses)) ) ],...
                [ sum(sum(playerHits)); sum(sum(opponentHits)) ],...
                [ sum(sum(playerMisses)); sum(sum(opponentMisses)) ],...
                [ 100*sum(sum(playerHits))/( sum(sum(playerHits)) + sum(sum(playerMisses)) );...
                100*sum(sum(opponentHits))/( sum(sum(opponentHits)) + sum(sum(opponentMisses)) ) ],...
                [ playerHighest; opponentHighest ],...
                'VariableNames', { 'Moves' 'Hits' 'Misses' 'Accuracy' 'HitStreak' },...
                'RowNames', { 'Player One' 'Player Two' });
            fprintf('Game Statistics:\n');
            disp(stats);
            break;
        end
        % Check turn max, not exceeded
        if ( turn >=  2*(boardSize^2) )
            % Note: Should never occur!
            fprintf('Error! Unknown game state!');
            break;
        end
    end
    
end

function [ result ] = checkWin(playerBoard, opponentBoard, playerHits, ~, opponentHits, ~)
%checkWin: Looks at both boards and checks for a winner.

    % If total number of ship segments present are equal to number of hits
    % then the corresponding player has won
    if ( isequal(sum(sum(playerHits)),sum(sum(~(~opponentBoard)))) )
        result = 1;
    elseif ( isequal(sum(sum(opponentHits)),sum(sum(~(~playerBoard)))) )
        result = 2;
    % Otherwise, the game continues
    else
        result = 0;
    end

end

function displayShipStats( oneStats, twoStats) 
    
    figure;
    % Plot both players' fleets according to turn number
    plot(1:length(oneStats), oneStats, 1:length(twoStats), twoStats );
    title('Ship Health over Duration of Game');
    xlabel('Turn Number');
    ylabel('Fleet Health (Ship Segments)');
    legend('Player One','Player Two','Location','Best');

end


