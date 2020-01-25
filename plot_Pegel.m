function [fig, ax] = plot_Pegel(signal,fs,reference)

Pegel = 20*log10(signal./reference);

[Pegelspektrum,f_i] = fft_f(Pegel,fs);

fig = figure;
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', 'Position', [2 2 8 4]);
ax = axes(fig);
plot(f_i,abs(Pegelspektrum));
end