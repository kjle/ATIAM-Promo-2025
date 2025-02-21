% 2D wave equation solver: basic, zero initial conditions, Dirichlet
% conditions, point source

% vector/matrix implementation

% S. Bilbao, 3 July 2021
% Acoustics and Audio Group
% University of Edinburgh

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%% flags

plot_on = 1;            % enable plotting in the run time loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%% parameters

SR = 100000;             % sample rate (Hz)

L = 1;                  % domain side length (m)
c = 344;                % wave speed (m/s)

Tf = 0.01;              % duration of simulation (s)
sig = 0.5e-4;             % time constant for Gaussian source
ctr = [0.2 0.3];        % coordinates of source (m)
amp = 1;                % amplitude of source

lambda = 1/sqrt(2);     % Courant number <= 1/\sqrt(2)            

%%%%%%%%%%%%%%%%%%%%%%%%%%%% derived parameters

k = 1/SR;               % time step (s)

h = c*k/lambda;         % set grid spacing from Counrant number
N = floor(L/h);         % determine integer number of segments length h dividing L evenly
h = L/N;                % reset grid spacing
lambda = c*k/h;         % reset Courant number

Nf = floor(Tf*SR);      % number of time samples to run simulation 

% set up difference matrices

e = ones(N-1,1);
D1 = spdiags([e -2*e e], -1:1,N-1,N-1);
I = speye(N-1);
D2 = kron(D1, I)+kron(I,D1);
B = 2*speye((N-1)^2)+lambda^2*D2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% source setup

% generate Guassian source signal

t0 = sig*sqrt(2)*sqrt(16*log(10));
t = [0:Nf-1]'*k;
vs = amp*exp(-0.5*(t-t0).^2/sig^2);

% generate vector to drive scheme (dipole!)

xi_ind = floor(ctr(1)*N/L);
yi_ind = floor(ctr(2)*N/L);
J = sparse((N-1)^2,1);
J((N-1)*yi_ind+xi_ind) = c^2*k^2/h^3;
J((N-1)*yi_ind+xi_ind-1) = -c^2*k^2/h^3;

% initialize grid functions

psi1 = zeros((N-1)^2,1); % initialise unknown grid function (at the next time step)
psi2 = zeros((N-1)^2,1); % initialise unknown grid function (at the next time step)
psi = zeros((N-1)^2,1); % initialise unknown grid function (at the next time step)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main loop

for n=1:Nf
    
    % main update: calculate next values of psi from values at two previous
    % time steps (vector/matrix form)
    
    psi = B*psi1-psi2+vs(n)*J;
    
    % plot 
    
    if(plot_on)
        
        psiplot = reshape(psi,N-1,N-1);
        surf([1:N-1]*h, [1:N-1]*h, psiplot');
        xlabel('x (m)')
        ylabel('y(m)')
        shading interp
        axis equal
        view(2)
        drawnow
        
    end
    
    % reset state in preparation for next iteration
    
    psi2 = psi1;
    psi1 = psi;
    
end


