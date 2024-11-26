function [Signal_Fenetre,Fenetre] = FenetrageExponentiel(Signal, Taux, Indice_deb)
%
%[Signal_Fenetre] = FenetragePorte(Signal,taux)
%
%Fonction permettant de fenêtrée le signal de réponse par une fonction
%exponentielle de taux de décroissance variable. La fenêtre est centrée 
%sur le max du signal.
%Signal est un vecteur colonne. largeur est un multiple de 2.
%
%JL Le Carrou 16/07/09 MaJ 17/01/10
%

%% Fenêtre %%
Fenetre = zeros(length(Signal),1);
Fenetre(Indice_deb:end) = exp(-Taux*[1:1:length(Signal)-Indice_deb+1]);

%% Fenêtrage %%
Signal_Fenetre = Signal.*Fenetre;

%% Affichage %%
% figure, 
% subplot(2,1,1), hold on, plot(Signal,'b'), plot(Fenetre, 'r'), hold off
% subplot(2,1,2), plot(Signal_Fenetre,'b');

   