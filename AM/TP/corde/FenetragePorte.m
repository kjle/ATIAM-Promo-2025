function [Signal_Fenetre,Indice_deb,Fenetre] = FenetragePorte(Signal,largeur)
%
%[Signal_Fenetre] = FenetragePorte(Signal,largeur)
%
%Fonction permettant de fenêtrée le signal d'impact par une fonction porte
%de largeur variable. La fenêtre est centrée sur le max du signal.
%Signal est un vecteur colonne. largeur est un nombre impair.
%
%JL Le Carrou 16/07/09 MaJ 17/01/10
%

%% Initialisation %%
[Val,Indice] = max(Signal);

%% Fenetre %%
Fenetre = zeros(length(Signal),1);
if floor(Indice-(largeur-1)/2)<0
    Fenetre(1:floor(Indice+(largeur-1)/2)) = ones(floor(Indice+(largeur-1)/2),1);
else
    Fenetre(floor(Indice-(largeur-1)/2):floor(Indice+(largeur-1)/2)) = ones(largeur,1);
end

%% Fenêtrage %%
Signal_Fenetre = Signal.*Fenetre;

%% Affichage %%
% figure, 
% subplot(2,1,1), hold on, plot(Signal,'ob'), plot(Fenetre, 'r'), hold off
% subplot(2,1,2), plot(Signal_Fenetre,'b');

%% Indice de sortie %%
Indice_deb = floor(Indice-(largeur-1)/2);