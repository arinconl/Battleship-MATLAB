clear; clc; close all; format shortG; format compact;

%verifyBoard: Runs verification on all the boards in the "Test Boards"
%folder, and outputs the legal result for each (correct or wrong).


global boardSize iShip lShip tShip;

bList = dir(['Test Boards','\*.txt']);
bLength = length(bList);
bNames = cell(1,bLength);
for kk = 1:bLength
    bNames{kk} = bList(kk).name;
end
for kk = 1:bLength
    board = load(['Test Boards\',bNames{kk}]);

    % verifyBoard()

    %Found Ships
    %Set up variable for "sightings"
    fShip = zeros(1,length(iShip));
    %Keep track of sightings in rows
    rFind = zeros(1,length(iShip));

    % Traverse the Board
    %Look through for completed ships in the ROWS
    for ii = 1:boardSize

        jj = 1;
        while ( jj <= boardSize )

            %Found something
            if board(ii,jj) ~= 0

                iCS = board(ii,jj);
                lCS = lShip(iCS);
                %fprintf('Discovery!\n %i at b(%i,%i).\n It''s a %s (length of %i).\n',iCS,ii,jj,tShip{iCS},lCS);
                %return;

                %Has it been found already
                if ( fShip(iCS) )
                    %fprintf('Not new!\n Ship type has already been found!\n');
                else
                    %fShip(iCS) = 1;
                    %fprintf('New!\n Ship type has been added to seen!\n');
                end

                if ( fShip(iCS) == 0 )

                    %Check if space in row is sufficient
                    aSpace = jj + lCS - 1;
                    if ( aSpace == 10)
                        %fprintf('Space:\n There is exactly enough space for the ship!\n');
                        aLength = 1;
                    elseif ( aSpace < 10 )
                        %fprintf('Space:\n There is more than enough space open!\n');
                        aLength = 0;
                    elseif ( aSpace > 10 )
                        %fprintf('Space:\n There is NOT enough space for the ship!\n');
                        aLength = -1;
                    end

                    %Check if ship is in fact in row
                    switch aLength
                        case -1
                            %fprintf('error\n');
                        case 0
                            sTemp = board(ii, jj:jj + lCS);
                            fTemp = ( iCS == sTemp );
                            if all(fTemp)
                                %fprintf('Wrong!\n Ship is longer than it should be!\n');
                            elseif all(fTemp(1:end-1))
                                %fprintf('Correct!\n Entire ship was found.\n');
                                fShip(iCS) = fShip(iCS) + 1;
                                rFind(iCS) = rFind(iCS) + 1;
                                %Move to next empty space
                                jj = jj + lCS - 1;
                            end
                        case 1
                            sTemp = board(ii, jj:jj + lCS - 1);
                            fTemp = ( iCS == sTemp );
                            if all(fTemp)
                                %fprintf('Correct!\n Entire ship was found.\n');
                                fShip(iCS) = fShip(iCS) + 1;
                                rFind(iCS) = rFind(iCS) + 1;
                                %Move to next empty space
                                jj = jj + lCS - 1;
                            end
                    end

                    %jj = jj + lCS;

                elseif ( fShip(iCS) > 1 )
                    fShip(iCS) = fShip(iCS) + 1;
                    %fprintf('Wrong!\n Too many ships of this type!\n');
                    %return;

                end

                %fprintf('\n');

            end

            %Move to next empty space
            jj = jj + 1;

        end

    end
    %Look through for completed ships in the COLS
    for ii = 1:boardSize

        jj = 1;
        while ( jj <= boardSize )

            %Found something
            if board(jj,ii) ~= 0

                iCS = board(jj,ii);
                lCS = lShip(iCS);
                %fprintf('Discovery!\n %i at b(%i,%i).\n It''s a %s (length of %i).\n',iCS,jj,ii,tShip{iCS},lCS);
                %return;

                %Has it been found already
                if ( fShip(iCS) )
                    %fprintf('Not new!\n Ship type has already been found!\n');
                else
                    %fShip(iCS) = 1;
                    %fprintf('New!\n Ship type has been added to seen!\n');
                end

                if ( fShip(iCS) == 0 )

                    %Check if space in row is sufficient
                    aSpace = jj + lCS - 1;
                    if ( aSpace == 10)
                        %fprintf('Space:\n There is exactly enough space for the ship!\n');
                        aLength = 1;
                    elseif ( aSpace < 10 )
                        %fprintf('Space:\n There is more than enough space open!\n');
                        aLength = 0;
                    elseif ( aSpace > 10 )
                        %fprintf('Space:\n There is NOT enough space for the ship!\n');
                        aLength = -1;
                    end

                    %Check if ship is in fact in row
                    switch aLength
                        case -1
                            %fprintf('error\n');
                        case 0
                            sTemp = board(jj:jj + lCS, ii)';
                            fTemp = ( iCS == sTemp );
                            if all(fTemp)
                                %fprintf('Wrong!\n Ship is longer than it should be!.\n');
                            elseif all(fTemp(1:end-1))
                                %fprintf('Correct!\n Entire ship was found.\n');
                                fShip(iCS) = fShip(iCS) + 1;
                                rFind(iCS) = rFind(iCS) + 1;
                            end
                        case 1
                            sTemp = board(jj:jj + lCS - 1, ii)';
                            fTemp = ( iCS == sTemp );
                            if all(fTemp)
                                %fprintf('Correct!\n Entire ship was found.\n');
                                fShip(iCS) = fShip(iCS) + 1;
                                rFind(iCS) = rFind(iCS) + 1;
                            end
                    end

                    %Move to next empty space
                    jj = jj + lCS - 1;

                elseif ( ( fShip(iCS) == 1 ) && ( rFind(iCS) == 1 ) )
                    %fprintf('Already found!\n Ship was found during the row sweep.\n');
                elseif ( fShip(iCS) > 1 )
                    fShip(iCS) = fShip(iCS) + 1;
                    %r = 0;
                    %fprintf('Wrong!\n Too many ships of this type!\n');

                end

                %fprintf('\n');

            end

            jj = jj + 1;

        end

    end
    r = all(fShip == 1);
    fprintf('RESULT FOR BOARD %i (%s):\n',kk,bNames{kk});
    if ( r )
        fprintf(' CORRECT! All ships were found.\n');
    else
        fprintf(' WRONG! Board does not conform to the rules.\n');
    end
    fprintf('\n');
    
end

clear;


