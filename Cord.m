function [vector]= Cord( string )
%Cord: Translates traditional Battleship coordinates to matrix form.
%
%   Input Arguments:
%   string = userInput from parent function (as a string)
%
%   Output Arguments:
%   vector = matrix form of coordinates (as numericals)

    % Translates the letter (char) to corresponding numeric
    if strcmpi(string(1),'A')
        A=1;
    elseif strcmpi(string(1),'B')
      A=2;
    elseif strcmpi(string(1),'C')
        A=3;
    elseif strcmpi(string(1),'D')
        A=4;
    elseif strcmpi(string(1),'E')
        A=5;
    elseif strcmpi(string(1),'F')
        A=6;
    elseif strcmpi(string(1),'G')
        A=7;
    elseif strcmpi(string(1),'H')
        A=8;
    elseif strcmpi(string(1),'I')
        A=9;
    elseif strcmpi(string(1),'J')
        A=10;
    end
    % Translates the number (char) to corresponding numeric
    if strcmpi(string(2:end),'1')
        B=1;
    elseif strcmpi(string(2:end),'2')
        B=2;
    elseif strcmpi(string(2:end),'3')
        B=3;
    elseif strcmpi(string(2:end),'4')
        B=4;
    elseif strcmpi(string(2:end),'5')
        B=5;
    elseif strcmpi(string(2:end),'6')
        B=6;
    elseif strcmpi(string(2:end),'7')
        B=7;
    elseif strcmpi(string(2:end),'8')
        B=8;
    elseif strcmpi(string(2:end),'9')
        B=9;
    elseif strcmpi(string(2:end),'10')
        B=10;
    end

    % Creates coordinate vector and returns the value
    vector=[A B];

end

