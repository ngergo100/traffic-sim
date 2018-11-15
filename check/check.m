clear
clc
close all

starting=7;
ending=200;
step=0.5;
h_stac = starting:step:ending;

for i = 1:length(h_stac)
    f = @(v_stac) idm_stac(v_stac, h_stac(i));
    velocity(i) = fsolve(f, 100);
end

figure();
plot(h_stac, velocity * 3.6)
ylabel('v_{stac} [km/h]')
xlabel('h_{stac} [m]')