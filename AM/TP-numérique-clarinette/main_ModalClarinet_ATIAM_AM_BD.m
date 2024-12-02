clear functions
clear
close all hidden

% Control
ADW = audioDeviceWriter('SampleRate',44100);
Nt = 1024;%512; % Sound frame length. Controls are read once every Nt samples at rate Fs.

% 'Fs' sampling rate (audio)
Fs = 44100;
% 'Nmodes' Number of modes
Nmodes = 3;

% Initial control parameters
gamma = 0.7; % Blowing pressure parameter
zeta = 0.5; % Reed opening parameter
load('ComplexModalParameters_ZClarinetteSib.mat','Cn','sn')
Cms = Cn(1,1:Nmodes).';
sms = real(sn(1,1:Nmodes).') + 1i*2*pi*220*(2*(1:Nmodes)-1).';
fms = imag(sms/2/pi);

f = 1:5000;
w = 2*pi*f;

%% UI

% Control limits
gammalim = [0 2]; zetalim = [0 2]; flim = [20 3000]; Clim = 1000*[0 ceil(1.1*max(Cn(:))/1000)];
g = gamma;
z = zeta;

% Building UI control figure
dxui = 600; % Width of the control area (without the plot area)
fig = uifigure('Number',666); fig.Position = [0 50 dxui+900 650]; fig.Name = 'Synth Control Panel'; fig.Interruptible = 'off'; 
% fig.Renderer = "painters";
if isprop(fig,'KeyPressFcn')
    fig.KeyPressFcn = @(app,event) UIFigureKeyPress(app,event);
end
set(groot,'defaulttextinterpreter','latex');
% Control sliders
sldg = uislider(fig,'Tag','sldg','Limits',gammalim,'Position',[50 400 dxui-100 3],'Value',gamma,'MajorTicks',[0 1/3 1/2 1 1.5 2],'MajorTickLabels',{'0' '1/3' '0.5' '1' '1.5' '2'},'MinorTicks',0:0.1:1.4,'ValueChangingFcn',@(sldg,event) assignvar(event,sldg,'g'));
uilabel(fig,'Position',[50 410 280 20],'Text','Blowing pressure parameter $\gamma$','interpreter','latex');
sldz = uislider(fig,'Tag','sldz','Limits',zetalim,'Position',[50 300 dxui-100 3],'Value',zeta,'MajorTicks',zetalim(1):0.5:zetalim(2),'MinorTicks',zetalim(1):0.1:zetalim(2),'ValueChangingFcn',@(sldz,event) assignvar(event,sldz,'z'));
uilabel(fig,'Position',[50 310 180 20],'Text','Reed opening parameter $\zeta$','interpreter','latex');
% Modal parameters
sldfms = cell(Nmodes,1); 
sldCms = cell(Nmodes-1,1);
for imode = 1:Nmodes
    uilabel(fig,'Position',[50+(imode-1)/Nmodes*(dxui-50) 200 (dxui-150)/Nmodes 20],'Text',['Modal frequency $f_' int2str(imode) '$ (Hz)'],'interpreter','latex');
    if imode > 1
        sldCm = uislider(fig,'Limits',Clim+500*(imode==1),'Position',[50+(imode-1)/Nmodes*(dxui-50) 100 (dxui-150)/Nmodes 3],'Value',Cms(imode),'MajorTicks',Clim(1):500:Clim(2),'MinorTicks',Clim(1):100:Clim(2),'ValueChangingFcn',@(sldCm,event) evalinvar(event,sldCm,['Cms(' int2str(imode) ')'])); 
        uilabel(fig,'Position',[50+(imode-1)/Nmodes*(dxui-50) 110 (dxui-150)/Nmodes 20],'Text',['Modal residue $C_' int2str(imode) '$'],'interpreter','latex');
        sldCms{imode-1} = sldCm;
    else
        sldfm1 = uieditfield(fig,'Numeric','Position',[50+(imode-1)/Nmodes*(dxui-50) 170 (dxui-150)/Nmodes 25],'Value',imag(sms(imode))/(2*pi),'Limits',flim,'ValueChangedFcn',@(sldfm1,event) evalinvar(sldfm1,event,'fms(1)'));
    end
end
        btevenh = uibutton(fig,'Text',['f_2 = 2f_1, f_3 = 3f_1'],'Position',[50+1.5/Nmodes*(dxui-50) 140 (dxui-150)/Nmodes 25],'ButtonPushedFcn',@(bt,event) evalinvars(event,bt,{'fms(2)','fms(3)'},{2*sldfm1.Value,3*sldfm1.Value}));
        btoddh = uibutton(fig,'Text',['f_2 = 3f_1, f_3 = 5f_1'],'Position',[50+1.5/Nmodes*(dxui-50) 170 (dxui-150)/Nmodes 25],'ButtonPushedFcn',@(bt,event) evalinvars(event,bt,{'fms(2)','fms(3)'},{3*sldfm1.Value,5*sldfm1.Value}));

% Utility
stopbutton = uibutton(fig,'state','Position',[dxui*0.2 500 dxui*0.2 100],'Text','Stop/start synth');
signalled = uilamp(fig,'Position',[0.425*dxui 525 dxui*0.05 dxui*0.05],'Color',[0 0 0]); uilabel(fig,'Position',[signalled.Position(1:2)+[signalled.Position(3)*0.1 -signalled.Position(4)*0.5-20] 50 50],'Text','Signal');
clipled = uilamp(fig,'Position',[0.525*dxui 525 dxui*0.05 dxui*0.05],'Color',[0 0 0]); uilabel(fig,'Position',[clipled.Position(1:2)+[clipled.Position(3)*0.25 -clipled.Position(4)*0.5-20] 50 50],'Text','Clip');
recbutton = uibutton(fig,'State','Position',[dxui*0.6 500 dxui*0.2 100],'Text','Record sound file');
% Impedance plot
refreshbutton = uibutton(fig,'State','Position',[dxui+50 550 300 50],'Text','Refresh impedance plot');
Zmodax = uiaxes(fig,'Units','pixels','Position',[dxui  325 400 200],'xlim',[0 flim(2)]);
Zmodax.XGrid = 'on'; Zmodax.XTick = 0:100:flim(2); Zmodax.XTickLabel(~~mod(Zmodax.XTick,500)) = {''};
Zmodax.YLabel.String = '$|Z|/Z_c$'; Zmodax.YGrid = 'on';
Zmodax.ColorOrder = [cool(Nmodes) ; 0 0 0];
Zmods = Cms./(1i*w - sms) + conj(Cms)./(1i*w - conj(sms)); % Recomputing Z with current values of poles and residues
plot(Zmodax,f,abs(Zmods),f,abs(sum(Zmods)),':');
Zleg = cell(1,Nmodes+1); for im = 1:Nmodes, Zleg{im} = ['Mode ' int2str(im)];end; Zleg{end} = 'Total';
legend(Zmodax,Zleg)
Zangax = uiaxes(fig,'Units','pixels','Position',[dxui 125 400 200],'xlim',[0 flim(2)]);
Zangax.XLabel.String = '$f$ (Hz)'; Zangax.XGrid = 'on'; Zangax.XTick = 0:100:flim(2); Zangax.XTickLabel(~~mod(Zangax.XTick,500)) = {''};
Zangax.YLabel.String = '$\angle Z$ (rad)'; Zangax.YGrid = 'on'; Zangax.YTick = -pi/2:pi/4:pi/2; Zangax.YTickLabel = {'$-\frac{\pi}{2}$','$-\frac{\pi}{4}','0','$\frac{\pi}{4}$','$\frac{\pi}{2}$'}; % :pi/4:pi/2];
Zangax.ColorOrder = [cool(Nmodes) ; 0 0 0];
plot(Zangax,f,angle(Zmods),f,angle(sum(Zmods)),':');
% Bifurcation diagram
BDdrawbutton = uibutton(fig,'State','Position',[dxui+450 550 150 50],'Text','Draw bifurcation diagram','Enable',0);
BDresetbutton = uibutton(fig,'State','Position',[dxui+675 550 150 50],'Text','Reset bifurcation diagram');
NsBD = 8*Nt;
sBD = zeros(NsBD,1);
pgs = zeros(NsBD/Nt,1);
pzs = zeros(NsBD/Nt,1);

%% Synth
rec_in_progress = 0;
while 1
    % Updating parameters is done via callback functions called in the
    % sliders
	sms = real(sms) + 1i*2*pi*fms(:); % Updating poles imaginary part
    if refreshbutton.Value % Replotting impedance modulus and argument
        Zmods = Cms./(1i*w - sms) + conj(Cms)./(1i*w - conj(sms)); % Recomputing Z with current values of poles and residues
        plot(Zmodax,f,abs(Zmods),f,abs(sum(Zmods)),':'); plot(Zangax,f,angle(Zmods),f,angle(sum(Zmods)),':'); % Plotting
        legend(Zmodax,Zleg)
        refreshbutton.Value=0; % Housekeeping
    end
    if BDresetbutton.Value % Initialize / reinitialize bifurcation diagram
        if exist('BDax','var')
            delete(BDax);
            delete(BDbar);
        end
        BDax = uiaxes(fig,'Position',[dxui + 425 100 500 400],'xlim',gammalim,'ylim',zetalim,'zlim',[0 1],'CLim',[0.4*min(fms) 1.1*max(fms)],'ButtonDownFcn',@(src,event) BDcallback(src,event,sldg,sldz));
        BDax.XLabel.String = '$\gamma$'; BDax.XGrid = 'on'; BDax.XTick = 0:0.1:gammalim(2); BDax.XTickLabel(~~mod(10*BDax.XTick,5)) = {''};
        BDax.YLabel.String = '$\zeta$'; BDax.YGrid = 'on'; BDax.YTick = 0:0.1:zetalim(2); BDax.YTickLabel(~~mod(10*BDax.YTick,5)) = {''};
        BDax.Colormap = [0 0 0; 0.7*hsv(60)];
        BDax.CLim = [0.4*min(fms) 1.1*max(fms)];
        bd = scatter3(BDax,NaN,NaN,NaN,20,NaN,'filled');
        BDbar = colorbar(BDax)
        
        sBD = zeros(NsBD,1);
        pgs = zeros(NsBD/Nt,1);
        pzs = zeros(NsBD/Nt,1);
        BDresetbutton.Value=0; % Housekeeping
        BDdrawbutton.Enable = 1;
    end
    
    stopsynth = stopbutton.Value; % Check stop button state
    
    if ~stopsynth
        if strcmp(recbutton.Enable,'on') % Check record button state
            recstart = recbutton.Value; % If record button was pressed, raise the 'start recording' flag
        end
        
        % Synthesizing sound
        [p_out,u_out,x_out,pm_out] = ClarinetSynthesizer_Modal(Fs,Nt,Nmodes,g,z,Cms,sms);
        
        % Preparing audio output
        s = 0.5*p_out; % Sound to be played
        signalled.Color = min(1,sqrt(rms(s)))*[0 1 0]; % Light up in green depending of the sound level
        clipled.Color = (max(s)>1)*[1 0 0]; % Light up in red if audio output saturates
        % Providing sound to the audio device is done here
        ADW([s(:) s(:)]); %
        %
        if BDdrawbutton.Value % Erase bifurcation diagram
            sBD = [sBD(Nt:end); s(:)];
            pgs = [pgs(2:end); g];
            pzs = [pzs(2:end); z];
            if (length(unique(pgs))==1)&&(length(unique(pzs))==1)&&(~any((bd.XData==g)&(bd.YData==z))) % Control parameters are static, but not on a point that was already drawn
                A = rms(sBD-mean(sBD));
                NTs = diff(find(diff(sign(sBD))>0));
                f0 = Fs/mean(NTs) * (A>1e-3);
                if isnan(f0), f0=0; end
                bd.XData = [bd.XData g];
                bd.YData = [bd.YData z];
                bd.ZData = [bd.ZData A];
                bd.CData = [bd.CData f0];
            end
        end
        
        
        if recstart % initialize the recording process : create a matrix to be saved as sound file, and deal with the button
            irec = 0; sound_to_wav = zeros(ceil(44100/Nt)*Nt,2); recbutton.Enable = 'off'; recstart = 0; rec_in_progress = 1;
        end
        if rec_in_progress % saving one second of sound goes across several audio buffers, so it must be done across several iteration of the while loop
            if (irec + Nt) < length(sound_to_wav) % not yet filled the sound matrix
                sound_to_wav(irec+(1:Nt),:) = [s(:) s(:)]; % fill sound matrix with current buffer
                irec = irec+Nt; % increment position in the sound matrix
            elseif (irec + Nt) == length(sound_to_wav) % almost ready to save...
                sound_to_wav(irec+(1:Nt),:) = [s(:) s(:)]; % finish filling up the matrix
                audiofilename = [cd filesep 'p_g' strrep(num2str(g,3),'.',',') '_z' strrep(num2str(z,3),'.',',') '_' datestr(now,'yyyymmddTHHMMSS') '.flac'];
                audiowrite(audiofilename,sound_to_wav,Fs); % proper saving
                NTs = diff(find(diff(sign(sound_to_wav))>0)); % Samples per estimated period (rough)
                if ~isempty(NTs)
                f0 = Fs/mean(NTs); % Estimated fundamental frequency
                its = 1:sum(NTs(1:10)); t = its/Fs; 
                Nfft = 16384; spectrum = db(fft(sound_to_wav,Nfft));
                figure(1); clf;
                subplot(211); plot(t,sound_to_wav(its),'k'); grid on; hold on; xlim([0 10/f0]); ylim([-inf inf]);  xlabel('t (s)'); ylabel('p(t)'); 
%                ifilesep = regexp(audiofilename,filesep); ilb = ifilesep(diff(floor(ifilesep/50))>0); 
%                iss = [[1 ilb+1].' [ilb length(audiofilename)].']; cind = arrayfun(@colon,iss(:,1),iss(:,2),'UniformOutput',false); 
%                title(cellfun(@(c) audiofilename(c),cind,'UniformOutput',false))
                subplot(212); plot((0:Nfft-1)*Fs/Nfft,spectrum,'k'); grid on; hold on; xlim([0 2000]); ylim(max(spectrum) + [-50 0]); xlabel('f (Hz)');  ylabel('P(f) (dB)');
                line([f0 f0],get(gca,'ylim'),'color','r','linewidth',1); text(f0+10,max(get(gca,'ylim'))-5,['Estimated fundamental : ' num2str(f0,4) ' Hz'])
                end
                rec_in_progress = 0; recbutton.Value = 0; recbutton.Enable = 'on'; % housekeeping
                fprintf('\b\nAt time %s, saved sound file to %s.\n',datestr(now),audiofilename) % print to matlab console
                msgbox(sprintf('\b\nAt time %s, saved sound file to %s.\n',datestr(now),audiofilename)) % print to matlab console
            else
                error('Problem in saving the signal : too long.')
            end
        end
    end
    
    drawnow limitrate; % Check the value of UI elements, but not too often (to avoid messing with audio stream)
end

% Useful functions for the interface

function assignvar(event,sld,varstr)
    assignin('base',varstr,event.Value);
%evalin('base',[varstr '=' num2str(event.Value) ';']);
%drawnow;
end

function evalinvar(event,sld,varstr)
evalin('base',[varstr '=' num2str(event.Value) ';']);
end

function evalinvars(event,sld,Cvarstrs,Cvalues)
if iscell(Cvarstrs)
    for iv = 1:length(Cvarstrs)
        varstr = Cvarstrs{iv}; val = Cvalues{iv};
        evalin('base',[varstr '=' num2str(val) ';']);
    end
else
    evalin('base',[Cvarstrs '=' num2str(Cvalues) ';']);
end
end

function BDcallback(src,event,sldg,sldz)
    g = event.IntersectionPoint(1);
    z = event.IntersectionPoint(2);
    sldg.Value = g;
    sldz.Value = z;
    sldg.ValueChangingFcn(sldg, sldg)
    sldz.ValueChangingFcn(sldg, sldz)
end
function UIFigureKeyPress(app, event)
key = event.Key; % get the pressed key value
if strcmp(key,'leftarrow')
    sld = findobj(app.Children,'Tag','sldg');
    sld.Value = sld.Value-0.01; % get the slider value
elseif strcmp(key,'rightarrow')
    sld = findobj(app.Children,'Tag','sldg');
    sld.Value = sld.Value+0.01; % get the slider value
elseif strcmp(key,'uparrow')
    sld = findobj(app.Children,'Tag','sldz');
    sld.Value = sld.Value+0.01; % get the slider value
elseif strcmp(key,'downarrow')
    sld = findobj(app.Children,'Tag','sldz');
    sld.Value = sld.Value-0.01; % get the slider value
end
sld.ValueChangingFcn(app, sld)
end

