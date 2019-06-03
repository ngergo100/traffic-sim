% close all
% clear
% clc

%load('times2.mat')

dotmax = 40;
dotmin = 10;

figure_size = [10,10,15,8];

f1 = figure('Name','Variations', 'Units','centimeters', 'Position',figure_size);
f1.Renderer='Painters';
for i=1:size(times,2)
    hold all;
    timetable = nonzeros(times(:,i));
    stds(i) = std(timetable);
    avgs(i) = mean(timetable);
    maxs(i) = max(timetable);
    mins(i) = min(timetable);
    counts = sum(nonzeros(times(:,i))==nonzeros(times(:,i))');
    if length(timetable) > 1
        for j=1:length(timetable)
            plot(i,timetable(j), '.','MarkerSize', dotmin + (dotmax-dotmin)/(max(counts)-min(counts))*(counts(j)-min(counts)), 'color',[46/255,  204/255, 113/255])
            plot(i,timetable(j), '.','MarkerSize',10, 'color',[46/255,  204/255, 113/255])
        end
    else
        plot(i,timetable(1), '.','MarkerSize', dotmin + (dotmax-dotmin)/2, 'color',[46/255,  204/255, 113/255])
    end
    
end
set(gca,'fontsize',8')
xlabel('SelfDrivingCarCount')
ylabel('t[s]')
print('Resources/variations2','-depsc');

figure('Name','Variations', 'Units','centimeters', 'Position',figure_size);
hold all;
plot(avgs,'-o')
plot(maxs,'-o')
plot(mins,'-o')
set(gca,'fontsize',8')
xlabel('SelfDrivingCarCount')
ylabel('t[s]')
legend({'Average', 'Max', 'Min'})
print('Resources/variations_avgminmax2','-depsc');

figure('Name','Standard deviation', 'Units','centimeters', 'Position',figure_size);
plot(stds,'-o')
set(gca,'fontsize',8')
xlabel('SelfDrivingCarCount')
ylabel('Standard deviation [s]')
print('Resources/variations_std2','-depsc');