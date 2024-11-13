function Z1 = transfer_function(Z2, x1, x2, R1, R2, freq)
    
    % Parameters
    c0 = 343.0;  % m/s
    rho0 = 1.2;     % kg/m^3
    alpha = [1.044, 1.080];

    l = x2 - x1;

    % Handle divergence, convergence, and straight-line cases
    if R1 < R2
        x1 = R1 * l / (R2 - R1);
        x2 = x1 + l;
    elseif R1 > R2
        x2 = -R2 * l / (R1 - R2);
        x1 = x2 - l;
    else
        x1 = inf;
        x2 = inf;
    end

    omega = 2 * pi * freq;
    R = (R1 + R2) / 2;
    lv = 4e-8;
    rv = R * sqrt(omega / (c0 * lv));
    k = omega / c0 * (1 + alpha(1) * (1 - 1i) / rv - alpha(2) / rv^2); % Assuming alpha is a vector

    % Handle infinite and finite cases for A, B, C, D
    if isinf(x1) && isinf(x2)
        A = cos(k * l);
        B = 1i * rho0 * c0 * sin(k * l) / (pi * R1 * R2);
        C = 1i * sin(k * l) * (pi * R1 * R2) / (rho0 * c0);
        D = cos(k * l);
    else
        A = R2 / R1 * cos(k * l) - sin(k * l) / (k * x1);
        B = 1i * rho0 * c0 * sin(k * l) / (pi * R1 * R2);
        C = pi * R1 * R2 / (rho0 * c0) * (1i * sin(k * l) * (1 + 1 / (k^2 * x1 * x2)) + cos(k * l) / (1i * k) * (1/x1 - 1/x2));
        D = R1 / R2 * cos(k * l) + sin(k * l) / (k * x2);
    end

    Z1 = (A * Z2 + B) / (C * Z2 + D);
end
