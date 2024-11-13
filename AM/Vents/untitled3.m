Pabsc = readmatrix('Pabsc.csv');
Prayon = readmatrix('Prayon.csv');

% Parameters
c0 = 343.0;  % m/s
rho0 = 1.2;     % kg/m^3
alpha = [1.044, 1.080];
%%

% Accessing first element of Prayon
a = Prayon(1);  % MATLAB uses 1-based indexing

% Calculate surface area
S = pi * a^2;

% Define frequency range
freqs = 1:0.01:1999.99;  % Create a vector from 1 to 1999.99 with step size 0.01

% Initialize empty array for impedance
Z_input = [];

% Loop through frequencies
for freq = freqs
  % Calculate wave number
  k = 2 * pi * freq / c0;

  % Calculate radiation impedance
  Zr = rho0 * c0 / S * (k * a)^2 / 2 + 1j * rho0 * c0 / S * (8 * k * a / (3 * pi));

  % Call transfer function (assuming transfer_function_continues is defined)
  Z0 = transfer_function_continues(Zr, Pabsc, Prayon, freq);

  % Store impedance in array
  Z_input = [Z_input, Z0];
end

% Plot impedance magnitude and phase
figure(1);  % Create a figure window
subplot(2,1,1);  % Divide the figure into 2 subplots (top)
plot(freqs, abs(Z_input));
xlabel('Frequency (Hz)');
ylabel('Input impedance (Pa/m^3/s)');
title('Input impedance of the trumpet model');

subplot(2,1,2);  % Divide the figure into 2 subplots (bottom)
plot(freqs, angle(Z_input));
xlabel('Frequency (Hz)');
ylabel('Phase (rad)');
title('Phase of the input impedance of the trumpet model');

% Show the plot
hold off;  % Ensure no previous plots are overlaid
%%
[peaks, locs] = findpeaks(abs(Z_input));
freq_resonances = freqs(locs);

for idx = 1:length(locs)
    fprintf('Frequency \t %.2f \t Impedance \t %.4e\n', freqs(locs(idx)), abs(Z_input(locs(idx))));
end
