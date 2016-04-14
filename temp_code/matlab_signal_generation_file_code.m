%MATLAB_SIGNAL_GENERATION_FILE_CODE Mixes 3 signals, Quantizes them,
%applies Anti-Aliasing Filter and writes quantized signals to output file
%You can also manually set switches to plot the signals
%Code provided by CSCE 587 and modified by Lt. Michael Ledford

%% Command Line Pre Processing
%clear all; %clears all variables in the workspace
close all; %closes all open figures
clc; %clears e command window
set(0,'defaultfigureWindowStyle','docked'); % Dock figures
%% Switches
% Plotting Switches
PLOT=1; %Set to 1 to turn on plotting: Needs to be 1 in order to plot anything
TD=0; % Set to 1 to plot time domain: Needs to be 1 in order to plot any TD plots
TD_ALL = 0; %Set to 1 to plot all time domain signals & quantized
TD_MIXED = 0; %Set to 1 to only plot mixed & filtered mixed signals
FD=1; % Set to 1 to plot freq domain --> Needs to be 1 to plot any FD plots
FD_ALL = 1; %Set to 1 to plot all signals' freq. domain;
FD_MIXED = 1; %Set to 1 to plot just mixed sig freq. domain;
FD_POWER = 0; %Set to 1 to plot power --> not supported fully yet
% Playing Sound Switches
FP_SOUND=0; %Set to 1 to play fix point sinusoid sound for all signals 
SOUND=0; %Set to 1 to play sound of time domain signals;
FILT_SOUND=0; %Set to 1 to play filtered mixed signal
% Writing to output file switches
WRITE=0; %Set to 1 to write to output file

%% Design Parameters
s_wordlen = 14; % sample word bit length (number of bits in a word)
s_fraclen = s_wordlen-1;
Fs = 48e3;  % sample freq
fsig1=1.5e3;    % signal one freq 1.5 kHz
fsig2=3.2e3;     % signal two freq 3.2 kHz
fsig3 = 8e3;    %signal three freq 8 kHz
t=0:1/Fs:1000*(1/fsig2); % vector starts a 0, inrements by 1/Fs, and ends at (1000*(1/fsig2))
sig1 = sin(2*pi*fsig1*t); % vector that holds the elements of a sine wave w period 1/fsig1
sig2 = sin(2*pi*fsig2*t);
sig3 = sin(2*pi*fsig3*t);
sig4 = sig1 + sig2 + sig3;
%% normalize and quantize to s_wordlen bit numbers
%Signal 1
sig1_fp = fi(sig1, 1, s_wordlen, s_fraclen); % returns embedded object holding fixed point values, see matlab help for fi() explanation 
sig1_fp = sig1_fp.data; % returns fixed point values in object sig1_fp
sig1_norm = sig1_fp * 2^(s_fraclen); % integer value of s_wordlen bit 2's complement
%Signal 2
sig2_fp = fi(sig2, 1, s_wordlen, s_fraclen);
sig2_fp = sig2_fp.data;
sig2_norm = sig2_fp * 2^(s_fraclen);
%Signal 3
sig3_fp = fi(sig3, 1, s_wordlen, s_fraclen);
sig3_fp = sig3_fp.data;
sig3_norm = sig3_fp * 2^(s_fraclen);
%% Mixing using Method 2 from PPT
mixed_sig = sig1_fp + sig2_fp + sig3_fp;
%First, normalize 
mixed_sig_norm = mixed_sig/(max(abs(mixed_sig)));
%Second, quantize the normalized value using fi()to a n-bit fp representation
mixed_sig_fp = fi(mixed_sig_norm,1,s_wordlen, s_fraclen);
mixed_sig_fp = mixed_sig_fp.data;
mixed_sig_norm = mixed_sig_fp * 2^(s_fraclen);

%% Filtering
% The filter’s cutoff frequency, fc, should be less than ½ fsample
% LP FIR filter by kaiser window
% Fc= 2.5 kHz, Wordlength=14, Fraclength=13, Fs=48 kHz
fir_filter_coeff = export_filter_coeffs();
filtered_mixed_sig = filter(fir_filter_coeff.Numerator, 1, mixed_sig_norm);
filtered_mixed_sig_norm = filtered_mixed_sig*2^(s_fraclen);

%% output to text files
if(WRITE==1)
    dlmwrite('signal_number_one.txt', sig1_norm', 'newline', 'pc');
    dlmwrite('signal_number_two.txt', sig2_norm', 'newline', 'pc');
    dlmwrite('signal_number_three.txt', sig3_norm', 'newline', 'pc');
    dlmwrite('mixed_signal.txt', mixed_sig_norm', 'newline', 'pc');
    dlmwrite('filtered_mix_sig.txt', filtered_mixed_sig_norm', 'newline', 'pc', 'precision', '%i'); %precision removes scientific notation
end

%% Plotting
if(PLOT == 1)
    if(TD == 1)
        t1 = (0:length(sig1_norm)-1)/Fs;
        t2 = (0:length(sig2_norm)-1)/Fs;
        t3 = (0:length(sig3_norm)-1)/Fs;
        t4 = (0:length(mixed_sig_norm)-1)/Fs;
        tmixed = (0:length(filtered_mixed_sig)-1)/Fs;
        if(TD_ALL == 1)
            figure;
            subplot(4,1,1);plot(t,sig1);xlabel('Time (S)');title('Time Domain Signal 1: f=1.5 kHz') 
            subplot(4,1,2);plot(t,sig2);xlabel('Time (S)');title('Time Domain Signal 2: f=3.2 kHz')
            subplot(4,1,3);plot(t,sig3);xlabel('Time (S)');title('Time Domain Signal 3: f=8 kHz')
            subplot(4,1,4);plot(t,sig4);xlabel('Time (S)');title('Time Domain Signal Mixed Signal')
            % After fix pointing and quantizing
            figure;
            subplot(5,1,1);plot(t1,sig1_norm);xlabel('Time (S)');title('Quantized: Time Domain Signal 1: f=1.5 kHz') 
            subplot(5,1,2);plot(t2,sig2_norm);xlabel('Time (S)');title('Quantized: Time Domain Signal 2: f=3.2 kHz')
            subplot(5,1,3);plot(t3,sig3_norm);xlabel('Time (S)');title('Quantized: Time Domain Signal 3: f=8 kHz')
            subplot(5,1,4);plot(t4,mixed_sig_norm);xlabel('Time (S)');title('Quantized: Time Domain Mixed Signal')
            subplot(5,1,5);plot(tmixed,filtered_mixed_sig_norm);xlabel('Time (S)');title('Quantized: Time Domain Filtered Mixed Signal')
        end
        if (TD_MIXED == 1)
            figure;
            subplot(2,1,1);plot(t4,mixed_sig_norm);title('Quantized: Time Domain Mixed Signal')
            subplot(2,1,2);plot(tmixed, filtered_mixed_sig_norm);title('Quantized: Filtered Time Domain Mixed Signal')
        end
    end
    if(FD==1)
        if (FD_ALL==1)
            figure; 
            subplot(4,1,1);plot(linspace((-Fs/2),(Fs/2),length(sig1)),fftshift(abs(fft(sig1))));
            xlabel('Frequency (Hz)');title('Signal 1');
            subplot(4,1,2);plot(linspace((-Fs/2),(Fs/2),length(sig2)),fftshift(abs(fft(sig2)))); 
            xlabel('Frequency (Hz)');title('Signal 2'); 
            subplot(4,1,3);plot(linspace((-Fs/2),(Fs/2),length(sig3)),fftshift(abs(fft(sig3))));
            xlabel('Frequency (Hz)');title('Signal 3'); 
            subplot(4,1,4);plot(linspace((-Fs/2),(Fs/2),length(sig4)),fftshift(abs(fft(sig4)))); 
            xlabel('Frequency (Hz)');title('Mixed Signal'); 
            %After fix pointing and quantizing
            figure; 
            subplot(5,1,1);plot(linspace((-Fs/2),(Fs/2),length(sig1_norm)),fftshift(abs(fft(sig1_norm))));
            xlabel('Frequency (Hz)');title('Quantized: Signal 1');
            subplot(5,1,2);plot(linspace((-Fs/2),(Fs/2),length(sig2_norm)),fftshift(abs(fft(sig2_norm)))); 
            xlabel('Frequency (Hz)');title('Quantized: Signal 2'); 
            subplot(5,1,3);plot(linspace((-Fs/2),(Fs/2),length(sig3_norm)),fftshift(abs(fft(sig3_norm))));
            xlabel('Frequency (Hz)');title('Quantized: Signal 3'); 
            subplot(5,1,4);plot(linspace((-Fs/2),(Fs/2),length(mixed_sig_norm)),fftshift(abs(fft(mixed_sig_norm)))); 
            xlabel('Frequency (Hz)');title('Quantized: Mixed Signal'); 
            subplot(5,1,5);plot(linspace((-Fs/2),(Fs/2),length(filtered_mixed_sig_norm)),fftshift(abs(fft(filtered_mixed_sig_norm)))); 
            xlabel('Frequency (Hz)');title('Quantized: Filtered Mixed Signal'); 
        end
        if(FD_MIXED == 1)
           %Mixed Signal
           figure; 
           subplot(2,1,1);plot(linspace((-Fs/2),(Fs/2),length(mixed_sig_norm)),fftshift(abs(fft(mixed_sig_norm))));
           xlabel('Frequency (Hz)');title('Mixed Signal'); 
           %Filtered Mixed Signal
           subplot(2,1,2);plot(linspace((-Fs/2),(Fs/2),length(filtered_mixed_sig)),fftshift(abs(fft(filtered_mixed_sig)))); 
           xlabel('Frequency (Hz)');title('Mixed Signal Filtered');
           if(FD_POWER == 1)
            figure;
            subplot(2,1,1);plot(linspace((-Fs/2),(Fs/2),length(mixed_sig_norm)),fftshift(20*log10(abs(fft(mixed_sig_norm)))));
            xlabel('Frequency (Hz)');title('Mixed Signal'); 
            subplot(2,1,2);plot(linspace((-Fs/2),(Fs/2),length(filtered_mixed_sig)),fftshift(20*log10(abs(fft(filtered_mixed_sig))))); 
            xlabel('Frequency(Hz)');title('Mixed Signal Filtered');
           end
        end
    end
end

%% Playback sound
if (SOUND == 1)
    soundsc(sig1,Fs)
    pause(3);
    soundsc(sig2,Fs)
    pause(3);
    soundsc(sig3,Fs)
    pause(3);
    soundsc(sig4,Fs)
end
if (FP_SOUND == 1)
    pause(3)
    soundsc(sig1_fp,Fs)
    pause(3);
    soundsc(sig2_fp,Fs)
    pause(3);
    soundsc(sig3_fp,Fs)
    pause(3);
    soundsc(mixed_sig,Fs)
end
if (FILT_SOUND == 1)
    pause (3);
    soundsc(filtered_mixed_sig, Fs)
end