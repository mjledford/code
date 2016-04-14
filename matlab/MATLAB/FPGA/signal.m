%Creating a signal
fc = 1 * 10^3;
fc1 = 21 * 10^3; %center frequency for NCO signal
fc2 = 22 * 10^3; 
fs = 48 * 10^3;
dt = 1 / fs;
t = 0:dt:3;
y = sin(2*pi*fc*t);
y1= sin(2*pi*fc1*t);
y2= sin(2*pi*fc2*t);
%y_new = 20*log10(y); %converting to dB scale
%time domain plotting
%figure(1);
%subplot(2,1,1);
%plot (t,y1);
%subplot(2,1,2);
%plot (t,y2);
%hearing sound
%soundsc(y,fs);
%plot in frequency domain
% fft_y1 = fft(y1);
% fft_y2 = fft(y2);
% bins = linspace(0,fs,length(y1)); %x value
% bins2 = linspace(0,fs,length(y2));
% figure(2);
% subplot(2,1,1);
% plot(bins,20*log10(abs(fft_y1)), 'm');
% xlabel('bins');
% ylabel('dB');
% subplot(2,1,2);
% plot(bins2,20*log10(abs(fft_y2)), 'c');
% xlabel('bins');
% ylabel('dB');

% Part 3
%y3_2 = y1 .* y2;
%figure(3);
%title('Time Domain');
%plot(t,y3);
%fft_y3 = fft(y3_2);
%bins3 = linspace(0,fs,length(y3));
%figure(4);
%title('Freq Domain');
%plot(bins3, 20*log10(abs(fft_y3)));
%soundsc(y3,fs);
%pause(5)
%y4 = filter(Num2,1,y3); %b = coefficients
%soundsc(y4,fs);

%plot(t,y4);
% fft_y4 = fft(y4);
% bins4 = linspace(0,fs,length(y4));
% plot(bins4, 20*log10(abs(fft_y4)));

%Fixed Point 21 kHz
soundsc(y1,fs);
pause(5);
figure(1);
y_fft = fft(y1);
 bins = linspace(0,fs,length(y1));
 
 plot(bins,20*log10(abs(y_fft)));
 title('FFT of original');
 y_fi = fi(y1,1,12,11); %12 is how many bits you 
 b = y_fi.data; %takes fixed point values from fix point object
 y_fi_fft = fft(b);
 bins_yfft = linspace(0,fs,length(y_fi_fft));
figure(2)
 
plot(bins_yfft,20*log10(abs(y_fi_fft)))
 title('FFT of FI');
soundsc(b,fs)


%22 KHz as input
%21 is NOC

%Fix point input signal
 y2_fi = fi(y2,1,12,11);
 y1_fi = fi(y1,1,12,11);
 y3_fi = y2_fi .* y1_fi;
 y3_fi_data = y3_fi.data;
 fft_y3 = fft(y3_fi_data);
 bins = linspace(0,fs,length(fft_y3));
 figure(1)
 plot(bins, 20*log10(abs(fft_y3)));
 title('Before Filtering');
 y4 = filter(Num,1,y3_fi_data); %b = coefficients %11 fractional, %16 word length
 fft_y4 = fft(y4);
 bins4 = linspace(0,fs,length(y4));
 figure(2)
 plot(bins4, 20*log10(abs(fft_y4)));
 title('After Filtering');
%soundsc(y3_fi_data, fs);