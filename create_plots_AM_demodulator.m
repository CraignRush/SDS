%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab-Script fuer Systemtheorie der Sinne
% AM Demodulator mit Diode und RC Tiefpass
% calculate response of circuit in time domain
% plot time signals and their magnitude spectrum
% requires function fft_f
% by Werner Hemmert, TUM, 18. Oct. 2016 - 9. Mai 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          % ALWAYS start with clean workspace
close all;
clear all;
%%  Define figure size such that you can read the labels in a report/paper
figure
set(gcf,'Units','Centimeters','Position',[0 0 8.4 9],'PaperPositionMode','auto')
fontSize=8;
%% ======================= AM Demodulator ================================

%---------------- Parameters: ALWAYS use SI units!! ----------------------
f_s=1000e3;                     % sampling frequency /Hz
f_t=10000;                      % carrier frequency /Hz
f_am=1000;                      % modulation frequency /Hz
m=0.8;                          % modulation /

R=10e6;                         % resistance /Ohm
C=16e-12;                       % capacity /F
f_c=1/(R*C*2*pi)                % R/C corner frequency /Hz

am_cycles=2;       % signal duration in amplitude modulation cycles /cycle
t=0:1/f_s:am_cycles/f_am-1/f_s; % create time vector

%% --------------- calculate demodulated signal --------------------------
u1=cos(2*pi*f_t*t).*(1+m*cos(2*pi*f_am*t));   % AM signal
u3=(1+m*cos(2*pi*f_am*t));                    % envelope
u=u1(1);                       % initialize memory variable
u2=0*u1;                       % initialize output voltage for speed

for cnt=1:size(t,2)            % solve system in time domain
   u=u-u/R/f_s/C;              % decay of RC (forward Euler approximation)
   if(u<u1(cnt))               % NONLINEAR diode
       u=u1(cnt);
   end
   u2(cnt)=u;                  % store result for plotting
end

%% -------------------- plot time signals --------------------------------
a(1)=subplot(2,1,1);              % create plots for magnitude and phase 
plot(t*1000,u1,'LineWidth',1); hold on; % plot input voltage, x-axis in ms
plot(t*1000,u2,'r','LineWidth',1);      % plot response
plot(t*1000,u3,':','LineWidth',1);      % plot ideal envelope
%xlabel('Frequenz / kHz','FontSize',fontSize)
ylabel('u_1, u_2 / V','FontSize',fontSize)
xlabel('t / ms','FontSize',fontSize)

%% -------------------- plot spectra -------------------------------------
subplot(2,1,2);
[U1,f]=fft_f(u1,f_s);
[U2,f]=fft_f(u2,f_s);
[U3,f]=fft_f(u3,f_s);
% loglog(f/1000,abs(U1),f/1000,abs(U2),'LineWidth',1);
H=stem(f/1000,abs(U1),'LineWidth',1);       % plot mag spectrum of input
hold on;                                    % plot multiple responses
H=stem(f/1000,abs(U2),'r','LineWidth',1);   % diode demodulator
H=stem(f/1000,abs(U3),':','LineWidth',1);   % ideal AM 
set(gca,'XScale','log','YScale','log')      % scale: double log

xlabel('Frequenz / kHz','FontSize',fontSize)
ylabel('|U_1(f)|, |U_2(f)| / V','FontSize',fontSize)
axis([500/1000 45 2e-3 2])                  % select reasonable scale !!!

%% ------------- some tricks for plotting --------------------------------
y_pos=[0.001 0.01 0.1 1];                     % position for y-axes labels
set(gca,'YTick',y_pos)
y_pos=['0.001';' 0.01';'  0.1';'    1'];      % define labels for y-axes
set(gca,'YtickLabel',y_pos,'FontSize',fontSize);
x_pos=[1 10];                                 % position for x-axes labels
set(gca,'XTick',x_pos)
x_pos=[' 1';'10'];                            % define labels for x-axes
set(gca,'XtickLabel',x_pos,'FontSize',fontSize);
%legend('AM-Signal','Dioden-Demodulator','Ideale Hüllkurve') % Legende

print('am_demodulator', '-depsc')             % create scaleable figure
% print('am_demodulator', '-dtiff', '-r300')    % cretes pixel figure
% print('am_demodulator', '-dmeta')             % windows only: emf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------- D O N E -----------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%