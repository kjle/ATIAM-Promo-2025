         
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% ACQUISITION
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%close all
g=9.81;
%% Parametres
fs = 25600; %Fréquence d'échantillonnage
tps = 5; %Temps d'acquisition
Sensibilite_Marteau = 23.4e-3; %Unite A MODIF
Sensibilite_Accelero = 105.3e-3; %V/g

%% Acquisition Carte NI (après lancement de Init)
s.Rate = fs;
s.DurationInSeconds= tps;
[data,time] = s.startForeground();
s.wait(); 
s.stop();
s.release();
%% 
Data.Time = time;
signal_marteau = data(:,1)/Sensibilite_Marteau;
signal_accelero = data(:,2)/Sensibilite_Accelero*g;

%% Fenetrage des signaux

%Fenetrage porte du signal du marteau
largeur = 100; %nbre de point
[signal_marteau_fen,Indice_deb,Fenetre_m_libre_1] = FenetragePorte(signal_marteau,largeur);

%Fenetrage exponentiel de la réponse de l'accéléromètre  
Taux = 1e-5;
%deb_libre_1 = find(signal_marteau == max(signal_marteau));
[signal_accelero_fen,Fenetre_libre_acc_1] = FenetrageExponentiel(signal_accelero, Taux, Indice_deb);



%% Calcul de la FRF et de la cohérence
Nfft = 2^nextpow2(length(signal_accelero));
freq = [0:fs/Nfft:fs/2-1/Nfft];

F = fft(signal_marteau,Nfft);
F_fenetre = fft(signal_marteau_fen,Nfft);
A = fft(signal_accelero,Nfft);
A_fenetre = fft(signal_accelero_fen,Nfft);

FRF = CalculFRF_H1(F_fenetre,A_fenetre);

%% Affichage des signaux
scrsz = get(groot,'ScreenSize');
figure('Position',[scrsz(3)/4 1 scrsz(3)/2 scrsz(4)])

axTemp1 = subplot(4,2,1); %Signaux temporels du marteau (non-fenetrés et fenetrés)
plot(time,signal_marteau); hold on
plot(time,signal_marteau_fen, 'r'),
plot(time,Fenetre_m_libre_1*max(signal_marteau),'r')
title('marteau')
xlabel('temps [s]')
ylabel('Force [N]')

axTemp2 = subplot(4,2,3); %Signaux fréquentiels de l'accéléromètre(non-fenetrés et fenetrés)
plot(time,signal_accelero), hold on
plot(time,signal_accelero_fen, 'r')
plot(time,Fenetre_libre_acc_1*max(signal_accelero),'r')
title('accelerometre')
xlabel('temps [s]')
ylabel('Accélération [m.s^{-1}]')

axFreq1 = subplot(4,2,2); %Signaux fréquentiels du marteau (non-fenetrés et fenetrés)
plot(freq,db(F(1:Nfft/2))), hold on
plot(freq,db(F_fenetre(1:Nfft/2)), 'r')
title('marteau')
xlabel('frequence [s]')
ylabel('Force [N]')

axFreq2 = subplot(4,2,4); %Signaux temporels de l'accéléromètre(non-fenetrés et fenetrés)
plot(freq,db(A(1:Nfft/2))), hold on
plot(freq,db(A_fenetre(1:Nfft/2)), 'r')
title('accelerometre')
xlabel('fréquence (Hz)')
ylabel('Accélération [m.s^{-1}]')

axFreq3 = subplot(4,1,3); %Module de la FRF
plot(freq,db(FRF(1:Nfft/2)),'r')
xlabel('fréquence (Hz)')
ylabel('Accélérance [dB]')

axFreq4 = subplot(4,1,4);  %Phase de la FRF
plot(freq,unwrap(angle(FRF(1:Nfft/2))),'r')
xlabel('fréquence (Hz)')
ylabel('Phase [deg]')

linkaxes([axFreq1,axFreq2,axFreq3,axFreq4],'x')
linkaxes([axTemp1,axTemp2],'x')

Final.Data = Data;
Final.marteau.fen = signal_marteau_fen;
Final.accelero.fen = signal_accelero_fen;
Final.marteau.brut = signal_marteau;
Final.accelero.brut = signal_accelero;
Final.FRF = FRF(1:Nfft/2);
Final.freq = freq;
Final.time = time;

file_name = "AA-uk-colb" + "_" + string(datetime('now','format','yyyy_MM_dd_HH_mm_ss')) + ".mat";

save(file_name, 'Final');
