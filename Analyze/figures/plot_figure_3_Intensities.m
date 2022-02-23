clear; load('../dat.mat'); clf; clc;

bof = [dat.bof];
ind = ~isnan([dat.SIR_lte]) & ~isnan([dat.SIR_ste]) & [dat.SIR_lte] > 1.0;

ste_hyper = [dat.ste_in_hyper];
ste_NAWM  = [dat.ste_in_NAWM];
lte_hyper = [dat.lte_in_hyper];
lte_NAWM  = [dat.lte_in_NAWM];

ste_hyper = ste_hyper(ind);
ste_NAWM  = ste_NAWM(ind);
lte_hyper = lte_hyper(ind);
lte_NAWM  = lte_NAWM(ind);
bof = bof(ind);

lte_col = [79 140 191]./255;
ste_col = [192 80 77]./255;


if (0) %Hyperintensity 
    for i = 1:size(lte_hyper,2)
        line([0 1], [lte_hyper(i), ste_hyper(i)],'LineStyle','-','Color',uint8([150 150 150]),'Linewidth',3)
    end
    hold on
    plot(zeros(1,size(lte_hyper,2)),lte_hyper,'.','MarkerSize',50,'Color',lte_col)
    plot(ones(1,size(ste_hyper,2)),ste_hyper,'.','MarkerSize',50,'Color',ste_col)


else %NAWM
    for i = 1:size(lte_hyper,2)
        line([0 1], [lte_NAWM(i), ste_NAWM(i)],'LineStyle','-','Color',uint8([150 150 150]),'Linewidth',3)
    end
    hold on
    plot(zeros(1,size(lte_NAWM,2)),lte_NAWM,'.','MarkerSize',50,'Color',lte_col)
    plot(ones(1,size(ste_NAWM,2)),ste_NAWM,'.','MarkerSize',50,'Color',ste_col)
end


fprintf('\n')
fprintf(' Cases %0.0f\n ',sum(ind))
fprintf('Average decrease NAWM =  %0.1f +- std = %0.1f\n ',mean(lte_NAWM-ste_NAWM),std(lte_NAWM-ste_NAWM))
fprintf('Average decrease Hyper =  %0.1f +- std = %0.1f\n ',mean(lte_hyper-ste_hyper),std(lte_hyper-ste_hyper))
fprintf('Ratio decrease %0.2f\n ',mean(lte_NAWM-ste_NAWM)/mean(lte_hyper-ste_hyper))

fprintf('\n')
q_LTE = quantile(lte_NAWM-ste_NAWM,3);
q_STE = quantile(lte_hyper-ste_hyper,3);


fprintf('Decrease NAWM =  %0.1f (%0.1f - %0.1f)\n ',median(lte_NAWM-ste_NAWM),q_LTE(1),q_LTE(3))
fprintf('Decrease hyperintensity =  %0.1f (%0.1f - %0.1f)\n ',median(lte_hyper-ste_hyper),q_STE(1), q_STE(3))
fprintf('Ratio decrease %0.2f\n ',median(lte_NAWM-ste_NAWM)/median(lte_hyper-ste_hyper))


fprintf('\n')
fprintf('Decrease in NAWM is higher than in hyperintensity in %0.0f of the cases\n ',sum((lte_NAWM-ste_NAWM)./(lte_hyper-ste_hyper)>=1))

xlim([-0.35 1.2])
ylim([0 120])
xticks([0 1])
yticks([0 30 60 90 120])
yticklabels({'0','30','60','90','120'})

xticklabels({'',''})
set(gca,'FontSize',30)
set(gca,'box','off')

ax = gca;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;

ax = gca;
set(ax,'tickdir','out');
ax.XGrid = 'off';
ax.YGrid = 'on';
