 %% Uebung05
% set(0,'DefaultAxesFontName', 'Helvetica')
% set(0,'DefaultAxesFontSize', 12)
% set(0,'DefaultLineLineWidth',1);
% set(0,'DefaultFigurePaperPositionMode','auto');
% set(0,'DefaultFigureUnits','Centimeters');
% set(0,'DefaultFigurePosition',[2 2 12 6]);
%% Aufgabe 1 a
f_x = 10; % 1 / px
f_y = 5; % 1 / px
siz = [30 30];
 
[X,Y] = meshgrid(1:siz(1),1:siz(2));
Z     = cos(f_x*X+f_y*Y) + 1;
 
figure, imshow(Z, [0 2], 'InitialMagnification','fit');
xlabel('x'); ylabel('y');
colormap gray
colorbar
caxis([0 2])
print(gcf, '1a.eps','-depsc');
 
%% Aufgabe 1 b
f_s = 0.5; % What is fs here??
Z_fft = fft2(Z);
Z_fft = fftshift(Z_fft); % center 0-frequency

bins = fftfreq(31,f_s);
figure,
imagesc(bins,bins,abs(log2(Z_fft)));
axis image
colormap gray
colorbar
caxis([0 10])
print(gcf, '1b.eps','-depsc');
 
%% Aufgabe 1 c
% y-Richtung... f_y = 0.2 > f_x = 0.1

f_s = 6; % What is fs here??
Z_fft = fft(Z(end/2,:));
Z_fft = fftshift(Z_fft); % center 0-frequency

figure;
stem(bins,Z_fft);
%surf(real(Z_fft));
print(gcf, '1c.eps','-depsc');
 
%% Aufgabe 2 a
video_template;
 
%% Aufgabe 2 b
% ???
% f_t ??
 
%% Aufgabe 3 a
% idealer Tiefpass: cut-off frequency at XX Hz
% Impulsantwort: dirac = Const in Frequenzbereich
% -> Rechteck um 0 Hz...
 
%% Aufgabe 3 b
im_bricks =  im2double(imread('bricks.jpg'));
im_alhambra =  im2double(imread('alhambra.png'));
 
fft_bricks = fftshift(fft2(im_bricks));
fft_alhambra = fftshift(fft2(im_alhambra));
 
figure('name', 'Image Bricks'),
imshow(im_bricks); title('Image Bricks');
print(gcf, 'bricks_im.eps','-depsc');
 
figure('name', 'Spectrum Bricks'),
imagesc(abs(log2(fft_bricks))); title('logarithmic amplitude spectrum Bricks');
print(gcf, 'bricks_spec.eps','-depsc');
% Muster (vertikale und horizontale Linien): y-Achse des fft plots
 
figure('name', 'Image Alhambra'),
imshow(im_alhambra); title('Image Alhambra');
print(gcf, 'alhambra_im.eps','-depsc');
 
figure('name', 'Spectrum Alhambra'),
imagesc(abs(log2(fft_alhambra))); title('logarithmic amplitude spectrum Alhambra');
%xticks(fftfreq(size(im_alhambra,2),f_s)); % Not working...
%yticks(fftfreq(size(im_alhambra,1),f_s)); % Not working...
print(gcf, 'alhambra_spec.eps','-depsc');
% regelm‰ﬂige Punktwolke um Null mit vertikalen Linien
 
%% Aufgabe 3 c
fft_bricks_lp = fft2(im_bricks);
fft_bricks_lp(13:end,13:end) = 0; % ToDo!
im_bricks_lp = ifft2(fft_bricks_lp);
 
figure, subplot(121);
imshow(im_bricks); title 'original';
subplot(122);
imshow(real(im_bricks_lp)); title 'Low-pass';
print(gcf, 'bricks_lp.eps','-depsc');
 
 
fft_alhambra_lp = fft2(im_alhambra);
fft_alhambra_lp(13:end,13:end) = 0; % ToDo!
im_alhambra_lp = ifft2(fft_alhambra_lp);
 
figure, subplot(121);
imshow(im_alhambra); title 'original';
subplot(122);
imshow(real(im_alhambra_lp)); title 'Low-pass';
print(gcf, 'alhambra_lp.eps','-depsc');



