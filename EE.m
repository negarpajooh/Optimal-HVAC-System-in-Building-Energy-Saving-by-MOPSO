function z=EE(x)
global  Q1 Q2 t N Msupply Tsupply Tmix  TypeModel Aco2 Tout...
    time Tset  z1 z2 
%% Design Variable
    switch  TypeModel
        case 'HVAC' 
            Msupply=x(1);
            Tsupply=(7/900)*x(1);
        case 'CAV'
            Msupply=10000;
            Tsupply=(7/900)*x(1); 
        case 'VAV'
            Msupply=x(1);
            Tsupply=75+273.15;
    end
Tmix=0.005*x(1);
%% Constants
ro=1.225;
G0=1.5;
Amax=1000;
Tin=10+273.15;
A0=900;
Cp=1000;
GammaAir=0.0012;
V=2*3*15*20;
L=0.0052e-3;
b0=0.0165;b1=6.605;b2=-17.1677;b3=18.895;b4=-7.419;
c0=.5067;c1=1.283;c2=-1.42;c3=.5842;
Aout=350;
EttaHeat=.78;
EttaCool=.7;
H0=1.5;
EttaTrans=.4;
Ai=3*15;
hi=6;minf=1;Ts=10+273.15;m=ro*V;alpha=140;betta=10;
%% Integral
% Q2=(alpha*N+betta+hi*Ai*Ts+minf*Cp*Tout+Msupply*Cp*Tsupply)/(m*Cp);
Q1=(hi*Ai+minf*Cp+Msupply*Cp)/(m*Cp);
sim('Temperture')
Tset=max(T.signals.values);
%% Efan
G=Msupply/ro;
XgSupp=G/G0;
EttaMotor=@(Xg) b0+b1*Xg+b2*(Xg^2)+b3*(Xg^3)+b4*(Xg^4);
EttaVFD=@(Xg) c0+c1*Xg+c2*(Xg^2)+c3*(Xg^3);
Efan=(GammaAir*(XgSupp^3)*G0*H0)/(EttaTrans*EttaMotor(XgSupp)*EttaVFD(XgSupp));
%% Eheat Ecool
Eheat=(Msupply*Cp*(Tsupply-Tmix))/EttaHeat;
Ecool=(Msupply*Cp*(Tsupply-Tmix))/EttaCool;
%% Aco2
W1=((Tsupply-Tmix)/(Tsupply-Tout))*Aout;
W2=(N*L*ro)/Msupply;
W3=(Tmix-Tout)/(Tsupply-Tout);
I=G/V;
NUM=@(Time) W1+W2*(A0-W1-W2)*exp(-I*Time);
Num=NUM(time);
DEN=@(Time) 1-W3*(1-W2*exp(-I*Time));
Den=DEN(time);
ACo2=@(Time) (Num/Den);
Aco2=ACo2(time);
%% Cost Func
E=Efan+Eheat+Ecool;
if 292.15<Tset && Tset<298.15
Epsilon=abs(Tin-Tset);
z1=Epsilon;
end;
if Aco2<Amax
z2=E;
end;
z=[z1,z2]';
end