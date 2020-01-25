%% Übung 4 - Systemtheorie der Sinensorgane
clear all 
close all;
set(0,'DefaultAxesFontName', 'Helvetica')
set(0,'DefaultAxesFontSize', 12)
set(0,'DefaultLineLineWidth',1);
set(0,'DefaultFigurePaperPositionMode','auto');
set(0,'DefaultFigureUnits','Centimeters');
set(0,'DefaultFigurePosition',[2 2 12 6]);


%% 1.
p0 = 20e-6; %Pa
fs = 44100; % Hz
f = 400; %Hz
lautstaerke = 60; %dB
duration = 2; %s
t_i = 0:1/fs:duration;
p_static    =  1e5; % static pressure / Pa

P = @(t,f) sqrt(2) * 10^(lautstaerke/20)* p0 * sin(2 * pi * f * t);

L=1:length(t_i);
t = tukeywin(L(end),0.25);

%f=800;
sig_400 = P(t_i,f);
sig_400(sig_400==0) = 1e-42;
sig_400 = sig_400 ./ max(sig_400);

f = 404;
%f= 1000;
sig_404 = P(t_i,f);
%sig_404 = [zeros(1,200) sig_404(1:end-200)];
sig_404(sig_404==0) = 1e-42;
sig_404 = sig_404 ./ max(sig_404);

sig_superpos = sig_400 + sig_404;

sig_404_sound = sig_404(L)'.*t;
sig_400_sound = sig_400(L)'.*t;

figure
subplot(3,1,1);
plot(t_i*1000,sig_400,'k');
hold on 
plot(t_i*1000,sig_404,'b');
xlim([0 50]);
ylim([-1.09 1.09]);
subplot(3,1,2);
plot(t_i*1000,sig_400,'k');
hold on 
plot(t_i*1000,sig_404,'b');
xlim([100 150]);
ylim([-1.09 1.09]);
ylabel('Amplitude / 1');
subplot(3,1,3);
plot(t_i*1000,sig_400,'k');
hold on 
plot(t_i*1000,sig_404,'b');
xlim([200 250]);
ylim([-1.09 1.09]);
xlabel('Time / ms');
print('fig/signal_beat', '-depsc');


% plot(sig_superpos,'g');
figure;
plot(t_i*1000,sig_superpos,'r');
ylabel('Amplitude / 1');
xlabel('Time / ms');
%xlim([100 400]);
ylim([-2.05 2.05]);
print('fig/signaladdition', '-depsc');

 sound(sig_400,fs);
 pause(4);
 sound(sig_404,fs);
 pause(4);
 sound(sig_superpos,fs);
% pause(4);
% sound(sig_400+sig_404,fs);

%%
[fft_b,f_b] = fft_f(sig_superpos,fs);

figure;
ind = find(f_b > 394 & f_b < 410);
stem(f_b(ind),abs(fft_b(ind)));
xlim([395 410.5]);
ylim([-0.05 1.09]);
xlabel('Frequency / Hz');
ylabel('Amplitude / 1');
print('fig/signaladdition_spectrum', '-depsc');



%% 2
f_T = 1000; %Hz
f_N = 4; %Hz
m = 0.5;
U_eff_T = 1;

u_AM = U_eff_T*(1 + m*sin(omega(f_N)*t_i)) .* sin(omega(f_T)*t_i);
u_AM = u_AM./max(u_AM);

% u_AM_sound = u_AM'.*t;
% sound(u_AM_sound,fs);

figure;
plot(t_i,u_AM);
ylim([-1.09 1.09]);
ylabel('Amplitude / 1');
xlabel('Time / s');
print('fig/AM_1000_4', '-depsc');


[fft_u_AM,f_u_AM] = fft_f(u_AM,fs);
figure;
stem(f_u_AM,abs(fft_u_AM));
xlim([990 1010]);
ylim([-0.05 1.09]);
xlabel('Frequency / Hz');
ylabel('Amplitude / 1');
print('fig/AM_1000_4_fft', '-depsc');


%% 3
f_M = 3; %Hz
f_T = 1000;
delta_f_T = 30;
U_eff_M = 1;
U_eff_T = 1;

u_FM = U_eff_T * cos(omega(f_T)*t_i + (delta_f_T*U_eff_M/f_M) * sin(omega(f_M)*t_i));

u_FM = u_FM./max(u_FM);

% u_FM_sound = u_FM'.*t;
% sound(u_FM_sound,fs);

figure;
plot(t_i,u_FM);
xlim([0 0.5]);
ylim([-1.09 1.09]);
ylabel('Amplitude / 1');
xlabel('Time / s');
print('fig/FM_1000_3', '-depsc');

[fft_u_FM,f_u_FM] = fft_f(u_FM,fs);
figure;
stem(f_u_FM,abs(fft_u_FM));
ylim([-0.01 0.35]);
xlim([920 1070]);
xlabel('Frequency / Hz');
ylabel('Amplitude / 1');
print('fig/FM_1000_3_fft', '-depsc');
 %%
 figure;
nwin = blackman(256);%256,5
noverlap = 200;%220
f_analysis = 256;
colormap bone
spectrogram(u_FM,nwin,noverlap,f_analysis,fs,'yaxis');
print('fig/FM_1000_3_spect', '-depsc');
%%
%%% For Test with f_T = 100
f_M = 3; %Hz
f_T = 100;
delta_f_T = 30;
U_eff_M = 1;
U_eff_T = 1;

u_FM = U_eff_T * cos(omega(f_T)*t_i + (delta_f_T*U_eff_M/f_M) * sin(omega(f_M)*t_i));

u_FM = u_FM./max(u_FM);

% u_FM_sound = u_FM'.*t;
% sound(u_FM_sound,fs);

figure;
plot(t_i,u_FM);
ylim([-1.09 1.09]);
xlim([0 1]);
ylabel('Amplitude / 1');
xlabel('Time / s');
print('fig/FM_100_3', '-depsc');

[fft_u_FM,f_u_FM] = fft_f(u_FM,fs);
figure;
stem(f_u_FM,abs(fft_u_FM));
ylim([-0.01 0.35]);
xlim([50 150]);
xlabel('Frequency / Hz');
ylabel('Amplitude / 1');
print('fig/FM_100_3_fft', '-depsc');

%% 4
f_T = 1000; %Hz
f_N = 200; %Hz
m = 0.5;
U_eff_T = 1;

u_AM_200 = U_eff_T*(cos(omega(f_T)*t_i) + m/2*...
 (cos((omega(f_T)-omega(f_N))*t_i)-cos((omega(f_T)+omega(f_N))*t_i)));
u_AM_200 = u_AM_200./max(u_AM_200);

 u_AM_200_sound = u_AM_200'.*t;
 sound(u_AM_200_sound,fs);

% Windowing
%u_AM(L) = u_AM(L)'.*t;

% Signal plot
figure;
plot(t_i.*1000, u_AM_200);
xlim([0 50]);
ylim([-1.5 1.5]);
xlabel("Time / ms");
ylabel("Amplitude / 1");
print('fig/AM_1000_200', '-depsc');

% Spectrum
[fft_u_AM_200,f_u_AM_200] = fft_f(u_AM_200,fs);
figure;
stem(f_u_AM_200,abs(fft_u_AM_200));
xlim([500 1500]);
xticks([500 800 1000 1200 1500]);
xlabel('Frequency / Hz');
ylabel('Amplitude / 1');
print('fig/AM_1000_200_fft', '-depsc');

%% Fleißaufgabe Beat Frequency

duration = 10;
t_i = 0:1/fs:duration;

L=1:length(t_i);
t = tukeywin(L(end),0.25);

% ft = 400 fm = 5 m = 1
m = 1;
f_T = 400;
f_M = 5;
u_AM_400 =  (1 + m*sin(omega(f_N)*t_i)) .* sin(omega(f_T)*t_i);
u_AM_400 = u_AM_400' .* t;

% ft = 100 fm = 5 m = 1
f_T = 500;
u_AM_500 = (1 + m*sin(omega(f_N)*t_i)) .* sin(omega(f_T)*t_i);
u_AM_500 = u_AM_500' .* t;

% ft = 0.25 fm = 5 m = 1
f_T = 400.25;
u_AM_400_25 = (1 + m*sin(omega(f_N)*t_i)) .* sin(omega(f_T)*t_i);
u_AM_400_25 = u_AM_400_25' .* t;

 sound([u_AM_400 u_AM_500],fs);
 pause(12);
sound([u_AM_400 u_AM_400_25],fs);

function w = omega(f)
w = 2*pi*f;
end