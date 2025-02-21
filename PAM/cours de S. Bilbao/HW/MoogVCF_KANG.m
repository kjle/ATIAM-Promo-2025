%++++++++++++++++++++++++++++++++++++++++ 
% Moog VCF 
% 
% KANG Jiale
% 22 Jan 2025 
% Matlab R2019b
%++++++++++++++++++++++++++++++++++++++++

clc
clear all
close all

%++++++++++++++++++++++++++++++++++++++++ 
% parameters

SR = 44100; % sample rate [Hz]
Tf = 0.2;   % total simulation time [s]
f0 = 120;   % resonant filter frequency [Hz]
r  = 0.7;   % feedback coeff [choose 0 <= r <= 1]

%++++++++++++++++++++++++++++++++++++++++ 
% derived parameters

omega0 = 2 * pi * f0;
Nf = floor(SR*Tf);
k = 1 / SR;

%++++++++++++++++++++++++++++++++++++++++
% check stability condition for Forward Euler

a = sqrt(2) * r^(1/4);
for m = 0:3
    pm = cos((pi + 2 * m * pi) / 4);
    qm = sin((pi + 2 * m * pi) / 4);
    if abs(1 + k * omega0 * (-1 + a * pm + 1j * a * qm)) > 1
        warning("NOT STABLE for %d", m);
    end
end
disp("STABILITY check");

%++++++++++++++++++++++++++++++++++++++++
% initialization

I = eye(4);
A = omega0 * [-1, 0, 0, -4 * r; 1, -1, 0, 0; 0, 1, -1, 0; 0, 0, 1, -1];
b = omega0 * [1, 0, 0, 0]';
c = [0, 0, 0, 1]';

xf = zeros(4, 1);
xb = zeros(4, 1);

yf = zeros(Nf, 1);
yb = zeros(Nf, 1);

u = [1; zeros(Nf-1, 1)];

tvec = [0 : Nf-1]' * k;
fvec = [0 : Nf-1]' * SR/Nf;

%++++++++++++++++++++++++++++++++++++++++
% main loop

tic;
for n = 1: Nf
   xf =  (I + k * A) * xf + k * b * u(n);
   xb = (I - k * A) \ (xb + k * b * u(n));
   
   yf(n) = c' * xf;
   yb(n) = c' * xb;
end
simTime = toc;

%++++++++++++++++++++++++++++++++++++++++
% transfer funciton

Hf = fft(yf);
Hb = fft(yb);

% calculation for continuous TF
Hs = zeros(Nf, 1);
for n = 1: Nf
    Hs(n) = c' * ((1j * 2 * pi * fvec(n)) * I - A)^-1 * b;
end

%++++++++++++++++++++++++++++++++++++++++
% plot

figure(1);
subplot(1, 1, 1);
loglog(abs(Hb), "LineWidth", 2);
hold on
loglog(abs(Hf), "LineWidth", 2);
loglog(abs(Hs), "LineWidth", 2);

grid on;
legend("Forward Euler","Backward Euler","Continuous");
title("Transfer Functions");
xlabel("Frequency [Hz]");
ylabel("Magnitudes");
