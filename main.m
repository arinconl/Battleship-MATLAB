function main()
%main: The main function driving/calling the game methods.

    %Clears and closes any open data/figures
    clear; clc; close all; format shortG; format compact;

    % Establish Global Variables
    global boardSize qShip iShip lShip tShip;

    %Max Board Size (NxN)
    boardSize = 10;
    %Quantity of Ships
    qShip = [ 1 1 1 1 1 ];
    %Identifier of Ships
    iShip = [ 1 2 3 4 5 ];
    %Length of Ships
    lShip = [ 2 3 3 4 5 ];
    %Type of Ships
    tShip = { 'destroyer' 'submarine' 'cruiser' 'battleship' 'carrier' };

    % Run the Program via menu
    menu();
    
    % End of Program, clear/close any open data/figures
    clear; close all;

end


