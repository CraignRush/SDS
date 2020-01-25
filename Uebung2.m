%% Übung 2 - Systemtheorie der Sinnesorgane

% Define figure properties
clear all;
close all;


%% 1.
p0 = 20e-6; %Pa
f_s = 20000; % Hz
f = 1000; %Hz
lautstaerke = 60; %dB
duration = 1; %s
t_i = 0:1/f_s:duration;
p_static    =  1e5; % static pressure / Pa

P = @(t) sqrt(2) * 10^(lautstaerke/20)* p0 * sin(2 * pi * f * t);

sig = P(t_i);
sig(sig==0) = 1e-42;

figure;
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 12 6]);
fontSize=8;
plot(t_i(1:61).*1000,sig(1:61),'k','LineWidth',1)
hold on
plot(t_i(1:61).*1000,0.02+0*(1:61),'r','LineWidth',1);
plot(t_i(1:61).*1000,-0.02+0*(1:61),'r','LineWidth',1);
xlabel('t / ms');
ylabel('p_{Sig}(t) / Pa');
print('ue2_fig/sig', '-depsc')

[sig_fft,sig_f_i] = fft_f(sig,f_s);
L_U = 20*log10(sig_fft/p0);

figure;
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 12 6]);
plot(sig_f_i,real(L_U),'LineWidth',1);
xlim([1 11000]);
ylim([-80 69]);
xticks([1,10,100,1000,10000]);
yticks([-80:20:60]);
xlabel('f / Hz');
ylabel('SPL_{Sig} / dB');
set(gca,'xscal','log');
print('ue2_fig/L_U_sig', '-depsc')
    
%%

%sound(sig, 20000);

h = blackman(5000);
soundsig = sig;
soundsig(1:2500) = sig(1:2500)'.*h(1:2500);
soundsig(end-2500:end) = sig((end-2500):end)'.*h(2500:end);
scale_factor = rms(soundsig)/0.02;
soundsig = soundsig./ scale_factor;

figure;
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 12 6]);
fontSize=8;
plot(t_i(1:2641).*1000,soundsig(1:2641),'k','LineWidth',1)
hold on
plot(t_i(1:2641).*1000,0.02+0*t_i(1:2641),'r','LineWidth',1);
plot(t_i(1:2641).*1000,-0.02+0*t_i(1:2641),'r','LineWidth',1);
xlim([0 133]);
xlabel('t / ms');
ylabel('p_{Sig}(t) / Pa');
print('ue2_fig/soundsig', '-depsc')


% pause(2);
% sound(soundsig, 20000);

audiowrite('60dBSPL.wav',soundsig,f_s);
clear all

%%
[y,f_s]  = audioread('60dBSPL.wav');
[nuss,f_nuss]  = audioread('Nuss.wav');
[w,f_w]  = audioread('fcmg0-W1-t.wav');
% 
% sound(nuss,f_nuss);
% pause(2);
% sound(w,f_w);

nuss(nuss==0) = 1e-12;
scale_factor = rms(nuss)/0.02;
nuss_scaled = nuss ./ scale_factor;

w(w==0) = 1e-12;
scale_factor = rms(w)/0.02;
w_scaled = w ./ scale_factor;
rms(w_scaled);

% sound(nuss,f_nuss);
% pause(2);
% sound(nuss_scaled,f_nuss);
% pause(2);
% sound(w,f_w);
% pause(2);
% sound(w_scaled,f_w);
%% Nuss Pegel Spektrum
[nuss_spektrum,f_i] = fft_f(nuss_scaled,f_nuss);

nuss_pegel_spektrum = 20*log10(nuss_spektrum./20e-6);

figure;
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 12 6]);
semilogx(f_i,real(nuss_pegel_spektrum),'LineWidth',1);
xlim([0.8 40000]);
xticks(logspace(0,4,5));
xlabel('f / Hz');
ylabel('SPL_{Nuss} / dB');
print('ue2_fig/nuss_pegel', '-depsc')
%% W Pegel Spektrum
[w_spektrum,f_w_fft] = fft_f(w_scaled,f_w);
w_pegel_spektrum = 20*log10(w_spektrum./20e-6);
figure;
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 12 6]);
semilogx(f_w_fft,real(w_pegel_spektrum),'MarkerSize',3);
%ylim([-0.1 7]);
xlabel('f / Hz');
ylabel('SPL_w / dB');
print('ue2_fig/w_pegel', '-depsc')
%% Nuss a-weighted
sa = filter(design(fdesign.audioweighting('WT,Class','A',1,f_nuss)),nuss_scaled);
[sa_fft,f_sa_fft] = fft_f(sa,f_nuss);
L_a = 20*log10(sa_fft./20e-6);
figure;
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 12 6]);
semilogx(0:length(L_a)-1,real(L_a),'LineWidth',1);
xlim([1 40000]);
xticks([1 10 100 1000 10000]);
xlabel("f / Hz");
ylabel("SPL_{Nuss} / dB(A)");
print('ue2_fig/sa_nuss_pegel', '-depsc')


figure;
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 12 6]);
x =(1:length(sa))./f_nuss;
plot(x(9262:40793),sa(9262:40793),'LineWidth',1);
xlim([0.19 0.92]);
xlabel('t / s');
ylabel('p_{Nuss}(t) / Pa ');
print('ue2_fig/sa_nuss', '-depsc')

%% w a-weighted
sw = filter(design(fdesign.audioweighting('WT,Class','A',1,f_w)),w_scaled);
[sw_fft, f_sw_fft] = fft_f(sw,f_w);
L_w = 20*log10(sw_fft./20e-6);
figure;
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 12 6]);
semilogx(0:length(L_w)-1,real(L_w),'LineWidth',1);
xlim([1 10000]);
xticks([1 10 100 1000 10000]);
xlabel("f / Hz");
ylabel("SPL_{w} / dB(A)");
print('ue2_fig/sa_w_pegel', '-depsc')


figure;
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 12 6]);
x = (1:length(sw))./f_w;
plot(x(1183:11657),sw(1183:11657),'LineWidth',1);
xlim([0.06 0.73]);
xlabel('t / s');
ylabel('p_{w}(t) / Pa');
print('ue2_fig/sa_w', '-depsc')

%% Spektrogramme
nwin = blackman(256);%256,5
noverlap =128;%220
f_analysis = 256;

figure;
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 12 6]);
colormap bone
spectrogram(nuss_scaled,nwin,noverlap,f_analysis,f_nuss,'yaxis');
view(-5,70)
zticks(-140:40:-60);
title('Word: Nuss');

print('ue2_fig/nuss_spectro', '-depsc')

figure;
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 12 6]);
%colormap hot
colormap bone
spectrogram(sa,nwin,noverlap,f_analysis,f_nuss,'yaxis');
view(-5,70)
zticks(-140:40:-60);
title('A-weighted Word: Nuss');

print('ue2_fig/a_w_nuss_spectro', '-depsc')

figure;

%colormap hot
colormap bone
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 12 6]);
spectrogram(w_scaled,nwin,noverlap,f_analysis,f_w,'yaxis');
view(-5,70)
zticks(-140:40:-60);
title('Letter: W');
print('ue2_fig/w_spectro', '-depsc')

figure;
%colormap hot
colormap bone
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 12 6]);
spectrogram(sw,nwin,noverlap,f_analysis,f_w,'yaxis');
view(-5,70)
zticks(-140:40:-60);
title('A-weighted Letter: w');
colormap bone

print('ue2_fig/a_w_w_spectro', '-depsc')



