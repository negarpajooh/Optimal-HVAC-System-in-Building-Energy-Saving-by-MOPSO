clc;
clear;
close all;
global  Q1 Q2 t N Msupply Tsupply Tmix  TypeModel Aco2 ...
    Tout time Tset z1 z2 Tk 
%%
TypeModel=questdlg('Plz Select Model?','Selection','HVAC','CAV','VAV','HVAC') 
%%
ToutD=[7.8 7.6 7.4 7.2 7 7 7 7 7 7 7 7 7 6.9 6.8 6.7
         6.6 6.5 6.4 6.3 6 6 6 6 6 6.2 6.4 6.5 6.8 7 7.5 7.8
         7.9 7.95 8 8.1 8.2 8.3 9 9.5 10 10.1 10.3 10.5 11 11.5 12.2  13
         13.5 13.7 14.1 14.2  14.5 15 15.1 15.7 16.1 16.2 16.3 16.4 16.5 16.6 16.7 16.8 
         16.9 17 17 17 17 16.8 16.7 16.6 16.5 16.4 16.3 15.8 15.5 15 14.2 13
         12.8 12.7 12.6 12.5 12.4 11.8 11 10.5 10 10.1 10.2 10.5 10.6 11 10.8 9.8];
 NN=[5 4 10 0 0 10 9  6 9  9 10 5 8 7 6 0
      10 5 8 10 1 1 6 5 45 43 42 25 25 26 44 45
      83 62 84 61 62 82 65 82 85 80 82 65 85 89 87 62
      66 66 81 80 85 70 65 63 85 65 70 78 70 82 75 63
      85 63 70 68 78 63 71 63 30 43 32 40 50 38 42 43
      38 41 25 45 3 5 18 10 18 8 7 0 13 10 11 12];
  time=1:96;
for k=1:numel(time);
       t=time(k);
       N=NN(k);
       Tout=ToutD(k)+273.15;
%% Problem Definition
CostFunction=@(x) EE(x);      % Cost Function
%
nVar=1;               % Number of Decision Variables
%
VarSize=[1 nVar];     % Size of Decision Variables Matrix
VarMin=1000;             % Lower Bound of Variables
VarMax=10000;          % Upper Bound of Variables
%
%
%% MOPSO Parameters
%
MaxIt=5;          % Maximum Number of Iterations
%
nPop=50;            % Population Size
%
nRep=50;            % Repository Size
%% Constriction Coefficient
phi1=2.05;
phi2=2.05;
phi=phi1+phi2;
chi=2/(phi-2+sqrt((phi^2)-4*phi));
w=chi;
wdamp=1;
c1=chi*phi1;
c2=chi*phi2;
%
%% velocity limits
VelMax=0.1*(VarMax-VarMin);
VelMin=-VelMax;
%
nGrid=10;           % Number of Grids per Dimension
alpha=0.1;          % Inflation Rate
%
beta=.5;             % Leader Selection Pressure
gamma=2;            % Deletion Selection Pressure
%
mu=0.1;             % Mutation Rate
%
%% Initialization
empty_particle.Position=[];
empty_particle.Velocity=[];
%
empty_particle.Msupply=[];
empty_particle.Tsupply=[];
empty_particle.Tmix=[];
empty_particle.Tset=[];
%
empty_particle.Cost=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
%
empty_particle.Best.Msupply=[];
empty_particle.Best.Tsupply=[];
empty_particle.Best.Tmix=[];
empty_particle.Best.Tset=[];
%
empty_particle.IsDominated=[];
empty_particle.GridIndex=[];
empty_particle.GridSubIndex=[];
pop=repmat(empty_particle,nPop,1);
for i=1:nPop
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    pop(i).Velocity=zeros(VarSize);
    %
    pop(i).Tsupply=Tsupply;
    pop(i).Msupply=Msupply;
    pop(i).Tmix=Tmix;
    pop(i).Aco2=Aco2;
     pop(i).Tset=Tset;
    %
    pop(i).Cost=CostFunction(pop(i).Position);
    %
    % Update Personal Best
    pop(i).Best.Position=pop(i).Position;
    pop(i).Best.Cost=pop(i).Cost;
    pop(i).Best.Tsupply=Tsupply;
    pop(i).Best.Msupply=Msupply;
    pop(i).Best.Tmix=Tmix;
    pop(i).Best.Aco2=Aco2;
    pop(i).Best.Tset=Tset;
end
%% Determine Domination
pop=DetermineDomination(pop);
rep=pop(~[pop.IsDominated]);
Grid=CreateGrid(rep,nGrid,alpha);
for i=1:numel(rep)
    rep(i)=FindGridIndex(rep(i),Grid);
end
%% MOPSO Main Loop
for it=1:MaxIt
    for i=1:nPop
        leader=SelectLeader(rep,beta);
        pop(i).Velocity = w*pop(i).Velocity ...
            +c1*rand(VarSize).*(pop(i).Best.Position-pop(i).Position) ...
            +c2*rand(VarSize).*(leader.Position-pop(i).Position);
        %% Apply Velocity Limits
        pop(i).Velocity=...
            max(pop(i).Velocity,VelMin);
        pop(i).Velocity=...
            max(pop(i).Velocity,VelMax);
        %% Velocity Mirror Effect
        IsOutside=...
            (pop(i).Position<VarMin | pop(i).Position>VarMax);
        pop(i).Velocity(IsOutside)=...
            -pop(i).Velocity(IsOutside);
        %% Apply Position Limits
        pop(i).Position=...
            max(pop(i).Position,VarMin);
        pop(i).Position=...
            min(pop(i).Position,VarMax);
        %
        pop(i).Cost = CostFunction(pop(i).Position);
        % Apply Mutation
        pm=(1-(it-1)/(MaxIt-1))^(1/mu);
        NewSol.Position=Mutate(pop(i).Position,pm,VarMin,VarMax);
        NewSol.Cost=CostFunction(NewSol.Position);%%%%%%%%
        %
        if Dominates(NewSol,pop(i))
            pop(i).Position=NewSol.Position;
            pop(i).Cost=NewSol.Cost;
            %
        elseif Dominates(pop(i),NewSol)
            % Do Nothing
        else
            if rand<0.5
                pop(i).Position=NewSol.Position;
                pop(i).Cost=NewSol.Cost;
            end
        end
        if Dominates(pop(i),pop(i).Best)
            pop(i).Best.Position=pop(i).Position;
            pop(i).Best.Cost=pop(i).Cost;
            %
            pop(i).Best.Tsupply=pop(i).Tsupply;
            pop(i).Best.Msupply=pop(i).Msupply;
            pop(i).Best.Tmix=pop(i).Tmix;
            pop(i).Best.Aco2=pop(i).Aco2;
            pop(i).Best.Tset=pop(i).Tset;
%
        elseif Dominates(pop(i).Best,pop(i))
            % Do Nothing
        else
            if rand<0.5
                pop(i).Best.Position=pop(i).Position;
                pop(i).Best.Cost=pop(i).Cost;
                %
                pop(i).Best.Tsupply=pop(i).Tsupply;
                pop(i).Best.Msupply=pop(i).Msupply;
                pop(i).Best.Tmix=pop(i).Tmix;
                pop(i).Best.Aco2=pop(i).Aco2;
                pop(i).Best.Tset=pop(i).Tset;
%
            end
        end
    end
%% Add Non-Dominated Particles to REPOSITORY
    rep=[rep;pop(~[pop.IsDominated])];
%% Determine Domination of New Resository Members
    rep=DetermineDomination(rep);
%% Keep only Non-Dminated Memebrs in the Repository
    rep=rep(~[rep.IsDominated]);
%% Update Grid
    Grid=CreateGrid(rep,nGrid,alpha);
%% Update Grid Indices
    for i=1:numel(rep)
        rep(i)=FindGridIndex(rep(i),Grid);
%         M(i)=getframe;
    end
%% Check if Repository is Full
        if numel(rep)>nRep
        Extra=numel(rep)-nRep;
        for e=1:Extra
            rep=DeleteOneRepMemebr(rep,gamma);
        end
        end
%% Plot Costs
    figure(1);
    PlotCostEE(pop,rep);
%% Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of Rep Members = ' num2str(numel(rep))]);
%% Damping Inertia Weight
    w=w*wdamp;
     Rep(it,k).Result=rep;
end
end
    switch  TypeModel
        case 'HVAC' 
save('HvacEE','Rep')
        case 'CAV'
save('CavEE','Rep')
        case 'VAV'
save('VavEE','Rep')
    end;
%     end;
