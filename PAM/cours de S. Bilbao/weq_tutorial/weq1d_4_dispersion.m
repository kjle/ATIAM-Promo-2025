% 1D wave equation solver: basic, initial conditions only, Dirichlet
% conditions. Sparse matrix form

% illustrates numerical dispersion through both time domain plots and
% spectral plots

% S. Bilbao, 3 July 2021
% Acoustics and Audio Group
% University of Edinburgh

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%% flags

plot_on = 0;            % enable plotting in the run time loop
specplot_on = 1;        % plot output spectrum

%%%%%%%%%%%%%%%%%%%%%%%%%%%% parameters

SR = 44100;            % sample rate (Hz)

L = 1;                  % domain length (m)
c = 1000;                % wave speed (m/s)

Tf = 1;               % duration of simulation (s)
xi = 0.5;               % center of initial distribution (m)
wid = 0.05;             % width of distribution (m)
psi0amp = 0.01;         % amplitude of distribution (nd)
xo = 0.3;               % output location (m);

lambda = 0.5;             % Courant number <=1            

%%%%%%%%%%%%%%%%%%%%%%%%%%%% derived parameters

k = 1/SR;               % time step (s)

h = c*k/lambda;         % set grid spacing from Counrant number
N = floor(L/h);         % determine integer number of segments length h dividing L evenly
h = L/N;                % reset grid spacing
lambda = c*k/h;         % reset Courant number

Nf = floor(Tf*SR);      % number of time samples to run simulation  

%%%%%%%%%%%%%%%%%%%%%%%%%%% state matrix setup

e = ones(N-1,1);
Dxx = spdiags([e -2*e e], -1:1, N-1,N-1);       % second derivative approximation
B = 2*speye(N-1)+lambda^2*Dxx;                  % update matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% initial condition setup

psi0 = zeros(N-1,1);      % use to store initial condition profile (a lump!)
for qq=1:N-1
    x = (qq)*h;
    dist = abs(x-xi);
    if(dist<=wid)
        psi0(qq) = 0.5*psi0amp*(1+cos(pi*dist/wid));
    end
end

psi1 = psi0;          % set initial values of grid functions both to the lump
psi2 = psi0;

psi = zeros(N-1,1);   % initialise unknown grid function (at the next time step)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% output setup

xo_ind = floor(N*xo/L);         % index to gridpoint for output
Q = sparse(N-1,1);              % output vector
Q(xo_ind) = 1;                  
out = zeros(Nf,1);              % output time series

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main loop

for n=1:Nf
    
    % main update: vector matrix form
    
    psi = B*psi1-psi2;
    
    % output
    
    out(n) = Q'*psi;
    
    % plot 
    
    if(plot_on)
        
        figure(1)
        plot([1:N-1]*h, psi, 'k')
        axis([0 L -psi0amp psi0amp])
        xlabel('x (m)')
        ylabel('$\Psi$', 'Interpreter', 'latex')
        drawnow
        
    end
    
    psi2 = psi1;
    psi1 = psi;
    
end

if(specplot_on)
    
    figure(2)
    outfft = fft(out);
    fax = [0:Nf-1]*SR/Nf;
    plot(fax, 20*log10(abs(outfft)), 'k')
    xlim([0 SR/2])
    xlabel('f (Hz)')
    ylabel('transform magnitude')
    
end

