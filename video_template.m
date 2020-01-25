clear all
close all

dbstop if error

% set parameters for video
FrameRate = 30;
writerObj = VideoWriter('video','Uncompressed AVI');
writerObj.FrameRate = FrameRate;
open(writerObj);

% set parameters for image
set(0,'DefaultLineMarkerSize', 17)
set(0,'DefaultLineLinewidth', 1.5)
figure('Position',[100 100 600 400])
colormap gray
axis tight
set(gca,'nextplot','replacechildren');
set(gcf,'color','w');
set(gcf,'Renderer','zbuffer'); % opengl painters

pause(0.1)

% %%%%%%%%%%%%%%%%%%%%%%%

f_x = 0.1;
f_t = 2;

    [X, ~] = meshgrid(1:30,1:30);
% %%%%%%%%%%%%%%%%%%%%%%%

% Record the movie
for cnt=1:200
    t=cnt/FrameRate;
    
    % %%%%%%%%%%%%%%%%%%%%%%%
    % Generate the frame here
    Z = cos(f_x * X + f_t * t) + 1;
    imshow(Z, [0 2]);
    
    % %%%%%%%%%%%%%%%%%%%%%%%
    
    frame= getframe;
    
    writeVideo(writerObj,frame);
end

close(writerObj);
