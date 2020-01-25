% IHC.m
%
%						Inner Hair Cell Receptor Potential Model
%
%									David C. Mountain, Ph.D.
%										Boston University
%									Hearing Reseach Center
%
%                                Modified by Werner Hemmert, TUM
%
%  Model uses realistic transducer conductance and membrane time 
%  constant, but assumes basolateral membrane conductance is linear
%  This model assumes that the tension-gated channels are the only
%  apical channels.
%
clear all;                  % delete all variables 
close all;                 % close all open figures


sampling_rate = 50e3;		% Sampling rate (samples/s)
N = sampling_rate*0.050;    % Number of time samples for 50 ms signal
xArray  = zeros(1,N);       % Input waveform array
GaArray = zeros(1,N);       % Output array for apical conductance
VmArray = zeros(1,N);       % Output array for receptor potential
time	= zeros(1,N);       % Time scale

% model parameters are from:
%
% Mountain, D.C and Cody, A.R. (1999)
% Multiple Modes of Inner Hair Cell Stimulation. Hearing Research 132: 1-14.

% ALL UNITS in SI

x0  = 27e-9;		% {m} displacement offset1
x1  = 27e-9;		% {m} displacement offset2
Sx0 = 85e-9;		% {m} sensitivity1
Sx1 = 11e-9;		% {m} sensitivity2
Gmax= 1.16e-8;      % maximal transduction conductivity: 11.6 nS

V0 =-45e-3;         % IHC basal resting membrane potential: -45 mV
EP = 90e-3; 		% endocochlear potential: +90 mV
Gb = 58.8e-9;       % IHC basal conductivity: 58.8 nS     
C  = 12e-12;		% Membrane capacitance: 12 pF

deltaT 	= 1.0/sampling_rate;		% Time step

% Prompt the user for stimulus parameters
f = input('Frequency of tone (Hz) ==>');
amp=input('Cilia displacement (nm peak) ==>')/1e9;   % scale to SI unit: m

% start after delay in order to show resting potential
Nstart 	= 0.01*sampling_rate;	

% stop before end of record in order to show resting potential
Nstop	= N-0.01*sampling_rate;	

%  Alternatively, without a delay
%  Nstart = 1;
%  Nstop  = N;

Time = (1:N)*deltaT;	% load the time array for plotting, SI unit: s
% create input waveform
xArray(Nstart:Nstop) = amp*sin(2*pi*f*(Time(1:Nstop-Nstart+1)));	

% Set up initial conditions
Vm		= V0;       % Vm: current membrane potential
for i = 1 : N		% begin integration loop
    x = xArray(i);
%================================================================
% Fill in the code here:
%================================================================
 Ga=Gmax/( (1+exp((x0-x)/Sx0)) * (1+exp((x1-x)/Sx1))); 
 Vm = Vm + (deltaT/C)*((EP-Vm)*Ga + (V0-Vm)*Gb);
%================================================================
% This is all you have to do!
%================================================================
    GaArray(i) = Ga;    % save variables in array for plotting
    VmArray(i) = Vm;    % save variables in array for plotting
end;  % {integration loop}


subplot(3,1,1)
% scale time in ms x in nm for display
plot(Time*1e3, xArray*1e9,'LineWidth',1);   
% autoscale axis since wide range of amplitudes can be used
grid;
ylabel('Displacment (nm)','FontSize',12,'FontWeight','bold');
title('IHC Model','FontSize',12,'FontWeight','bold');

subplot(3,1,2)
% scale time in ms and Ga in nS
plot(Time*1e3, GaArray*1e9,'LineWidth',1);
axis([0 max(Time*1e3) 0 12]);
grid;
ylabel('Conductance (nS)','FontSize',12,'FontWeight','bold');

subplot(3,1,3)
% scale time in ms and Vm in mV
plot(Time*1e3, VmArray*1e3,'LineWidth',1);
axis([0 max(Time*1e3) -50 -20]);
grid;
xlabel('Time (ms)','FontSize',12,'FontWeight','bold');
ylabel('Potential (mV)','FontSize',12,'FontWeight','bold');

print('fig/200Hz_100nm', '-depsc') % generate .eps file from plot for LaTex
% print(' AbbildungUe3', '-dmeta') % generate .emf file for Windows
