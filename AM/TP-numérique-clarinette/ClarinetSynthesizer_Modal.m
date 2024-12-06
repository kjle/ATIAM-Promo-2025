function  [p_out,u_out,x_out,pm_out] = ClarinetSynthesizer_Modal(Fs,Nt,Nmodes,g,z,Cms,sms)

persistent eta qr wr a0a a1a a2a b1a... Fixed parameters : regularization and reed
           pms ps us xs...
           u_nm1 pm_nm2 pm_nm1 p_nm1 x_nm1 x_nm2 % Last samples for filters

if isempty(pms)
    eta = 1e-6; % Regularization parameter (reed opening and flow characteristic)
    % Reed filter coefficients (from Guillemain, 2005)
    wr=2*pi*2500; qr=1; a0a = Fs^2/wr^2 + Fs*qr/(2*wr); b1a = 1/a0a; a1a = (2*Fs^2/wr^2 - 1)/a0a; a2a = (Fs*qr/(2*wr) - Fs^2/wr^2)/a0a;
    %wr= inf; qr=0; a0a = 1; b1a = 1/a0a; a1a = 0; a2a = 0;
    % Variables storage
    pms = zeros(Nmodes,Nt);    ps  = zeros(1,Nt);    us  = zeros(1,Nt);    xs  = zeros(1,Nt); u_nm1 = 0; p_nm1 = 0; x_nm1 = 0; x_nm2 = 0;     pm_nm1 = zeros(Nmodes,1);     pm_nm2 = zeros(Nmodes,1); 
end

% Filter coefficients (from Taillard, 2018)
xms = exp(sms/Fs); % Poles, discrete
bm0 = 2*real(Cms)/Fs; V1 = sum(bm0); % Instantaneous component
bm1 = -2*real(Cms.*conj(xms))/Fs; am1 = -2*real(xms); am2 = abs(xms).^2; % Strictly causal component

% Loop
for nst = 1:Nt    
    % RESONATOR -----------------------------------------------------------
    Vm = bm1*u_nm1 - am1.*pm_nm1 - am2.*pm_nm2; % Modal pressures
    V2 = sum(Vm); % Strictly causal part of the pressure
    % REED ----------------------------------------------------------------
    xt = b1a*(p_nm1-g) + a1a*x_nm1 + a2a*x_nm2;% Reed movement (no reed dynamic : the reed follows the pressure difference instantaneously
    xop = 0.5*(xt + 1 + sqrt((xt + 1)^2 + eta)); % Reed opening, to be read as h = (h+abs(h))/2 
    % FLOW ----------------------------------------------------------------
    Dp0 = g - V2; % Analogous to the pressure difference
    W = z*xop; % Reed channel opening
    aDp0 = sqrt(Dp0^2+eta);sDp0 = Dp0/aDp0;% Regularized abs and sign
    ub = 0.5 * sDp0* W * ( -V1*W + sqrt((V1*W)^2 + 4*aDp0) ); % Flow due to the pressure difference (Bernoulli)
    % RECOMBINATION -------------------------------------------------------
    u = ub; % Total flow entering the instrument.
    pm = bm0*u + Vm; % Modal pressure evolution, adding the instantaneous term
    p = sum(pm); % Total pressure : sum of the modal pressures
    x = xop-1;% Reed displacement : limited
    ps(nst) = p;    us(nst) = u;    xs(nst) = x; pms(:,nst) = pm;
    u_nm1 = u;  pm_nm2 = pm_nm1; pm_nm1 = pm; p_nm1 = p; x_nm2 = x_nm1; x_nm1 = x;
end
% Output
pm_out = pms; p_out = ps; u_out = us; x_out = xs;
