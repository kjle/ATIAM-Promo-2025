clc
clear all
close all

fig_dir = dir(fullfile('*.fig'));
fig_name = {fig_dir.name};

for k = 1 : length(fig_name)
   name = string(fig_name(k));
   h =  openfig(name, 'invisible');
   lines = findobj(h, 'Type', 'line');
   % FRF data
   frequency = get(lines(2), 'XData'); % Hz
   accelerance = get(lines(2), 'YData'); % dB
   phase = get(lines(5), 'YData'); % deg

   save(strcat(name,'.mat'), 'frequency', 'accelerance', 'phase');
end


