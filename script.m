
%% General Variables and Constants

p_static    =  1e5; % static pressure / Pa
p0          = 20e-6; % reference sound level / Pa

%% Aufgabe 1
fs_signal   = 20e3; % sampling rate / Hz
f_signal    =  10; % signal frequency / Hz
t_signal    = 0:1/fs_signal:5; % time vector of signal / s
omega_signal= 2*pi*f_signal; % angular frequency / rad/s

rmsspl_signal= 60; % spl of signal / dB

% % Calculate Pressure Peak value:
% p_eff = sqrt( p_peak^2 / 2)
% Lp = 10*log10( p_eff^2 / p0^2 )
% -> 
peff_signal = 10^(rmsspl_signal/20)*p0;
ppeak_signal= peff_signal*sqrt(2);

p_signal    = ppeak_signal * sin(omega_signal*t_signal) + p_static;
figure, plot(t_signal,p_signal)
xlabel('Time / s');
ylabel('Signal pressure / Pa');

% Spectrum
[fmag_signal,mag_signal] = fft_positiv(p_signal, fs_signal);
spl_signal = 20 * log10( mag_signal / p0 );
figure, semilogx(fmag_signal,real(spl_signal)); 
xlabel('Frequency / Hz');
ylabel('Sound pressure level / dB');


%% Aufgabe 2
% sound_signal = (p_signal - p_static) / max(abs(p_signal-p_static));
% sound(sound_signal, fs_signal);
% pause(2);

% "Hard" transition in beginning and end... Since step in signal! 
% -> Solution: Hamming, ... filter

win_signal  = hamming(length(sound_signal))';
fil_signal  = sound_signal .* win_signal;
sound(fil_signal, fs_signal);
pause(2);
% @@@ In my opinion not better, but dunno....

%% Aufgabe 3
[y_nuss, fs_nuss] = audioread('Nuss.wav');
sound(y_nuss, fs_nuss); pause(2);
y_nuss_nom  = y_nuss' / rms(y_nuss) * peff_signal;

[f_nuss,ps_nuss] = fft_positiv(y_nuss_nom, fs_nuss);
spl_nuss    = 20 * log10( ps_nuss / p0 );
figure, semilogx(f_nuss,spl_nuss); 
xlabel('Frequency / Hz');
ylabel('Sound pressure level / dB');
%%
sa_nuss     = filter(design(fdesign.audioweighting('WT,Class','A',1,fs_nuss)),y_nuss);
sa_nuss_lev = 10 * log10(sa_nuss.^2 / p0^2); % Dunno, this is over time??
[f_sanuss,ps_sanuss] = fft_positiv(sa_nuss', fs_nuss);
spl_sanuss    = 20 * log10( ps_sanuss / p0 ); % And this is over frequency?
%%
[y_fcmg, fs_fcmg] = audioread('fcmg0-W1-t.wav');
sound(y_fcmg, fs_fcmg); pause(2);
y_fcmg_nom  = y_fcmg' / rms(y_nuss) * peff_signal;

[f_fcmg,ps_fcmg] = fft_positiv(y_fcmg_nom, fs_fcmg);
spl_fcmg    = 20 * log10( ps_fcmg / p0 );
figure, semilogx(f_fcmg,spl_fcmg); 
xlabel('Frequency / Hz');
ylabel('Sound pressure level / dB');
%%
sa_fcmg     = filter(design(fdesign.audioweighting('WT,Class','A',1,fs_fcmg)),y_fcmg);
sa_fcmg_lev = 10 * log10(sa_fcmg.^2 / p0^2); % Dunno, this is over time??
[f_safcmg,ps_safcmg] = fft_positiv(sa_fcmg', fs_fcmg);
spl_safcmg    = 20 * log10( ps_safcmg / p0 ); % And this is over frequency?

return;
%% hacky stuff...

ccc;
% Generate 94 dB (Peak) SPL sinusoid
fs = 20000;
duration = 1;
npts = fs*duration;
t = linspace(0, 2*pi, npts);
f = 1000;
ref = 2.0e-5; % 20 uPa
amp = 10^(60/20)*ref; % 60 dB SPL
s = amp * sin((f*duration) * t);

% Window signal
win = hamming(npts)';
signal = s .* win;

sp = fft(signal);

%freq = fftfreq(npts, 1.0/fs)
d = 1.0/fs;
n = npts;
val = 1.0 / (n * d);
results = zeros(n,1);
N = floor((n-1)/2) + 1;
p1 = 0:N-1;
results(1:N) = p1';
p2 = -floor(n/2):0;
results(N:end) = p2';
freq = results * val;

% Scale the magnitude of FFT by window energy and factor of 2, 
% because we are using half of FFT.
% To obtain RMS values, divide by sqrt(2)
sp_mag = abs(sp) * 2 / sum(win);

% Shift both vectors to have DC at center
freq   = fftshift(freq);
sp_mag = fftshift(sp_mag);

% Convert to decibel scale
sp_db = 20 * log10( sp_mag/ref );

subplot(2,1,1)
plot(t, s)
xlabel('Time [s]')
ylabel('Acoustic pressure [Pa]')
grid on

subplot(2,1,2)    
semilogx(freq, sp_db)
xlim([0, fs/2]);
ylim([0, 100])
grid on
xlabel('Frequency [Hz]')
ylabel('SPL [dB]')
    
    
%% Functions
function [f,P] = fft_positiv(x, Fs)
% FFT_POSITIV Returns frequency and amplitude vector of positive sided fft.
%   [f,P] = FFT_POSITIV(x, N, Fs) with the time domain vector x, sample
%   count N and sampling frequency Fs.

    N = length(x);
    
    Y = fft(x);
    
    P2 = abs(Y/N);
    
    P1 = P2(:,1:N/2+1);
    
    P1(:,2:end-1) = 2*P1(:,2:end-1); 
    % Since positive and negative fft regions are overlapped
    
    f = 0:(Fs/N):(Fs/2-Fs/N);
    
    P = P1(1:N/2);
end 