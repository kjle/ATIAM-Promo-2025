% 1D wave equation solver: basic, initial conditions only, Dirichlet
% conditions

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

Tf = 0.1;               % duration of simulation (s)
xi = 0.5;               % center of initial distribution (m)
wid = 0.05;             % width of distribution (m)
psi0amp = 0.01;         % amplitude of distribution (nd)

lambda = 1;             % Courant number <=1            

%%%%%%%%%%%%%%%%%%%%%%%%%%%% derived parameters

k = 1/SR;               % time step (s)

h = c*k/lambda;         % set grid spacing from Counrant number
N = floor(L/h);         % determine integer number of segments length h dividing L evenly
h = L/N;                % reset grid spacing
lambda = c*k/h;         % reset Courant number

Nf = floor(Tf*SR);      % number of time samples to run simulation     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% initial condition setup

psi0 = zeros(N+1,1);    % use to store initial condition profile (a lump!)
for qq=1:N+1
    
    x = (qq-1)*h;
    dist = abs(x-xi);
    
    if(dist<=wid)
        psi0(qq) = 0.5*psi0amp*(1+cos(pi*dist/wid));
    end
    
end


psi1 = psi0;          % set initial values of grid functions both to the lump
psi2 = psi0;

psi = zeros(N+1,1);   % initialise unknown grid function (at the next time step)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main loop

for n=1:Nf
    
    % main update: calculate next values of psi from values at two previous
    % time steps
    
    psi(2:end-1) = 2*psi1(2:end-1)-psi2(2:end-1)+lambda^2*(psi1(3:end)-2*psi1(2:end-1)+psi1(1:end-2));
    
    % plot 
    
    if(plot_on)
        plot([0:N]*h, psi, 'k')
        axis([0 L -psi0amp psi0amp])
        xlabel('x (m)')
        ylabel('$\Psi$', 'Interpreter', 'latex')
        drawnow
    end
    
    % reset state in preparation for next iteration
    
    psi2 = psi1;
    psi1 = psi;
    
end


