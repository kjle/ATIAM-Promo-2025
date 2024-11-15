declare filename "fmoog.dsp";
declare name "fmoog";
import("stdfaust.lib");

process = source(freq, delta) : drive(fmoog(fc));

T3 = -1/3 * checkbox("NL");

fmoog(fc) = _,0 : M : M : M : M : S with {
    F1 = *(a) : + ~ *(b) with {
        nu = 2 * ma.PI * fc / ma.SR;       
        a = nu / (nu + 1);
        b = 1 / (nu + 1);
    };

    M(u1, u3) = F1(u1), F1(u3 + u1^3 - F1(u1)^3);

    S(y1, y3) =  y1 + T3 * y3;
};

drive(C) = *(g) : C : /(g) with {
    g = vslider("drive[style:knob]", 1, 0.1, 20, 0.1);
};

source(f1, df) = os.square(f1) + os.square(f1 + df) : *(0.5);
freq = vslider("freq[style:knob][scale:log][unit:Hz]", 330, 20, 5000, 1);
delta = vslider("delta[style:knob][unit:Hz]", 0.1, 0.05, 2, 0.05);
fc = vslider("fc[style:knob][scale:log][unit:Hz]", 1000, 20, 5000, 1);
