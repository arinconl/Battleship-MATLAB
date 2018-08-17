function displayBoardOnly( board, num )
%displayBoardOnly: Plots locations of ships onto a single figure plot.
%   
%   Input Arguments:
%   board = Board data type to display
%   num = Display iterator; used to decide if create or update figure

    % Global variables imported
    global boardSize;
    
    % Check if figure needs to be created or updated..
    if ( ~num )
        % ..close any open figures and create new figure
        close all;
        figure('Color',[0.8 0.8 0.8], 'menu','none','position',[50 100 360 380]);
    % else
    % ..update currently open figure
    end
    
    % Draw both the gridlines and the ships from the board
    hold on;
    drawGrid();
    drawFleet();
    hold off;
    
    % Format the plot (color, titles, axes, shape)
    set(gca,'Color',[ 26/255 102/255 153/255 ]);
    title(['Board #',num2str(num)]);
    set(gca,'XTick',0.5:10.5,...
        'XTickLabel',{'1','2','3','4','5','6','7','8','9','10'},...
        'XAxisLocation','top');
    set(gca,'YTick',0.5:10.5,...
        'YTickLabel',{'A','B','C','D','E','F','G','H','I','J'},...
        'YDir','reverse');
    axis([ 0 10 0 10 ]);
    axis square;
    box on;
    
    function drawGrid()
    %drawGrid: Draws the gridlines
        for ii = 1:9
            plot( ii*ones(1,100), linspace(0,10,100),...
                '-','color',[ 62/255 162/255 229/255 ]);
            plot( linspace(0,10,100), ii*ones(1,100),...
                '-','color',[ 62/255 162/255 229/255 ]);
        end
    end
    
    function drawFleet()
    %drawFleet: Draws the ships according to their location in the data

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

end

