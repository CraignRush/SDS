%% Systemtheorie der Sinnesorgane - Übung 1
% Grundlagen der Digitalen Signalverarbeitung
% Define figure properties
clear all;
close all;

figure
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 8 4]);
fontSize=8;
%% 1.
u_max = 1; %V
f_s = 20; % Hz
f = 1; %Hz
u_DC = 0.5; %V
duration = 2; %s
t_i = (0:duration*f_s-1)./20;

U = @(t) u_max * sin(2*pi*f*t) + u_DC;

sig = U(t_i);


plot(t_i,sig,'LineWidth',1,'Marker','s'); % plot input voltage, x-axis in ms
%xlabel('Frequenz / kHz','FontSize',fontSize)
ylabel('U(t) (V)','FontSize',fontSize);
xlabel('t (s)','FontSize',fontSize);
ylim([-0.7 1.7]);
xlim([-0.1 2.1]);

print('ue1_fig/signal', '-depsc')             % create scaleable figure

%% 2.
L = length(sig);
f_fft = f_s/2 * linspace(0,1,L/2);
U_fft=abs(fft(sig)/L);
%Single sided spectrum
U_ss = U_fft(1:L/2+1);
% Double because left and right spectra are superpositioned
U_ss(1,2:end-1) = 2*U_ss(1,2:end-1);
U_ss = U_ss(1,1:L/2);

figure
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 8 4]);
stem(f_fft,U_ss, 'Linewidth', 1);
xlabel('f (Hz)','FontSize',fontSize);
ylabel('|U(f)|','FontSize',fontSize);
xticks(0:1:10);
xlim([-0.4 10.4]);
ylim([-0.05 1.2]);
print('ue1_fig/amp_fft', '-depsc')
%% 3.
% Compute Voltage level
L_U = 20*log10(sig);

L = length(L_U);
L_f_fft = f_s/2 * linspace(0,1,L/2);
L_U_fft = abs(fft(L_U)/L);
L_U_ss = L_U_fft(1:L/2+1);
L_U_ss(1,2:end-1) = 2 * L_U_ss(1,2:end-1);
L_U_ss = L_U_ss(1,1:L/2);



fig = figure;
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 8 4]);
plot(t_i, L_U, 'Linewidth', 1);
xlabel('t (s)','FontSize',fontSize);
ylabel('L_U(t) (dBV)','FontSize',fontSize);
ylim([-25 7 ]);
xlim([-0.1 2.1]);
print('ue1_fig/L_U_sig', '-depsc')
%% Plot fft
figure
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 8 4]);
stem(L_f_fft,L_U_ss, 'Linewidth', 1);
xlabel('f (Hz)','FontSize',fontSize);
ylabel('|L_U(f)|','FontSize',fontSize);
xticks(0:1:10);
xlim([-0.4 10.4]);
ylim([-1.1 21]);
print('ue1_fig/L_U_fft', '-depsc')

%% Compute RMS
rms_LU = rms(L_U)
