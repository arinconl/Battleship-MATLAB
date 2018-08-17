function menu()
%This function is the main menu of the game. The player has the option
%to choose from playing the game, to viewing and creating boards, to
%getting assistance from a help menu. The player first inputs which option
%they need, then from the multiple switch cases from each option, can lead to several
%sub-menus (Single Player menu, Boards menu, and Help menu).

    while(true)

        header();%prints battleship logo

        %creates the main menu options to choose from
        fprintf('\n');
        fprintf('\\\\Menu\n');
        fprintf(' 1: Quick-play 1P\n');
        fprintf(' 2: Single Player\n');   
        %fprintf(' 4: Multiplayer(WiFi)\n');
        fprintf(' 5: Boards\n');
        fprintf(' 6: Help\n');
        %fprintf(' 8: Debug Tests\n');
        %fprintf(' 9: Debug Ship Sunk\n');
        fprintf(' 0: Exit\n');

        choice = input(' \\Make a Selection: ');%input which option needed
        while ( isempty(choice) || ( length(choice) ~= 1 ) || ( choice < 0 ) || ( choice > 9 ) || ( mod(choice,1) ) )
            choice = input('Erroneous Input. Please enter another selection: ');
        end
        %error message if number inputted is not part of main menu
        switch choice

            case 0 %(Nothing) ends script
                fprintf('\n\\\\Thanks for playing!\n\n');
                close all;
                clear;
                break;
            case 1 %(Quick Play) one player option that automatically loads board to use
                playGame(0, 1);
                cont(1);
            case 2 %(Single Player) one player option that allows player to create or choose which board to use
                playGame(1, 1);
                cont(1);
            case 5 %(Boards) create and save boards or view default boards
                boards();
            case 6 %(Help) help menu for extra assistance 
                help();
            case 8
                %tests;
                run('bTests.m');
                cont(1);
            case 9
                %ship sinking;
                debug();
                cont(1);

        end

    end

end


%% Local Functions

%These are the local functions which include the board menu and help menu.
%Each menu operates on an input system which indicates which case or option
%is desired by the user. The board menu lets you acces the board file and
%the functions that create boards. The help menu gives you instructions on the game.

function header() 
    fprintf([...
        '   ___    _   _____  _____  __    __  __         _____  ___ \n'...
        '  / __\\  /_\\ /__   \\/__   \\/ /   /__\\/ _\\  /\\  /\\\\_   \\/ _ \\\n'...
        ' /__\\// //_\\\\  / /\\/  / /\\/ /   /_\\  \\ \\  / /_/ / / /\\/ /_)/\n'...
        '/ \\/  \\/  _  \\/ /    / / / /___//__  _\\ \\/ __  /\\/ /_/ ___/\n'... 
        '\\_____/\\_/ \\_/\\/     \\/  \\____/\\__/  \\__/\\/ /_/\\____/\\/   \n',...
        ]);
end
%printed header display for menu 
function boards() %option 5 from main menu

    clc;
    fprintf('\\\\Boards\n');
    fprintf(' \\\\What would you like to do?\n');
    fprintf('  1: Create a board\n');    %display options when 5.Boards option
    fprintf('  2: View a board\n');      %is chosen from main menu
    fprintf('  0: Nothing\n');

    choice = input('  \\Make a Selection: '); %pick which option(0-2) is needed
    while ( isempty(choice) || ( length(choice) ~= 1 ) || ( choice < 0 ) || ( choice > 2 ) || ( mod(choice,1) ) )
        choice = input('Erroneous Input. Please enter another selection: ');
    end
    %error message if not one of the options(0-2) is inputted 
    switch choice
        case 0
            cont(0); %option 0 (Nothing) ends script press enter to continue 
        case 1
            clc;
            fprintf('\\\\Boards\n');
            fprintf(' \\\\What type of board?\n'); %Display when option 1(Create a board) 
            fprintf('  1: Player made\n');          %is chosen from Boards menu
            fprintf('  2: Computer generated\n');
            choice = input('  \\Make a Selection: '); %input which option(1-2) is needed
            while ( isempty(choice) || ( length(choice) ~= 1 ) || ( choice < 1 ) || ( choice > 2 ) || ( mod(choice,1) ) )
                choice = input('Erroneous Input. Please enter another selection: ');
            end
            %error message if 1 or 2 is not inputted
            board = makeBoard(choice); %if option 1 is chosen makeBoard function is utlized  
                                       %to create a board
            clc;
            fprintf('Displaying Generated Board:\n'); 
            displayBoardOnly(board, 0);%displays board after it has been created
            
            saveFile = input('Would you like to save this board (yes or no)? ','s');
            while ( isempty(saveFile) )
                saveFile = input('Would you like to save this board (yes or no)? ','s');
            end
            if ( strcmpi(saveFile(1),'y') ) %option to save board
                saveBoard(board);           %if yes is chosen moves board to saveBoard function 
            end
            cont(1);%press enter to continue 
        case 2 %option 2 from board menu(View a Board)
            num = input('  \\\\Pick the board Number to view: ');%pick board to use
            while ( isempty(num) || ( num<0 ) || ( mod(num,1) ) )
                num = input('Erroneous Input. Please enter another number: ');
            end
            if ( exist(['Boards\b',num2str(num),'.txt'],'file') ) 
                board = load(['Boards\b',num2str(num),'.txt']); %if number board exists loads this board
                displayBoardOnly(board, num);                   %from Boards file
            else
                fprintf('Board #%i does not exist.\n',num); %if board chosen doesnt exist displays message
            end
            cont(1);%press enter to continue
    end

end

function help() %option 6 from main menu

    clc;
    fprintf('\\\\Help\n');
    fprintf(' \\\\What would you like to know more about?\n');
    fprintf('  1: About\n');   %display menu when option #6 is chosen from main menu
    fprintf('  2: Instructions\n');
    fprintf('  0: Nothing\n');

    choice = input('  \\Make a Selection: ');%input which option(0-2) is needed
    while ( isempty(choice) || ( length(choice) ~= 1 ) || ( choice < 0 ) || ( choice > 2 ) || ( mod(choice,1) ) )
        choice = input('Erroneous Input. Please enter another selection: ');
    end
    %error message if one of the options is not chosen 
    switch choice
        case 0
            cont(0); %option 0 (Nothing) ends script
        case 1
            about(); %option 1 (About) moves to about()
            cont(1);%press enter to continue
        case 2
            instructions(); %option 2 (instructions) moves to instrcutions()
            cont(1);%press enter to continue
    end

end

function about() %option 1 from help menu
    fprintf('  \\\\About:\n'); %displays about the game
    fprintf(['\tBattleship: MATLAB implementation of the classic pen and \n'...
        '\tpaper guessing game. Features quickplay with random and user input\n'...
        '\tboard creation. Boards are viewable from the main menu. ']);
    fprintf('\n');
end

function instructions()%option 2 from help menu
    fprintf('  \\\\Instructions:\n   '); %displays instructions about game
    fprintf(['\tTwo players sit infront of each other with their screens \n'...
        '\traised so they cannot see each others ocean grids. Each player places \n'...
        '\ttheir fleet of 5 ships on their 10x10 ocean grids, keeping the positons \n'...
        '\ta secret to their opponent. Rules for placing ships: 1.Only place \n'...
        '\tships horizontally and vertically, not diagnolly 2. Do no place \n'...
        '\tships over any letters, numbers, or other ships 3. Do not change \n'...
        '\tthe position of the ships once the game has begun. The objective \n'...
        '\tof the game is to be the first to sink all 5 of your oppenents \n'...
        '\tships. The players will alternate turns, calling out one shot \n'...
        '\tper turn. To guess a position call out its location by letter \n'...
        '\tand number. Each target hole has a letter-number coordinate \n'...
        '\tthat corresponds with the same coordinate on the oppenents grid. \n'...
        '\tThe coordinates letter represents the row letter to the left and \n'...
        '\tthe number represents the column number at the top of the grid. \n'...
        '\tThe opponent must tell the guesser whether the shot was a hit \n'...
        '\tor miss. If a hit, the opponent tells you which ship you hit. \n'...
        '\tBoth players record the position of the hit with a red marker \n'...
        '\ton their grids.If a miss, only the guesser records the position \n'...
        '\tof the miss with a white marker on their grid. Example: You and \n'...
        '\tBob are the players. Its your turn. \n'...
        '\tYou call: "D-4" \n'...
        '\tBob answers: "Hit. Cruiser." \n'...
        '\tYou and Bob place red markers in coordinate D-4. \n'...
        '\tNow its Bobs turn. \n'...
        '\tBobs call: "F-4" \n'...
        '\tYou answer: "Miss" \n'...
        '\tBob places a white marker in coordinate F-4. \n'...
        '\tOnce all the holes in any one ship are filled with red markers \n'...
        '\tthe owner of the ship must announce the ship that has been sunken. \n'...
        '\tPlay conitnues in this manner, with each player calling one shot \n'...
        '\tper turn. Whoever sinks all five ships first is the winner of the \n'...
        '\tgame.\n']);
        
    fprintf('\n');
end

function cont(mode) 
    if ( mode ) 
        input('\nPress enter to continue...\n');
    else
        fprintf('\n'); 
    end
    clc; close all;
end
%differentiates between continuing without asking or
%asking to press enter to continue(clearing the screen)

function debug()

    b1 = load('Boards\b4.txt');
    b2 = load('Boards\b8.txt');

    % Prepare Opponent Board
    aHM = zeros(10);
    aHM(1,5) = 1;
    aHM(3,5) = 1;
    aHM(2,5) = 1;
    aHM(4,5) = 1;
    aHM(10,5) = 1;
    aMM = zeros(10);
    aMM(4,1) = 1;
    aMM(1,2) = 1;

    % Prepare Player Board
    oHM = zeros(10);
    oHM(3,3) = 1;
    oHM(4,3) = 1;
    oMM = zeros(10);
    oMM(2,3) = 1;
    oMM(6,3) = 1;
    oMM(5,4) = 1;

    displayGame( b1, b2, aHM, aMM, oHM, oMM, 0);
    waitforbuttonpress;
    aHM(5,5) = 1;    
    displayGame( b1, b2, aHM, aMM, oHM, oMM, 1);
    waitforbuttonpress;
    oHM(9,4) = 1;
    displayGame( b1, b2, aHM, aMM, oHM, oMM, 2);
                
    

end

