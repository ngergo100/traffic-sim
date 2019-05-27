%% Animation
disp(['Animation'])
v = VideoWriter('video','MPEG-4');
v.Quality = 50;
open(v);
ratio = 600/1200;
width = 1200;
fig = figure('Renderer', 'painters', 'Position', [0 0 width width*ratio]);
[img_car, map_car, alphachannel_car] = imread('Pics/bugattismall.png');
[img_bus, map_bus, alphachannel_bus] = imread('Pics/bus.png');
carToFollow = 11;
indexOfChosenCar = find(identifiers==carToFollow);
path_limit = [min(positions(:)) max(positions(:))];

for i = 1:size(positions,2)
    clf(fig)
    for j = 1:length(possible_lane_numbers)-1
        path = path_limit(1);
        while path < path_limit(2)
            plot([path path+8],[(possible_lane_numbers(j)+0.5)*10 (possible_lane_numbers(j)+0.5)*10],'b');
            path = path + 30;
            hold on;
        end
    end
    for j = 1:size(positions,1)
        
        % Group follower
        % Minimum and maximum of current positions vector
        xlimit = [min(positions(:,i))-10 max(positions(:,i))+10];
        
        % Car follower
        %xlimit = [min(positions(indexOfChosenCar,i))-100 max(positions(indexOfChosenCar,i))+100];
        
        ylimit = [0 (xlimit(2) - xlimit(1))*ratio];
        xlim(xlimit);
        ylim(ylimit);
        xPos = positions(j,i);
        
        if lane_config_target(j,i) ~= 0
            [starting, ending] = find_start_end(i, lane_config_target(j,:));
            elapsed_steps = (i-starting)/(ending-starting);
            if isnan(elapsed_steps)
                yPos = lane_config_source(j,i) * 10;
            else
                yPos = (lane_config_source(j,i) + (lane_config_target(j,i) - lane_config_source(j,i)) * easeinout(elapsed_steps, 2)) * 10;
            end
        else
            yPos = lane_config_source(j,i) * 10;
        end
        if should_use_images
            if models{j,6}.L > 10 
                image('CData',img_bus,'XData', [xPos - models{j,6}.L xPos],'YData',[yPos-1 yPos+1],'AlphaData', alphachannel_bus);
            else
                image('CData',img_car,'XData', [xPos - models{j,6}.L xPos],'YData',[yPos-1 yPos+1],'AlphaData', alphachannel_car);
            end
        else
            r = rectangle('Position',[xPos-models{j,6}.L yPos-1 models{j,6}.L 2]);
            if states_of_cars(j,i) == 1
                r.FaceColor = [0 1 0];
            elseif states_of_cars(j,i) == 2
                r.FaceColor = [0 0 1];
            elseif states_of_cars(j,i) == 3
                r.FaceColor = [1 0 0];
            end
            textToWrite = [num2str(identifiers(j)) ' ' num2str(velocities(j,i)*3.6,2)];
            text(xPos-models{j,6}.L + 0.1, yPos, textToWrite)
        end

    end
    legend(cellstr(num2str(t(i))));
    writeVideo(v,getframe);
end
close(v);
disp(['Animation done'])