import("stdfaust.lib");

process = fmoog(1000);

T3 = -1/3;
fmoog(fc) = _,0 : M : M : M : M : S with {
    F1 = *(a) : + ~ *(b) with {
        nu = 2 * ma.PI * fc / ma.SR;       
        a = nu / (nu + 1);
        b = 1 / (nu + 1);
    };

    M(u1, u3) = F1(u1), F1(u3 + u1^3 - F1(u1)^3);

    S(y1, y3) =  y1 + T3 * y3;
};
