function saveBoard( board )
%saveBoard: Saves board data type to the "Boards" folder
%   saveBoard( board ) saves the values in the board data type and saves it
%   into the next available board txt file in the "Boards" folder. If the
%   "Boards" folder has 12 boards (numbered 0,1,..,10,11) then the board
%   will get saved as board number 12. The corresponding number will be
%   output for the user.
%   
%   Input Arguments:
%   board = Board to be saved to a txt file.
    
    % Crawls through the "Boards" folder and counts the amount of boards
    % present as ".txt" files
    num = length(dir(['Boards','\*.txt']));
    % Sets num to the amount of boards present (as boards are numbered
    % starting from 0)
    
    % Opens new file in the "Boards" folder for writing
    fp = fopen(['Boards\','b',num2str(num),'.txt'],'w');
    % Populate the folder with the board data in the correct orientation
    fprintf(fp,'%i %i %i %i %i %i %i %i %i %i\n', board');
    % Close the file
    fclose(fp);
    
    % Output to the user the number that was used for the file
    fprintf('Board saved as number %i.\n', num);
    
end

