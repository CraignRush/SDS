function freqs = fftfreq(n, fs)
% Return the Discrete Fourier Transform sample frequencies (two sided).
%
% The returned float array f contains the frequency bin centers in the units of
% the sampling rate (with zero at the center).
%
% Given a window length n and a sampling rate fs:
%   f = [    -n/2, ..., -1, 0, 1, ...,  n/2 - 1] / (n/fs)   if n is even
%   f = [-(n-1)/2, ..., -1, 0, 1, ..., (n-1)/2 ] / (n/fs)   if n is odd
%
% Parameters
% ----------
% n : int
%     Window length.
% fs : scalar, optional
%     Sampling rate. Defaults to 1.
%
% Returns
% -------
% freqs : darray
%     Array of length n containing the sample frequencies.
%
% Modified from Python's numpy.fft.fftfreq (http://www.numpy.org/license.html)

if nargin < 2
    fs = 1;
end

results = zeros(1, n);
N = fix((n-1)/2) + 1;
results(1:N) = 0:N-1;
results(N+1:end) = (-fix(n/2):-1);
freqs = fftshift(results * (fs / n));
