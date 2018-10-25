function dy = idm(t, y, consts)

h_star = consts.h_0 + y(4) * consts.T  + (y(4) * (y(4) - y(2))) / (2 * sqrt(consts.a_max * consts.b_max));
h = y(1) - y(3) - consts.L;

dy = [
    y(2);
    0;
    y(4);
    consts.a_max * (1 - (y(4) / consts.v_0)^consts.delta - (h_star / h)^2)
    ];

end