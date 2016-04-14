% EENG 633 Project 1 template
% Author: Michael Ledford

clear all; %clears all variables in the workspace
close all; %closes all open figures
clc; %clears e command window
set(0,'defaultfigureWindowStyle','docked'); % Dock figures

%Switches
CALC_AVG_PSD = 0; %set to 1 to calculate average PSD
Mpsd = 100;  %# of blocks to average

% Data Stream Dials
StreamDial.fs=5e6; %sample rate [samples/sec] There are 5000 samples, plot 500
StreamDial.fIF=1.27e6; %nominal IF [Hz]

% Simulator Dials
SimDial.Z=1;
SimDial.PtDbm=10; % Total signal power [dBm]
%SimDial.SnrDb=-3; % Signal to Noise ratio [dB]
SimDial.SnrDb=0; % Signal to Noise ratio [dB]
SimDial.fd=0;     % Initial Doppler frequency [Hz]
SimDial.phi0=0;   % Initial phase [radians]
SimDial.theta = zeros(1, 5000);
SimDial.phi = SimDial.phi0;


% Processor Dials
ProDial.Blocks=10; % total script run time [1 ms blocks]
ProDial.PT_estDbm = zeros(1,ProDial.Blocks);
ProDial.PF_estDbm= zeros(ProDial.Blocks,2501);
ProDial.PF_avg_estDbm = zeros(1,2500);



%% %%%%%%%%%%%%% No User Settings Below This Line %%%%%%%%%%%%%%%%%%%%%%%%%

% Universal constants (common to both simulator and processor)
TWOPI=2*pi;
ts=1/StreamDial.fs; %sample period [sec/sample]
BlockSamples=StreamDial.fs/1000; % number of samples per 1ms block
BlockSamplesM1=BlockSamples-1;
BlockSamplesDiv2=BlockSamples/2;


if rem(BlockSamples,1)
  error('BlockSamples not integer')
end

% variables
a = [1 1; 1 -10^(SimDial.SnrDb/10)];
b = [SimDial.PtDbm; 0];
x = a\b;
Pcarrier = x(1);
Pnoise = x(2);
B = sqrt(Pnoise);
A = sqrt(Pcarrier);
D = zeros(ProDial.Blocks,BlockSamples);
% FOR LOOP that simulates and processes 1-ms blocks
for w=1:ProDial.Blocks  
  %% %%%%%%%%%%%%%%%% Simulator %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % add your simulator script here
  % Build theta_k 
  for k=1:BlockSamples
    SimDial.theta(k) = mod(TWOPI*(k-1)*(StreamDial.fIF+SimDial.fd)*ts + SimDial.phi,TWOPI);
  end
  SimDial.phi = phase(SimDial.theta(end));
  D(w,:) = A.*cos(SimDial.theta) + B.*randn(1,BlockSamples); %signal generation
  
  
  %% %%%%%%%%%%%%%%%% Processor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % add your baseband processing script here
   
  % Time-Domain Power Estimator
  ProDial.PT_estDbm(w) = 10*log10(bandpower(D(w,:))); %[dBm] 
  
  % Power Spectral Density
  N = length(D(w,:));
  Ddft = fft(D(w,:));
  Ddft = Ddft(1:N/2+1);
  ProDial.PF_estDbm(w,:) = (1/(StreamDial.fs*N))*abs(Ddft).^2;
  ProDial.PF_estDbm(2:end-1) = 2*ProDial.PF_estDbm(2:end-1);
  
end
%Calculate Average PSD
if(CALC_AVG_PSD == 1)
    ProDial.PF_avg_estDbm = mean(ProDial.PT_estDbm(1:Mpsd,2:end));
end

%Plotting
FreqAxis=(0:(BlockSamplesDiv2-1))*(StreamDial.fs/BlockSamples)/1e6; % frequency axis in MHz
%Part 1: Carrier-plus-noise signal generation
figure(1);
plot(D(1:500));
title('Carrier plus noise signal generation: 1st 500 samples');
xlabel('Samples');
ylabel('Amplitude [v]');
%Part 2: 
figure(2);
hist(ProDial.PT_estDbm);
title(sprintf('Total Power Distribution of %.2d blocks. Pt=%.2f dBm, S/N_0=%.2f dB, Mean=%.2f dBm, Std=%.2f, Var=%.2f ',...
    ProDial.Blocks, SimDial.PtDbm, SimDial.SnrDb,...
    mean(ProDial.PT_estDbm), std(ProDial.PT_estDbm), var(ProDial.PT_estDbm)));
xlabel('Total Power [dBm]');
grid on


figure(3);
plot(FreqAxis,10*log10(ProDial.PF_estDbm(1,2:end)))
% title(...
%    sprintf(...
%    'Power spectral Density. Pt=%.2f dBm,S/N_0=%.2f dB, PtEst1=%.2f dBm, PtEst2=%.2f dBm',...
%    SimDial.PtDbm,...
%    SimDial.SnrDb,...
% ProDial.PT_estDbm,...
% ProDial.PF_estDbm));
xlabel('Frequency [Hz]')
ylabel('Power [dBm/Hz]');
grid on

if(CALC_AVG_PSD == 1)
    figure(4);
    plot(FreqAxis,10*log10(ProDial.PF_avg_estDbm(1,:)))
    title(...
       sprintf(...
       'Power spectral Density. Pt=%.2f dBm,S/N_0=%.2f dB, PtEst1=%.2f dBm, PtEst2=%.2f dBm',...
       SimDial.PtDbm,...
       SimDial.SnrDb,...
    ProDial.PT_estDbm,...
    ProDial.PF_estDbm));
    xlabel('Frequency [Hz]')
    ylabel('Power [dBm/Hz]');
    grid on
end



