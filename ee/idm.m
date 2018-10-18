function a = idm(params, consts)

%% IDM constants
%   a_max   [m/s^2]  -> maximal positive acceleration
%   b_max   [m/s^2]  -> maximal negative acceleration
%   v_0     [m/s]    -> maximal (desired) velocity
%   T       [s]      -> following time-gap
%   h_0     [m]      -> static bumper-to-bumper distance
%   delta   [-]      -> acceleration exponent

%% IDM parameters
%   v       [m/s]    -> current speed of the car
%   s       [m]      -> current distance between the car and the car ahead
%   delta_v [m/s]    -> current speed differance between the car and the car ahead

%% Calculate desired safe gap
h_star = consts.h_0 + consts.T * params.v + (params.v * params.delta_v) / (2 * sqrt(consts.a_max * consts.b_max));

%% Calculate current acceleration
% a = consts.a_max * (1 - (params.v / consts.v_0)^consts.delta - (h_star / params.h)^2);

if h_star/params.h > 1
    a = consts.a_max * (1 - (h_star / params.h)^2);
else
    a = consts.a_max * (1 - (params.v / consts.v_0)^consts.delta);
end

end

