


figure(1);
clf();
b = mkfilter(3100/(2*pi),8,'butterw');
bode(b,'-');
grid on;
