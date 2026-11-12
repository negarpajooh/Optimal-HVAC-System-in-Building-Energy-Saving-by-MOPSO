function PlotCostEE(pop,rep)

% Defaults for this blog post
width = 8;     % Width in inches
height = 4;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz =16 ;      % Fontsize
lw = 1;      % LineWidth
msz = 8;       % MarkerSize
% pos = get(gcf, 'Position');pop.Cost(1,:)
% set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
% set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
    pop_costs=[pop.Cost];
    plot(pop_costs(1,:),pop_costs(2,:),'o','markersize',10);
    hold on;
    rep_costs=[rep.Cost];
    plot(rep_costs(1,:),rep_costs(2,:),'rs','markersize',10,'markerfacecolor','r');
title('Pareto Front','fontsize',fsz+3,'FontName','Times New Roman')
    xlabel('|T_i_n - T_s_e_t| - C','fontsize',fsz+3,'FontName','Times New Roman');
    ylabel('Energy - Watt','fontsize',fsz+3,'FontName','Times New Roman'); 
    grid on;
    legend('Particle','Best Cost')
    hold off;
end