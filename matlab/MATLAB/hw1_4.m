% Create n-vector
n = -1:1:10;
% Create impulse response
x = zeros(1,12);
x(2) = 1;
%Create impulse response
h = [0 1 0 .25 .5 0 .125 .25 0 .0625 .125 0];
y = conv(x,h);
grid on
stem(y)
