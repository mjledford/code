% EENG 633 Project 2 Template
% use row-column multiply for correlation
% Script should have switches to on/off plots in user section
% Do not use functions for pre-determines sizes such as length(),size()
% Use vector operations instead of for loops
% All dial parameters associated with angles ~ degrees
% All plots should be in units of degrees

%% Startup
clear all; %clears all variables in the workspace
close all; %closes all open figures
clc; %clears the command window
set(0,'defaultfigureWindowStyle','docked'); % Dock figures
restoredefaultpath

%% Data Stream Dials
rffe_type='NB';
switch rffe_type
  case 'NB'
    StreamDial.fs=5e6; %sample rate [samples/sec]
    StreamDial.fIF=1.27e6; %nominal IF [Hz]
  case 'TRIGR'
    StreamDial.fs=56.32e6; %sample rate [samples/sec]
    StreamDial.fIF=13.68e6; %nominal IF [Hz]
end

%% Simulator Dials
SimDial.Z=1;          % Impedance [Ohms]
SimDial.PtDbm=10;     % Total signal power [dBm]
SimDial.CnrDbHz=50;   % Carrier to noise ratio [dB-Hz]
SimDial.phi0_deg=0;   % Initial phase [degrees]
SimDial.fd=0;         % Initial Doppler [Hz]
%SimDial.SnrDb=-3; % Signal to Noise ratio [dB]
%SimDial.phi0=0;   % Initial phase [radians]
SimDial.theta = zeros(1, 5000);
SimDial.phi = SimDial.phi0_deg;
%% Processor Dials
ProDial.Blocks=1000;  % Total simulation time [Blocks]
ProDial.phi0_deg=0;   % Replica initial phase [degrees]
ProDial.fd=0;         % Replica initial Doppler [Hz]
ProDial.Pdi=20;       % Pre-detection integrations [# HW Dumps]
ProDial.PAdi=50;        % Post-Detection Integrations [# SW Dumps]
ProDial.PDiscrType=0; % 0: Pure, 1: Costas

%ProDial.PT_estDbm = zeros(1,ProDial.Blocks);
%ProDial.PF_estDbm= zeros(ProDial.Blocks,1);
%ProDial.PF_estDbm2 = zeros(1,2500);
%ProDial.PF_avg_estDbm = zeros(1,2500);
%ProDial.Acc = zeros(1,2500);
%% Hardware Correlator plot
PlotHwCorrIq.Enable=1;
PlotHwCorrAngle.Enable=1;

%% Software Correlator plots
PlotSwCorrIq.Enable=1;
PlotSwCorrAngle.Enable=1;

PlotPdiscr.Enable=1;
PlotFdiscr.Enable=1;

PlotWBP.Enable=1;
PlotNBP.Enable=1;
PlotNP.Enable=1;
PlotNP.Enable=1;
PlotPLock.Enable=1;

PlotAvgNP.Enable=1;
PlotCnrRatio.Enable=0;
PlotCnrDbHz.Enable=1;

%% OScope Parameters
OScopeDial.Enable=0;
OScopeDial.Samples=500;

%% SpecA Parameters
SpecADial.Enable=0;
SpecADial.AvgFac=1;

%% Plot Parameters
LineWidth=2;
FontSize=12;
FontWeight='bold';
AxisFontSize=FontSize;
AxisFontWeight=FontWeight;
%% %%%%%%%%%%%%% No User Settings Below This Line %%%%%%%%%%%%%%%%%%%%%%%%%

%% Universal Constants (common to both simulator and processor)
TWOPI=2*pi;
RAD2CYC=1/TWOPI;
DEG2RAD=TWOPI/360;
RAD2DEG=360/TWOPI;
ts=1/StreamDial.fs; %sample period [sec/sample]
BlockSamples=StreamDial.fs/1000; % number of samples per 1ms block
BlockSamplesM1=BlockSamples-1;
BlockSamplesDiv2=BlockSamples/2;
BlockSamplesInv=1/BlockSamples;
ZInv=1/SimDial.Z;
Thw=0.001; % hardware integration time [sec]
Tsw=ProDial.Pdi*Thw; %software integration time [sec]
BW = 24e6; %[Hz]


if rem(BlockSamples,1)
  error('BlockSamples not integer')
end

%% Sim Variables
Sim.D = zeros(ProDial.Blocks,BlockSamples);
SimDial.CarStep = TWOPI*(StreamDial.fIF+SimDial.fd)*ts;
%Sim.CarStepVec = ones(1, BlockSamplesDiv2);
SimDial.CarStepVec = ones(1, BlockSamplesM1);
SimDial.SnrDb = SimDial.CnrDbHz - 10*log10(BW); %[dB]

%% Pro Variables

NCO_C = zeros(ProDial.Blocks,BlockSamples);
Pro.SW.Acc = 0;
Pro.SW.Counter=0; %counts where to index SW Corr and place new accum & dump
%Pre Allocate Pro.SW.Corr, Pro.SW.PhiErr,
%% Memory Allocation for Data Collection


% Pdi Plots

% Adi Plots


fignum=0;

if OScopeDial.Enable
  fignum=fignum+1;
  OScope.fignum=fignum;
end

if SpecADial.Enable
  fignum=fignum+1;
  SpecA.fignum=fignum;
end

%% Variables

%Pc + Pn  =  10dBm
%P[watts] = 1W * 10^(dBm/10)/1000
%Eq1:Pc + Pn = 1 * 10^(10/10)/1000 [w]
%y = loga(x)
%a^y = x
%3dB = 10log10(Pc/Pn)
%3/10 dB = log10(Pc/Pn)
%10^(3/10) = Pc/Pn
%Pn*10^(3/10) = Pc
%Eq2: Pc - Pn*10^(3/10) = 0 [w]
a = [1 1; 1 -10^(SimDial.SnrDb/10 + 1)]; %[w]
b = [10^(SimDial.PtDbm/10)/1000; 0]; %[w]
x = a\b;
Pcarrier = x(1)/SimDial.Z; %[w]
Pnoise = x(2)/SimDial.Z;   %[w]
Sim.B = sqrt(Pnoise);
Sim.A = sqrt(2*Pcarrier); %Multiply by 2 to convert rms to peak to peak

%% FOR LOOP that simulates and processes 1-ms blocks
m=1; % counts software accumulator dumps
n=1; % counts post-detection accumulator dumps
tic
for w=1:ProDial.Blocks
  %% %%%%%%%%%%%%%%%% Simulator %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % add your simulator code here
  SimDial.PhiVec=cumsum([SimDial.phi0_deg SimDial.CarStepVec]);
  SimDial.phi0_deg = SimDial.PhiVec(BlockSamples) + SimDial.CarStep;
  Carrier=Sim.A*cos(SimDial.PhiVec);
  Noise = Sim.B*randn(1,BlockSamples);
  Sim.D(w,:) = Carrier + Noise;
  
  
  %% %%%%%%%%%%%%%%%% Processor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % complex carrier replica (NCO)
  NCO_C(w,:) = exp(1j*SimDial.PhiVec);
  
  % Hardware correlation operation
  Pro.HW.Corr(w) = Sim.D(w,:)*NCO_C(w,:).';
  Pro.HW.I(w) = real(Pro.HW.Corr(w));
  Pro.HW.Q(w) = imag(Pro.HW.Corr(w));
  Pro.HW.Mag(w) = abs(Pro.HW.Corr(w));
  Pro.HW.Angle(w) = angle(Pro.HW.Corr(w))*RAD2DEG;
  
  %% Software Accumulate/Dump
  Pro.SW.Acc = Pro.SW.Acc + Pro.HW.Corr(w);
  if rem(w,ProDial.Pdi)==0
    Pro.SW.Counter = Pro.SW.Counter + 1;
    Pro.SW.Corr(Pro.SW.Counter) = Pro.SW.Acc/ProDial.Pdi; %will have Blocks/Pdi columns
    Pro.SW.I(Pro.SW.Counter) = real(Pro.SW.Corr(Pro.SW.Counter)); %Real value of SW Corr
    Pro.SW.Q(Pro.SW.Counter) = imag(Pro.SW.Corr(Pro.SW.Counter)); %Imag value of SW Corr
    Pro.SW.Mag(Pro.SW.Counter) = abs(Pro.SW.Corr(Pro.SW.Counter)); %Mag of SW Corr
    Pro.SW.Angle(Pro.SW.Counter) = angle(Pro.SW.Corr(Pro.SW.Counter))*RAD2DEG;
    %Pro.SW.Angle(Pro.SW.Counter)=atand(Pro.SW.Q(Pro.SW.Counter)/Pro.SW.I(Pro.SW.Counter)); %Angle in degrees
    Pro.SW.Acc = 0; %Reset accum
    
    %% phase discriminator
    switch ProDial.PDiscrType
      case 0 % Pure PLL
        Pro.SW.PhiErr(Pro.SW.Counter) = atan2(Pro.SW.Q(Pro.SW.Counter),Pro.SW.I(Pro.SW.Counter))*RAD2DEG;
      case 1 % Costas PLL
        Pro.SW.PhiErr(Pro.SW.Counter) = atan(Pro.SW.Q(Pro.SW.Counter)/Pro.SW.I(Pro.SW.Counter))*RAD2DEG;
    end
    
    %% frequency discriminator
    
    if rem(w,ProDial.PAdi)==0 %PAdi is post-detection integration
     %dot = Pro.SW.I(n 
      
      
      %% Collect data for Adi-update plotting
%       if PlotAvgNP.Enable
%         AvgNPVec(n)=Pro.AvgNP;
%       end
      
      
      %% Adi Housekeeping
      
      n=n+1; %counts post detection accumulator dumps
    end
    
    %% Collect data for Pdi-update plotting
    %if SwCorrIq.Collect
      %SwCorrIq.Dat(m)=Pro.Corr_Sw; %uncomment when you get to this section
    %end
    
    
    %% Pdi Housekeeping
    
    m=m+1; %counts software accumulator dumps
  end
  
  %% Time-Domain Power Estimator
  
  
  %% OScope
  if OScopeDial.Enable
    figure(OScope.fignum)
    
    drawnow();
  end
  
  %% SpecA
  if SpecADial.Enable
    figure(SpecA.fignum)
    
    if rem(w,SpecADial.AvgFac)==0 % Dump the accumulated PSD
      drawnow();
    end
  end
  
end % end for()
toc
%% Post-Run Plots
if PlotHwCorrIq.Enable || PlotHwCorrAngle.Enable 
  TimeVecHw=Thw*(0:(ProDial.Blocks-1));
  if(PlotHwCorrIq.Enable == 1)
     figure;
     %plot(TimeVecHw,Pro.HW.I, Pro.HW.Q, Pro.HW.Mag)
     plot(TimeVecHw,Pro.HW.I, 'k'); hold on;
     plot(TimeVecHw,Pro.HW.Q, 'g');
     plot(TimeVecHw,Pro.HW.Mag,'r'); hold off;
     title(sprintf('Hardware Correlator I,Q, and Mag Plot for %d blocks', ProDial.Blocks))
     xlabel('Time(s)');
     ylabel('Correlator Output');
     legend('HW Corr I', 'HW Corr Q', 'HW Corr Mag')
  end
  if(PlotHwCorrAngle.Enable == 1)
      figure;
      plot(TimeVecHw, Pro.HW.Angle);
      title('Hardware Correlator Angle Plot')
      xlabel('Time(s)');
      ylabel('Angle(degrees)');
  end
end
%Plot SW Correlator
if PlotSwCorrIq.Enable || PlotSwCorrAngle.Enable 
  TimeVecSw=Tsw*(0:(ProDial.Blocks/ProDial.Pdi-1)); %Tsw= ProDial.Pdi*Thw
  if(PlotSwCorrIq.Enable == 1)
     figure;
     plot(TimeVecSw,Pro.SW.I, 'k'); hold on;
     plot(TimeVecSw,Pro.SW.Q, 'g');
     plot(TimeVecSw,Pro.SW.Mag,'r'); hold off;
     title(sprintf('Software Correlator I,Q, and Mag Plot for %d blocks', ProDial.Blocks))
     xlabel('Time(s)');
     ylabel('Correlator Output');
     legend('SW Corr I', 'SW Corr Q', 'SW Corr Mag')
  end
  if(PlotSwCorrAngle.Enable == 1)
      figure;
      plot(TimeVecSw, Pro.SW.Angle);
      title('Software Correlator Angle Plot')
      xlabel('Time(s)');
      ylabel('Angle(degrees)');
  end
end
% Plot Descriminators
if PlotPdiscr.Enable || PlotFdiscr.Enable
    figure;
    TimeVecPd=Tsw*(0:(ProDial.Blocks/ProDial.Pdi-1));
    plot(TimeVecPd, Pro.SW.PhiErr);
    if (ProDial.PDiscrType == 1) %Use Costas title
        title('Costas PLL Phase Discriminator'); 
    else
        title('Pure PLL Phase Discriminator');
    end
    xlabel('Time(s)');
    ylabel('Phase Error (degrees)');
end
% Adi updated plots
% if Adi.Collect
%   TimeVecAdi=Thw*Pro.PAdi*(0:(Adi.NumDumps-1));
% end

