% script pour programmer la NMF
% réalise les affichages
% les parties de création des données et de mise à jour sont à
% compléter
% TP NMF / B. David & P. Magron, Janvier 2015

clear all; 
close all;

% création des données 
Fe = 8000;
Nfft = 512;
 
% construction de la base spectrale W
% -----------------------------------
fnote = [100 232] ; % fréquence des notes, do mi par exemple, en Hz
          % à compléter  
fnote = fnote/Fe; % fréquences réduites
R = length(fnote); % nombre de notes

% ici le calcul de W
Ws = zeros(Nfft/2,R);
for r=1:R
    % ici le calcul du spectre pour note r
    Wr = zeros(Nfft/2,1); % à compléter
    Ws(:,r)=Wr;
end

% calcul des activations
%-----------------------
Fh = Fe/(Nfft/4); % fréq. d'échantillonnage pour les activations
DeltaT =0.5; % en seconde
DeltaT = round(DeltaT*Fh);
t = (0:DeltaT-1)/Fh;
tau = 0.3 ; % à compléter
h = exp(-t/tau);
z = zeros(1,DeltaT);

Hs = [h z z;z h z] ; % à compléter à l'aide de h et z. 

% calcul de la représentation de départ
Xs = Ws*Hs;

% affichage
F = size(Ws,1);
T = size(Hs,2);
freq = (0:F-1)/Nfft*Fe;
ts = (0:T-1)/Fe;

figure
imagesc(ts,freq,Xs);axis xy
xlabel('temps')
ylabel('fréquence')
title('Représentation temps/fréquence originale');

pause


% calcul de la NMF
% ----------------

% initialisation
W = zeros(size(Ws)); % à compléter
H = zeros(size(Hs)); % à compléter 

Nit = 100; % nombre d'itération

figure('position',[200 50 800 600]);
ha = annotation('textbox',[7 85 5 5]/100,'string','0');
annotation('textbox',[5 92 10 5]/100,'string','# Iterations','edgecolor','none');

for k=1:Nit
    
    V = W*H; % calcul de la représentation approchée
    
    % affichage
    subplot('position',[25 8 70 67]/100)
    imagesc(ts,freq,V);axis xy;set(gca,'yticklabel',[])
    xlabel('temps (s)')
    
    subplot('position',[10 8 12 67]/100)
    imagesc(1:size(H,1),freq,W);
    title('Atomes $\mathbf{W}$','interpreter','latex')
    axis xy;ylabel('fréquence (Hz)')
    
    subplot('position',[25 80 70 15]/100)
    imagesc(ts,1:size(H,1),H);
    title('Activations temporelles $\mathbf{H}$','interpreter','latex')
    set(gca,'xticklabel',[]);set(gca,'ytick',1:size(H,1))
    set(ha,'string',num2str(k));
    drawnow
    pause(0.1)
    
    % update de H
    H = H ; % à modifier
    
    % update de W
    W = W ; % à modifier
    

end
