close all;clear all;clc;  % clear out everything 

s_wordlen = 8; % sample word bit length (number of bits in a word)
Fs = 100e6;  % sample freq
fsig1=100e4;    % signal one freq 1MHz
fsig2=20e4;     % signal two freq 200 KHz
t=0:1/Fs:1000*(1/fsig2); % vector starts a 0, inrements by 1/Fs, and ends at (1000*(1/fsig2))
sig1 = sin(2*pi*fsig1*t); % vector that holds the elements of a sine wave w period 1/fsig1
sig2 = sin(2*pi*fsig2*t);
%% normalize and quantize to s_wordlen bit numbers
sig1_fp = fi(sig1, 1, s_wordlen, s_wordlen - 1); % returns embedded object holding fixed point values, see matlab help for fi() explanation 
sig1_fp = sig1_fp.data; % returns fixed point values in object sig1_fp
sig1_norm = sig1_fp * 2^(s_wordlen - 1); % integer value of s_wordlen bit 2's complement
sig2_fp = fi(sig2, 1, s_wordlen, s_wordlen - 1);
sig2_fp = sig2_fp.data;
sig2_norm = sig2_fp * 2^(s_wordlen - 1);
%% output to text files
dlmwrite('signal_number_one.txt', sig1_norm', 'newline', 'pc');
dlmwrite('signal_number_two.txt', sig2_norm', 'newline', 'pc');