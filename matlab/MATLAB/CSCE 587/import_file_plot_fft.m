close all;clear all;clc;  % clear out everything 

Fs = 48e3;  % sample rate of the signal

% calls the function found in importfile.m
imported_signal_1 = importfile('signal_number_one.txt');
%  if the file is too large, you can specify the howmany samples from the
%  file you want to import into a vector (below is an example of how to
%  load just the first thousand samples from sample 1 to 1000 in the file.
%imported_signal = importfile('captured_output_signal.txt, 1, 1000);
imported_signal_2 = importfile('signal_number_two.txt');
imported_signal_3 = importfile('signal_number_three.txt');


%%Plot the Time Domain Signals
t1 = (0:length(imported_signal_1)-1)/Fs;
t2 = (0:length(imported_signal_2)-1)/Fs;
figure; 
subplot(2,1,1);
plot(t1,imported_signal_1,'b');
xlabel('Time (S)');title('Signal 1, unfiltered'); hold;
subplot(2,1,2)
plot(t2,imported_signal_1,'r');
xlabel('Time (S)');title('Signal 2, filtered'); hold;
                                    
% plot the frequency domain plot
figure; subplot(2,1,1);plot(linspace((-Fs/2),(Fs/2),length(imported_signal_1)),fftshift(abs(fft(imported_signal_1))));
xlabel('Frequency (Hz)');title('Signal 1'); hold;
subplot(2,1,2);plot(linspace((-Fs/2),(Fs/2),length(imported_signal_2)),fftshift(abs(fft(imported_signal_2)))); 
xlabel('Frequency (Hz)');title('Signal 2'); hold;
