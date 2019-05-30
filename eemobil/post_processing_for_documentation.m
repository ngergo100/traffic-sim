%% Post processing
disp(['Post proceessing'])
identifiers = cat(1, models{:,1});
positions = y(1:2:end,:);
velocities = y(2:2:end,:);
lane_count = length(possible_lane_numbers);
cars_in_lane_count = prepare_lane_count(possible_lane_numbers, lane_config_source);
figure_size = [10,10,15,8];

colors = [
    46/255,  204/255, 113/255;
    52/255,  152/255, 219/255;
    155/255, 89/255,  182/255;
    99/255,  110/255,  114/255;
    241/255, 196/255, 15/255;
    26/255,  188/255, 156/255;
    45/255, 52/255, 54/255;
    142/255, 68/255, 173/255;
    243/255, 156/255, 18/255;
    232/255, 67/255, 147/255;
];

% Headways
headway_figure = figure('Name','Headways', 'NumberTitle','off', 'Units','centimeters', 'Position',figure_size);
headways = prepare_headways(positions, lane_config_source, identifiers);
headway_count = size(headways, 1);

for i=1:lane_count
    clear legendInfoHeadway
    for j=1:headway_count
        hold on;
        box on;
        subplots(i) = subplot(lane_count,1,i);
        headway = headways(j,:);
        lane = lane_config_source(j,:);
        plot(t(lane==possible_lane_numbers(i)), headway(lane==possible_lane_numbers(i)), '.','MarkerSize',0.5, 'color', colors(find(identifiers==identifiers(j)),:))
        if ismember(possible_lane_numbers(i), lane) == 1
            if exist('legendInfoHeadway','var') == 1
                legendInfoHeadway{length(legendInfoHeadway) + 1} = ['h' num2str(identifiers(j))];
            else
                legendInfoHeadway{1} = ['h' num2str(identifiers(j))];
            end
        end
    end
    set(gca,'fontsize',8')
    xlabel('t[s]')
    ylabel('h[m]')
    title(['Lane#' num2str(possible_lane_numbers(i))],'Units', 'normalized', 'Position', [0.075, 1, 0])
    [~,icons] = legend(legendInfoHeadway, 'Location', 'eastoutside');
    set(findobj(icons,'-property','MarkerSize'),'MarkerSize',7)
end
set(subplots,'YLim',[min(headways(:))-1 max(headways(:))+1])
set(gca,'fontsize',8')
print(['Resources/simh_' case_name],'-depsc');

% Velocities
velocity_figure = figure('Name','Velocities', 'NumberTitle','off', 'Units','centimeters', 'Position',figure_size);
velocity_count = size(velocities, 1);

for i=1:lane_count
    clear legendInfoVelocity
    for j=1:velocity_count
        hold on;
        box on;
        subplots(i) = subplot(lane_count,1,i);
        velocity = velocities(j,:);
        lane = lane_config_source(j,:);
        plot(t(lane==possible_lane_numbers(i)), velocity(lane==possible_lane_numbers(i)), '.','MarkerSize',0.5, 'color', colors(find(identifiers==identifiers(j)),:))
        if ismember(possible_lane_numbers(i), lane) == 1
            if exist('legendInfoVelocity','var') == 1
            legendInfoVelocity{length(legendInfoVelocity) + 1} = ['v' num2str(identifiers(j))];
            else
            legendInfoVelocity{1} = ['v' num2str(identifiers(j))];
            end
        end
    end
    set(gca,'fontsize',8')
    xlabel('t[s]')
    ylabel('v[m/s]')
    title(['Lane#' num2str(possible_lane_numbers(i))],'Units', 'normalized', 'Position', [0.075, 1, 0]) 
    [~,icons] = legend(legendInfoVelocity, 'Location', 'eastoutside');
    set(findobj(icons,'-property','MarkerSize'),'MarkerSize',7)
end
set(subplots,'YLim',[min(velocities(:))-0.5 max(velocities(:))+0.5])
set(gca,'fontsize',8')
print(['Resources/simv_' case_name],'-depsc');

lane_count_figure = figure('Name','Lane count', 'NumberTitle','off', 'Units','centimeters', 'Position',[10,10,15,4]);
plot(t,cars_in_lane_count)
legend(cellstr(strcat('l',num2str(possible_lane_numbers))), 'Location', 'eastoutside')
xlabel('t[s]')
ylabel('carcount')
ylim([0 velocity_count])
set(gca,'fontsize',8')
print(['Resources/simcc_' case_name],'-depsc');

fileID = fopen(['Resources/simt_' case_name],'w');
fprintf(fileID, num2str(t(length(t))));
fclose(fileID);