

%% Aufgabe 1 a
f_x = 1/0.1; %0.1; % 1 / px
f_y = 1/0.2; %0.2; % 1 / px
siz = [30 30];

[X,Y] = meshgrid(1:siz(1),1:siz(2));
Z     = cos(f_x*X+f_y*Y) + 1;

figure, imshow(Z, [0 2]);
xlabel('x / px'); ylabel('y');
colormap gray
colorbar
caxis([0 2])
set(gcf, 'PaperPositionMode', 'auto', 'Units', 'Centimeters', ...
    'Position', [0 30 50 50]);
print(gcf, '1a.eps','-depsc');

%% Aufgabe 1 b
f_s = 1/2; % What is fs here?? Why 6?
Z_fft = fft2(Z);
Z_fft = fftshift(Z_fft); % center 0-frequency
bins = fftfreq(31,f_s);
figure,
imagesc(bins,bins,abs(log2(Z_fft)));
xlabel 'f_x / (1 / px)';
ylabel 'f_x / (1 / px)';
axis image
colormap gray
colorbar
caxis([0 10])
print(gcf, '1b.eps','-depsc');

%% Aufgabe 1 b (2)
image_row = Z(:,1);
[im_row_spec, im_row_f]=fft_f(image_row,6);
stem(im_row_f, abs(im_row_spec));

%% Aufgabe 1 c
% y-Richtung... f_y = 0.2 > f_x = 0.1

%% Aufgabe 2 a
video_template;

%% Aufgabe 2 b
% I = cos( ft * t + fx * x), for one pixel x=const; -> cos(ft*t)
% one period is 2pi seconds; frequency is ft

%% Aufgabe 3 a
% idealer Tiefpass: cut-off frequency at XX Hz -> Rechteck filter mit rect(f/2B) 
% -> Sinc um 0Hz


%% Aufgabe 3 b
im_bricks =  im2double(imread('bricks.jpg'));
im_alhambra =  im2double(imread('alhambra.png'));

fft_bricks = fftshift(fft2(im_bricks));
fft_alhambra = fftshift(fft2(im_alhambra));

figure('name', 'Image Bricks'),
imshow(im_bricks); %title('Image Bricks');
print(gcf, 'bricks_im.eps','-depsc');

bins_x = fftfreq(size(fft_bricks,2),1);
bins_y = fftfreq(size(fft_bricks,1),1);
figure('name', 'Spectrum Bricks'),
imagesc(bins_x,bins_y,abs(log2(fft_bricks))); % title('logarithmic amplitude spectrum Bricks');
xlabel 'f_x / (1 / px)'; ylabel 'f_y / (1 / px)';
print(gcf, 'bricks_spec.eps','-depsc');
% Muster (vertikale und horizontale Linien): y-Achse des fft plots

figure('name', 'Image Alhambra'),
imshow(im_alhambra); %title('Image Alhambra');
print(gcf, 'alhambra_im.eps','-depsc');

bins_x = fftfreq(size(fft_alhambra,2),1);
bins_y = fftfreq(size(fft_alhambra,1),1);
figure('name', 'Spectrum Alhambra'),
imagesc(bins_x,bins_y,abs(log2(fft_alhambra))); %title('logarithmic amplitude spectrum Alhambra');
xlabel 'f_x / (1 / px)'; ylabel 'f_y / (1 / px)';
print(gcf, 'alhambra_spec.eps','-depsc');
% regelm‰ﬂige Punktwolke um Null mit vertikalen Linien
% Siehe erste aufgabe: diagonale Linie

%% Aufgabe 3 c
fft_bricks_lp = fftshift(fft2(im_bricks));
fft_bricks_lp2 = zeros(size(fft_bricks_lp));
fft_bricks_lp2(floor(end/2-end*0.13/2):ceil(end/2+end*0.13/2),floor(end/2-end*0.13/2):ceil(end/2+end*0.13/2)) =...
    fft_bricks_lp(floor(end/2-end*0.13/2):ceil(end/2+end*0.13/2),floor(end/2-end*0.13/2):ceil(end/2+end*0.13/2));
im_bricks_lp = ifft2(ifftshift(fft_bricks_lp2));

figure, subplot(121);
imshow(im_bricks); title 'original';
subplot(122);
imshow(real(im_bricks_lp)); title 'Low-pass';
print(gcf, 'bricks_lp.eps','-depsc');


fft_alhambra_lp = fftshift(fft2(im_alhambra));
fft_alhambra_lp2 = zeros(size(fft_alhambra_lp));
fft_alhambra_lp2(floor(end/2-end*0.13/2):ceil(end/2+end*0.13/2),floor(end/2-end*0.13/2):ceil(end/2+end*0.13/2)) =...
    fft_alhambra_lp(floor(end/2-end*0.13/2):ceil(end/2+end*0.13/2),floor(end/2-end*0.13/2):ceil(end/2+end*0.13/2));
im_alhambra_lp = ifft2(ifftshift(fft_alhambra_lp2));

figure, subplot(121);
imshow(im_alhambra); title 'original';
subplot(122);
imshow(real(im_alhambra_lp)); title 'Low-pass';
print(gcf, 'alhambra_lp.eps','-depsc');