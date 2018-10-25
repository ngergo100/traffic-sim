clc
clear
close all

models = {
    0, 100/3.6, ChillModel;
    -50, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L',4.5));
    -100, 100/3.6, IDModel(struct('a_max',1.5, 'b_max',1.67, 'v_0',130/3.6, 'T',1.8, 'h_0',2, 'delta',4, 'L',4.5));
};

for i=1:size(models)
   y0(2*i-1) = models{i,1};
   y0(2*i) = models{i,2};
end

y0 = y0';

T = 100;

[t,y] = ode45(@(t,y) lane(t, y, models), [0 T], y0);

plotcount = size(models)-1;
plotcount = plotcount(1);
figure();
for i=1:plotcount
    subplot(plotcount,1,i)
    title('Velocity and Headway')
    xlabel('t [s]')
    yyaxis left
    plot(t,y(:,2*i),'-x',t,y(:,2*i+2),'-*')
    ylabel('v [m/s]')
    yyaxis right
    plot(t,y(:,2*i-1)-y(:,2*i+1),'-o')
    ylabel('x [m]')
    legend(['v_' num2str(i)],['v_' num2str(i+1)],['h_' num2str(i) '_' '-' '_' num2str(i+1)])
end