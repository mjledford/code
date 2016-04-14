format long g;
%a = 1000.002230230239334324324
%Use fi tool
%fi(a,0,42,32) % 0 means unsigned, 16 bits, 15 fractional
a = 10.25
b = 10.25 * 2^2
%comes out to be a whole number so we need 2 fractional bits
%10 can be represented with 4 bits
%Word length is 4 + 2
wl = ceil(log2(a)) + 2
fi_a = fi(a,0,wl,2)
fi_a.bin
%dec2bin 