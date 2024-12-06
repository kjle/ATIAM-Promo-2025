function [FRF] = CalculFRF_H1(X,Y)
%
%[FRF] = CalculFRF_H1(X,Y)
%
%Fonction permettant de calculer la FRF entre le signal X (entrée) et Y 
%(sortie). X et Y sont 2 vecteurs spectres.
%
%JL Le Carrou 20/07/09 MaJ 17/01/10
%

%% Calcul des interspectres %%
S_YX = Y.*conj(X);
S_YY = Y.*conj(Y);
S_XX = X.*conj(X);

%% Calcul de la FRF %%
FRF = (Y.*conj(X))./(X.*conj(X));
