function func = min_ind(var)
x0  = 27e-9;		% {m} displacement offset1
x1  = 27e-9;		% {m} displacement offset2
Sx0 = 85e-9;		% {m} sensitivity1
Sx1 = 11e-9;		% {m} sensitivity2
Gmax= 1.16e-8;      % maximal transduction conductivity: 11.6 nS

V0 =-45e-3;         % IHC basal resting membrane potential: -45 mV
EP = 90e-3; 		% endocochlear potential: +90 mV
Gb = 58.8e-9;       % IHC basal conductivity: 58.8 nS
C  = 12e-12;		% Membrane capacitance: 12 pF

f = 200;%input('Frequency of tone (Hz) ==>');
amp= 100/1e9;%input('Cilia displacement (nm peak) ==>')/1e9;   % scale to SI unit: m

t = var(1);
x = var(2);

func =abs( abs(1 - (1/C)*(Gmax/( (1+exp((x0-amp*sin(2*pi*f*t/x))/Sx0)) * ...
    (1+exp((x1-amp*sin(2*pi*f*t/x))/Sx1)) )+Gb) * (1/x)) - 1);
end
% t = 0:0.00001:0.05;
% x = 1000:10000;
% 
% conv = zeros(length(x),length(t));
% i = 1;
% for j = 2000:3000
%     conv(i,:) = arrayfun(func,t,j*ones(1,length(t)));
%     i = i +1;
% end
% 
% figure;
% surf(t,x,conv);
% hold on
% surf(t,x,ones(size(conv)));
% colormap bone





