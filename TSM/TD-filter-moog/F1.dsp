import("stdfaust.lib");

process = F1(1000);

F1(fc) = *(a) : + ~ *(b) with {
    nu = 2 * ma.PI * fc / ma.SR;       
    a = nu / (nu + 1);
    b = 1 / (nu + 1);
};
