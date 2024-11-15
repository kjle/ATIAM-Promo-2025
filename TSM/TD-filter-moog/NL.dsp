import("stdfaust.lib");

process = E(1000);

F1(fc) = *(a) : + ~ *(b) with {
    nu = 2 * ma.PI * fc / ma.SR;       
    a = nu / (nu + 1);
    b = 1 / (nu + 1);
};

NL(fc) =  _<: F1(fc), _            // devide into 2 parts in parallel
            : (_ <: _, _), _        // branch 1 devide into 2 parts in parallel and parallel with branch 2
            : _, ^(3), ^(3)         // identity, cubic, cubic in parallel
            : _, *(-1), _           // identity, (-1), identity in parallel
            : _, (+ : *(T3): F1(fc))// add with last two branches and follow by T3 F1
            : +;                    // two branches add
T3 = -1/3;