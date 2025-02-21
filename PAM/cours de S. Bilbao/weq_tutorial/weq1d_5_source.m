% 1D wave equation solver: zero initial conditions, Dirichlet
% conditions

% include Gaussian point source

% S. Bilbao, 3 July 2021
% Acoustics and Audio Group
% University of Edinburgh

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%% flags

plot_on = 1;            % enable plotting in the run time loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%% parameters

SR = 200000;            % sample rate (Hz)

L = 1;                  % domain length (m)
c = 344;                % wave speed (m/s)

Tf = 0.001;               % duration of simulation (s)
xi = 0.7;               % location of source (m)
sig = 1e-5;             % Gaussian time constant of source (s)
amp = 1;                % amplitude of source

lambda = 1;             % Courant number <=1            

%%%%%%%%%%%%%%%%%%%%%%%%%%%% derived parameters

k = 1/SR;               % time step (s)

h = c*k/lambda;         % set grid spacing from Counrant number
N = floor(L/h);         % determine integer number of segments length h dividing L evenly
h = L/N;                % reset grid spacing
lambda = c*k/h;         % reset Courant number

Nf = floor(Tf*SR);      % number of time samples to run simulation  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% state matrix setup

e = ones(N-1,1);
Dxx = spdiags([e -2*e e], -1:1, N-1,N-1);       % second derivative approximation
B = 2*speye(N-1)+lambda^2*Dxx;                  % update matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% source setup

% generate Guassian source signal

t0 = sig*sqrt(2)*sqrt(16*log(10));
t = [0:Nf-1]'*k;
vs = amp*exp(-0.5*(t-t0).^2/sig^2);

%return

% generate vector selecting the source location

xi_ind = floor(N*xi/L);
J = sparse(N-1,1);
J(xi_ind) = c^2*k^2/h;

% initialize grid functions to zero

psi1 = zeros(N-1,1);  
psi2 = zeros(N-1,1);
psi = zeros(N-1,1);   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main loop

for n=1:Nf
    
    % main update: vector matrix form
    
    psi = B*psi1-psi2+J*vs(n);
    
    % plot 
    
    if(plot_on)
        
        plot([1:N-1]*h, psi, 'k')
        xlabel('x (m)')
        ylabel('$\Psi$', 'Interpreter', 'latex')
        drawnow
        
    end
    
    % shift state
     
    psi2 = psi1;
    psi1 = psi;
    
end


