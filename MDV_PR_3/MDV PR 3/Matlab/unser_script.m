
% Auslesen des ADU bzw. Einlesen der aufgenommenen Werte

%a=ucAnalogRead('COM14', 15000, 2000, 'NONE', 0)
load a;


% Konvertieren der digitalen ADU-Werte in Spannungen
b=Code2Volt(a);

% Ausschneiden einer Flanke
[val,min_ind]=min(b);
[val,max_ind]=max(b);
c=b(min_ind:max_ind);

% Plotten der Ausgeschnittenen Flanke
t=[min_ind:1:max_ind];
figure(1);
clf();
plot(t,c,'*');

% Regressionsgerade erstellen
n=polyfit(t',c,1);
d=polyval(n,t');

% Plotten der Flanke und der Regressionsgerade
figure(2);
clf();
plot(t',c,'*',t',d,'r-')

% Die Steigung ermitteln
m=(c(250)-c(200))/(250-200);

% Den Offset ermitteln
Mitte_ind=length(c)/2;
of=c(Mitte_ind);





% Rauschen: Differenzsignal aus Regression und Signal
r=c-d;

% Plotten des Rauschen
figure(3);
clf();
plot(t',r)

% Effektivwert des Rauschens
r_eff=sqrt(mean(r.^2));

% Effektivwert des Signals
c_eff=sqrt(mean(b.^2));

% Berechnung des Signal-Rausch-Verhältnisses
SNR=20*log(c_eff/r_eff);

% Amplitudengang des Tiefpassfilters
f=[5 1000 1250 1500 1750 2000 3000 3500 4000 4500 5000 5500 6000 6500 7000 8000 9000 10000];
H=[4.5827 4.5599 4.4335 4.1968 3.8557 3.3739 1.3839 0.7583 0.3883 0.2162 0.1333 0.1035 0.0941 0.0903 0.0915 0.0915 0.0930 0.0933]./15;
Amp= 20*log(H);

% Plotten des Amplitudengsngs
figure(4);
clf();
b = mkfilter(3100/(2*pi),8,'butterw');
bode(b,'-');
grid on;
semilogx(f,Amp)
