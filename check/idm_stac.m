function F = idm_stac(v_stac, hstac)

consts.a_max = 1.5;      %% 0.8 to 2.5 m/s^s
consts.b_max = 1.67;     %% around 2 m/s^s
consts.v_0 = 130/3.6;    %% limit speed
consts.T = 1.8;          %% German recommendation at driving schools
consts.h_0 = 2;          %% standstill minimum gap
consts.delta = 4;        %% acceleration exponent
consts.L = 4.5;          %% acceleration exponent

F = consts.a_max * (1 - (v_stac/consts.v_0)^consts.delta - ((consts.h_0 + v_stac * consts.T) / hstac)^2);

