function [ coordinates ] = getInput()
%getInput: Requests user input in the form of battleship coordinates and
%translates to matrix coordinates.
%   coordinates = getInput() requests that the user input battleship
%   coordinates in the traditional format of letter (L) and number (N)
%   (therefore in the format "LN"). Distinguishes between lowercase and
%   uppercase input and rejects any input not in the proper format.
%   getInput then calls Cord on the verified user input and ultimately
%   produces the matrix format of the coordinates.
%
%   Output Arguments:
%   coordinates = Matrix format of traditional battleship coordinates
%
%   Examples:
%   If userInput = 'A1'
%   then coordinates = [ 1 1 ]
%
%   If userInput = 'B4'
%   then coordinates = [ 2 4 ]
%   
%   If userInput = 'C10'
%   then coordinates = [ 3 10 ]

    % Variables
    L='A':'J';
    l='a':'j';
    N=1:10;
    
    % Input
    string = input('Enter a coordinate in the traditional battleship format (A1, B4, C10, etc.): ','s');
    % Verification
    while ( isempty(string) || ( (length(string)<2) || (length(string)>3)) || ( (ismember(string(1),L)~=1) && (ismember(string(1),l)~=1) ) || ( (ismember(str2double(string(2:end)),N)~=1) ) )
        string = input('ERROR! Re-enter your coordinate in the traditional format (A1, B4, C10, etc.): ','s');
    end
    
    % Send coordinats to Cord for processing
    coordinates = Cord(string);
    
end

