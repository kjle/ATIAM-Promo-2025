import("stdfaust.lib");

process = _ :F1 <: _,_;

nu = 2*ma.PI*hslider("h:moog/freq", 4400, 20, 10000, 1)/ma.SR;       
a = nu / (nu + 1);
b = 1 / (nu + 1);

F1 = *(a) : + ~ *(b);