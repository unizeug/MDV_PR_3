


% designs an order n lowpass digital Butterworth filter with normalized cutoff
% frequency Wn. It returns the zeros and poles in length n column vectors z and p,
% and the gain in the scalar k.
%[z,p,k] = butter(2,3.1*(10^3));

%butw = mkfilter(0.5,4,'butterw'); 
b = mkfilter(10,2,'butterw')
bode(b,'-');
grid on;
% megend('Butterworth')