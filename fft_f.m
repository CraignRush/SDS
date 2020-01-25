function [spectrum_signal,f] = fft_f(time_signal,fs,yscale)
% function [spectrum_signal,f] = fft_f(time_signal,fs)
%
% FFT function that only takes the positive frequency response
%
% Inputs:
% time_signal      input signal
% fs               sampling frequency
%
% Outputs:
% spectrum_signal  complex FFT coefficients
% f                vctor of FFT frequencies


% compute FFT coefficients, norm with the length of the signal
FFTtmp = fft(time_signal)/length(time_signal);

% discard redundant coeffcients (n could be odd!)
n = length(time_signal)/2;
spectrum_signal = FFTtmp(1:floor(n)+1);    

% correct values other than DC and fs/2
spectrum_signal(2:end-1)   = spectrum_signal(2:end-1)*2;    

% create frequency vector (frequency step is fs/length(signal) )
f=(0:floor(n))/n * fs/2;

if nargout == 0 || nargin >= 3
    if nargin < 3
        yscale = 'log';
    end
    plot(f,abs(spectrum_signal));
    set(gca,'yscale',yscale)
    if nargout == 0 
        clear spectrum_signal f
    end
end