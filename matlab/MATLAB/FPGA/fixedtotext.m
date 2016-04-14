%This script converts 2 different signals to fixed point int values and
%writes to output file

fc_nco = 21 * 10^3; %center frequency for NCO signal
fc_in = 22 * 10^3; %Input
fs = 48 * 10^3;
dt = 1 / fs;
t = 0:dt:3;
y_nco= sin(2*pi*fc_nco*t);
y_in= sin(2*pi*fc_in*t);
y_fi_nco = fi(y_nco,1,12,11); %12 is how many bits you 
y_fi_in = fi(y_in,1,12,11); %12 is how many bits you
%y_fi3 = double(y_fi1) .* double(y_fi2); 
%b = y_fi.data; %takes fixed point values from fix point object
y_fi_nco_toi = y_fi_nco.int'; %converts to int
y_fi_in_toi = y_fi_in.int'; %converts to int
%Need to have wordlength of 16 and fractional of 14
mult = y_fi_in .* y_fi_nco;
mult_fi = fi(mult,1,16,14);
mult_fi_toi = mult_fi.int';
%y_fi_mult_toi = double(y_fi_nco_toi) .* double(y_fi_in_toi);
format long g;
dlmwrite('signal_nco_int.txt',y_fi_nco_toi);
dlmwrite('signal_in_int.txt',y_fi_in_toi);
dlmwrite('check_mult.txt',mult_fi_toi, 'precision', '%i');