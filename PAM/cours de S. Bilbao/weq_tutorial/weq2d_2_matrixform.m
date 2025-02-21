% 2D wave equation solver: basic, initial conditions only, Dirichlet
% conditions

% vector/matrix implementation

% S. Bilbao, 3 July 2021
% Acoustics and Audio Group
% University of Edinburgh

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%% flags

plot_on = 1;            % enable plotting in the run time loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%% parameters

SR = 50000;             % sample rate (Hz)

L = 1;                  % domain side length (m)
c = 344;                % wave speed (m/s)

Tf = 0.01;              % duration of simulation (s)
ctr = [0.2 0.3];        % coordinates of center of initial distribution (m)
wid = 0.05;             % radius of distribution (m)
psi0amp = 0.01;         % amplitude of distribution (nd)

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

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% initial condition setup

psi0 = zeros(N-1,N-1);  % use to store initial condition profile (a lump!)

for qq=1:N-1
    
    for rr=1:N-1
        
        x = (qq)*h;
        y = (rr)*h;
        dist = sqrt((x-ctr(1))^2+(y-ctr(2))^2);

        if(dist<=wid)
            
            psi0(qq,rr) = 0.5*psi0amp*(1+cos(pi*dist/wid));
            
        end
        
    end
    
end

% reshape initial condition as a vector

psi0 = reshape(psi0,(N-1)^2,1);

psi1 = psi0;            % set initial values of grid functions both to the lump
psi2 = psi0;

psi = zeros((N-1)^2,1); % initialise unknown grid function (at the next time step)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main loop

for n=1:Nf
    
    % main update: calculate next values of psi from values at two previous
    % time steps (vector/matrix form)
    
    psi = B*psi1-psi2;
    
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


