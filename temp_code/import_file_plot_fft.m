%IMPORT_FILE_PLOT_FFT imports quantized signals and plots time domain and
%Code provided by CSCE 587 and modified by Lt. Michael Ledford
%freq domain
close all;clear all;clc;  % clear out everything 
%% Switches
TD = 1; %Plot Time Domain Signals
FD = 1; %Plot Freq. Domain Signals


Fs = 48e3;  % sample rate of the signal

% calls the function found in importfile.m
imported_sig1 = importfile('signal_number_one.txt');
%  if the file is too large, you can specify the howmany samples from the
%  file you want to import into a vector (below is an example of how to
%  load just the first thousand samples from sample 1 to 1000 in the file.
%imported_signal = importfile('captured_output_signal.txt, 1, 1000);
imported_sig2 = importfile('signal_number_two.txt');
imported_sig3 = importfile('signal_number_three.txt');
imported_mixed_sig =importfile('mixed_signal.txt');
imported_filtered_mixed_sig = importfile('filtered_mix_sig.txt');

%% Plot the Time Domain Signals
t1 = (0:length(imported_sig1)-1)/Fs;
t2 = (0:length(imported_sig2)-1)/Fs;
t3 = (0:length(imported_sig3)-1)/Fs;
tmixed = (0:length(imported_mixed_sig)-1)/Fs;
tmixedfilt = (0:length(imported_filtered_mixed_sig)-1)/Fs;
if (TD == 1)
    figure; 
    subplot(3,1,1);
    plot(t1,imported_sig1,'b'); hold on;
    plot(t2,imported_sig2,'r');
    plot(t3,imported_sig3,'g'); 
    plot(tmixed, imported_mixed_sig, 'm:*');
    legend('Signal 1', 'Signal 2', 'Signal 3', 'Mixed Signal');
    xlabel('Time (S)');title('Quantized: Signals 1,2,3 & Mixed, unfiltered'); hold off;
    subplot(3,1,2)
    plot(tmixed, imported_mixed_sig)
    xlabel('Time (S)');title('Quantized: Mixed Signal, unfiltered');
    subplot(3,1,3)
    plot(tmixedfilt,imported_filtered_mixed_sig);
    xlabel('Time (S)');title('Quantized: Mixed Signal, filtered'); hold;
end

                                    
%% plot the frequency domain plot
if (FD == 1)
    figure; 
    subplot(2,1,1);plot(linspace((-Fs/2),(Fs/2),length(imported_mixed_sig)),fftshift(abs(fft(imported_mixed_sig))));
    xlabel('Frequency (Hz)');title('Quantized: Mixed Signal'); hold;
    subplot(2,1,2);plot(linspace((-Fs/2),(Fs/2),length(imported_filtered_mixed_sig)),fftshift(abs(fft(imported_filtered_mixed_sig)))); 
    xlabel('Frequency (Hz)');title('Quantized: Mixed Signal Filtered'); hold;
end
