clc
clear
close all
%% Plot Parameters
width = 8;     % Width in inches
height = 4;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz =20 ;      % Fontsize
lw = 1;        % LineWidth
msz = 8;       % MarkerSize
%% Load from Workspace  Structure  
HvacEE=load('HvacEE.mat');
CavEE=load('CavEE.mat');
VavEE=load('VavEE.mat');
%% 
for j=1:96;
EpsilonHVAC(j)=HvacEE.Rep(2,j).Result(1).Best.Cost(1);
EpsilonCAV(j)=CavEE.Rep(2,j).Result(1).Best.Cost(1);
EpsilonVAV(j)=VavEE.Rep(2,j).Result(1).Best.Cost(1);
%
TsupplyHVAC(j)=HvacEE.Rep(2,j).Result(1).Best.Tsupply;
TsupplyCAV(j)=CavEE.Rep(2,j).Result(1).Best.Tsupply;
TsupplyVAV(j)=VavEE.Rep(2,j).Result(1).Best.Tsupply;
%
MsupplyHVAC(j)=HvacEE.Rep(2,j).Result(1).Best.Msupply;
MsupplyCAV(j)=CavEE.Rep(2,j).Result(1).Best.Msupply;
MsupplyVAV(j)=VavEE.Rep(2,j).Result(1).Best.Msupply;
%
EnergyHVAC(j)=HvacEE.Rep(2,j).Result(1).Best.Cost(2);
EnergyCAV(j)=CavEE.Rep(2,j).Result(1).Best.Cost(2);
EnergyVAV(j)=VavEE.Rep(2,j).Result(1).Best.Cost(2);
%
TmixHVAC(j)=HvacEE.Rep(2,j).Result(1).Best.Tmix;
TmixCAV(j)=CavEE.Rep(2,j).Result(1).Best.Tmix;
TmixVAV(j)=VavEE.Rep(2,j).Result(1).Best.Tmix;
%
Aco2HVAC(j)=HvacEE.Rep(2,j).Result(1).Best.Aco2;
Aco2CAV(j)=CavEE.Rep(2,j).Result(1).Best.Aco2;
Aco2VAV(j)=VavEE.Rep(2,j).Result(1).Best.Aco2;
%
TsetHVAC(j)=HvacEE.Rep(2,j).Result(1).Best.Tset;
TsetCAV(j)=CavEE.Rep(2,j).Result(1).Best.Tset;
TsetVAV(j)=VavEE.Rep(2,j).Result(1).Best.Tset;
  end;
%   O=numel(HvacEE.Rep);
Col=1;
for o=1:numel(5)
epsilonHVAC(o)=HvacEE.Rep(o,Col).Result(1).Best.Cost(1);
epsilonCAV(o)=CavEE.Rep(o,Col).Result(1).Best.Cost(1);
epsilonVAV(o)=VavEE.Rep(o,Col).Result(1).Best.Cost(1);

energyHVAC(o)=HvacEE.Rep(o,Col).Result(1).Best.Cost(2);
energyCAV(o)=CavEE.Rep(o,Col).Result(1).Best.Cost(2);
energyVAV(o)=VavEE.Rep(o,Col).Result(1).Best.Cost(2);
end
for i=1:5
    for j=1:3
X(i,j)=Rep(:,1).Result(1:end).Best.Cost(1);
    Y(i,j)=Rep(:,1).Result(1:end).Best.Cost(2);
    end;
end
%% Time - Occupancy
ToutD=[7.8 7.6 7.4 7.2 7 7 7 7 7 7 7 7 7 6.9 6.8 6.7
         6.6 6.5 6.4 6.3 6 6 6 6 6 6.2 6.4 6.5 6.8 7 7.5 7.8
         7.9 7.95 8 8.1 8.2 8.3 9 9.5 10 10.1 10.3 10.5 11 11.5 12.2  13
         13.5 13.7 14.1 14.2  14.5 15 15.1 15.7 16.1 16.2 16.3 16.4 16.5 16.6 16.7 16.8 
         16.9 17 17 17 17 16.8 16.7 16.6 16.5 16.4 16.3 15.8 15.5 15 14.2 13
         12.8 12.7 12.6 12.5 12.4 11.8 11 10.5 10 10.1 10.2 10.5 10.6 11 10.8 9.8];
Nocc=[5 4 10 0 0 10 9  6 9  9 10 5 8 7 6 0
      10 5 8 10 1 1 6 5 45 43 42 25 25 26 44 45
      83 62 84 61 62 82 65 82 85 80 82 65 85 89 87 62
      66 66 81 80 85 70 65 63 85 65 70 78 70 82 75 63
      85 63 70 68 78 63 71 63 30 43 32 40 50 38 42 43
      38 41 25 45 3 5 18 10 18 8 7 0 13 10 11 12];
ToutD=[ToutD(1,:) ToutD(2,:) ToutD(3,:) ToutD(4,:) ToutD(5,:) ToutD(6,:)];
Occupancy=[Nocc(1,:) Nocc(2,:) Nocc(3,:) Nocc(4,:) Nocc(5,:) Nocc(6,:)];
time=1:96;
%% Figure 1
figure
plot(time,ToutD,'-bs','linewidth',2)
grid minor
xlabel('Time - sec','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
ylabel('T_o_u_t - Kelvin','fontsize',fsz-5,'FontName','Times New Roman')
title('Outdoor Temperature','fontsize',fsz-5,'FontName','Times New Roman')
%% Figure 2
figure
plot(time,Occupancy,'-bs','linewidth',2)
grid minor
xlabel('Time - sec','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
ylabel('Number of Occupancts','fontsize',fsz-5,'FontName','Times New Roman')
title('Occupancy Variation','fontsize',fsz-5,'FontName','Times New Roman')
%% Figure 3
figure
plot(epsilonHVAC,energyHVAC,'rs','linewidth',2)
hold on
plot(epsilonCAV,energyCAV,'bo','linewidth',2)
hold on
plot(epsilonVAV,energyVAV,'k*','linewidth',2)
grid minor
xlabel('|T_i_n-T_s_e_t| - Kelvin','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
ylabel('Energy - Watt','fontsize',fsz-5,'FontName','Times New Roman')
title('Pareto Front N=5','fontsize',fsz-5,'FontName','Times New Roman')
h=legend('HVAC','CAV','VAV','Location','southeast');
set(h,'FontName','Times New Roman');
%% Figure 4  Pareto Front HVAC Model
figure
plot(EpsilonHVAC,EnergyHVAC,'rs','linewidth',2)
grid minor
xlabel('|T_i_n-T_s_e_t| - Kelvin','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
ylabel('Energy  - Watt','fontsize',fsz-5,'FontName','Times New Roman')
title('Pareto Front HVAC Model','fontsize',fsz-5,'FontName','Times New Roman')
%% Figure 5  Pareto Front CAV Model
figure
plot(EpsilonCAV,EnergyCAV,'bo','linewidth',2)
grid minor
xlabel('|T_i_n-T_s_e_t| - Kelvin','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
ylabel('Energy - Watt','fontsize',fsz-5,'FontName','Times New Roman')
title('Pareto Front CAV Model','fontsize',fsz-5,'FontName','Times New Roman')
%% Figure 6  Pareto Front VAV Model
figure
plot(EpsilonVAV,EnergyVAV,'k*','linewidth',2)
grid minor
xlabel('|T_i_n-T_s_e_t| - Kelvin','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
ylabel('Energy - Watt','fontsize',fsz-5,'FontName','Times New Roman')
title('Pareto Front VAV Model','fontsize',fsz-5,'FontName','Times New Roman')
%% Figure 7    A-CO2
figure
subplot(3,1,1)
plot(time,Aco2HVAC,'r','linewidth',2)
grid minor
xlabel('Time - sec','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
% ylabel('CO_2 Concentration - ppm','fontsize',fsz-5,'FontName','Times New Roman')
title('Indoor CO_2 Concentration Variation in a Cold Day','fontsize',fsz-5,'FontName','Times New Roman')
h=legend('HVAC');
set(h,'FontName','Times New Roman');
subplot(3,1,2)
plot(time,Aco2CAV,'b','linewidth',2)
grid minor
xlabel('Time - sec','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
ylabel('CO_2 Concentration - ppm','fontsize',fsz-5,'FontName','Times New Roman')
% title('Indoor CO_2 Concentration Variation in a Cold Day','fontsize',fsz-5,'FontName','Times New Roman')
h=legend('CAV');
set(h,'FontName','Times New Roman');

subplot(3,1,3)
plot(time,Aco2VAV,'k','linewidth',2)
grid minor
xlabel('Time - sec','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
% ylabel('CO_2 Concentration - ppm','fontsize',fsz-5,'FontName','Times New Roman')
% title('Indoor CO_2 Concentration Variation in a Cold Day','fontsize',fsz-5,'FontName','Times New Roman')
h=legend('VAV');
set(h,'FontName','Times New Roman');
%% Figure 8    Energy
figure
plot(time,EnergyHVAC,'r','linewidth',2)
hold on
plot(time,EnergyCAV,'b','linewidth',2)
hold on
plot(time,EnergyVAV,'k','linewidth',2)
grid minor
xlabel('Time - sec','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
ylabel('Energy - Watt','fontsize',fsz-5,'FontName','Times New Roman')
title('Energy consumption of three control designs','fontsize',fsz-5,'FontName','Times New Roman')
h=legend('HVAC','CAV','VAV');
set(h,'FontName','Times New Roman');
%% Figure 9 Optimal Temperture
figure
plot(time,EpsilonHVAC,'r','linewidth',2)
hold on
plot(time,EpsilonCAV,'b','linewidth',2)
hold on
plot(time,EpsilonVAV,'k','linewidth',2)
grid minor
xlabel('Time - sec','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
ylabel('|T_i_n-T_s_e_t| - Kelvin','fontsize',fsz-5,'FontName','Times New Roman')
title('Epsilon','fontsize',fsz-5,'FontName','Times New Roman')
h=legend('HVAC','CAV','VAV');
set(h,'FontName','Times New Roman');
%% Figure 10 Tsupply
figure
plot(time,TsupplyHVAC,'r','linewidth',2)
hold on
plot(time,TsupplyCAV,'b','linewidth',2)
hold on
plot(time,TsupplyVAV,'k','linewidth',2)
grid minor
xlabel('Time - sec','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
ylabel('Tsupply - Kelvin','fontsize',fsz-5,'FontName','Times New Roman')
title('Outdoor Temperature Variation in a Cold Day','fontsize',fsz-5,'FontName','Times New Roman')
h=legend('HVAC','CAV','VAV');
set(h,'FontName','Times New Roman');
%% Figure 11 Msupply
figure
plot(time,MsupplyHVAC,'r','linewidth',2)
hold on
plot(time,MsupplyCAV,'b','linewidth',4)
hold on
plot(time,MsupplyVAV,'k','linewidth',2)
grid minor
xlabel('Time - sec','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
ylabel('Msupply - m^3/sec','fontsize',fsz-5,'FontName','Times New Roman')
title('Outdoor Temperature Variation in a Cold Day','fontsize',fsz-5,'FontName','Times New Roman')
h=legend('HVAC','CAV','VAV');
set(h,'FontName','Times New Roman');
ylim([800,10500])
%% Figure 12 Tmix
figure
plot(time,TmixHVAC,'r','linewidth',2)
hold on
plot(time,TmixCAV,'b','linewidth',2)
hold on
plot(time,TmixVAV,'k','linewidth',2)
grid minor
xlabel('Time - sec','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
ylabel('Tmix - Kelvin','fontsize',fsz-5,'FontName','Times New Roman')
title('Mixer Temperature ','fontsize',fsz-5,'FontName','Times New Roman')
h=legend('HVAC','CAV','VAV');
set(h,'FontName','Times New Roman');
ylim([-5,50])
%% Figure 13 Tset
figure
plot(time,TsetHVAC,'r','linewidth',2)
hold on
plot(time,TsetCAV,'b','linewidth',2)
hold on
plot(time,TsetVAV,'k','linewidth',2)
grid minor
xlabel('Time - sec','fontsize',fsz-5,'FontName','Times New Roman') ;% 96*15=24*60 min
ylabel('Tset - Kelvin','fontsize',fsz-5,'FontName','Times New Roman')
title('SetPoint Temperature ','fontsize',fsz-5,'FontName','Times New Roman')
h=legend('HVAC','CAV','VAV');
set(h,'FontName','Times New Roman');