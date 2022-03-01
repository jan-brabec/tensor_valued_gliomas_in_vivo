clear; load('../dat.mat'); clf; clc;

ind = ~isnan([dat.SIR_lte]) & ~isnan([dat.SIR_ste]) & [dat.SIR_lte] > 1.0 & ~isnan([dat.noise]);

SIR_lte = [dat(ind).SIR_lte];
SIR_ste = [dat(ind).SIR_ste];
CNR_lte = [dat(ind).CNR_lte];
CNR_ste = [dat(ind).CNR_ste];
patnum = [dat(ind).patnum];

lte_col = [79 140 191]./255;
ste_col = [192 80 77]./255;

for i = 1:size(CNR_lte,2)
    line([0 1], [CNR_lte(i), CNR_ste(i)],'LineStyle','-','Color',uint8([150 150 150]),'Linewidth',3)
end
hold on
plot(zeros(1,size(CNR_lte,2)),CNR_lte,'.','MarkerSize',50,'Color',lte_col)
plot(ones(1,size(CNR_ste,2)),CNR_ste,'.','MarkerSize',50,'Color',ste_col)

xlim([-0.35 1.2])
ylim([0 5])
xticks([0 1])
yticks([0 2.5 5])
yticklabels({'0.0','2.5','5.0'})
xticklabels({'',''})
set(gca,'FontSize',30)
set(gca,'box','off')

ax = gca;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;
set(ax,'tickdir','out');
ax.XGrid = 'off';
ax.YGrid = 'on';



fprintf('\n')
fprintf(' Cases %0.0f\n ',sum(ind))
fprintf('Higher first/second %0.1f\n ',sum(CNR_ste>CNR_lte)/numel(CNR_lte)*100)
fprintf('mean %0.1f +- std %0.1f vs mean %0.1f +- std %0.1f \n ',mean(CNR_lte),std(CNR_lte), mean(CNR_ste), std(CNR_ste))
fprintf('median %0.1f +- iqr %0.1f vs median %0.1f +- iqr %0.1f \n ',median(CNR_lte),iqr(CNR_lte), median(CNR_ste), iqr(CNR_ste))
fprintf('\n')

q_LTE = quantile(CNR_lte,3);
q_STE = quantile(CNR_ste,3);
fprintf('median %0.1f (%0.1f-%0.1f)  vs median %0.1f (%0.1f-%0.1f)\n ',median(CNR_lte),q_LTE(1),q_LTE(3), median(CNR_ste), q_STE(1),q_STE(3))
fprintf('\n')

fprintf('mean(STE - LTE) %0.1f +-  %0.1f \n',mean(CNR_ste-CNR_lte), std(CNR_ste-CNR_lte))
fprintf('median(STE - LTE) %0.1f +- IQR  %0.1f \n',median(CNR_ste-CNR_lte), iqr(CNR_ste-CNR_lte))

fprintf('\n')
q_CNR_ste_CNR_lte = quantile(CNR_ste-CNR_lte,3);
fprintf('median(STE - LTE) %0.1f (%0.1f-%0.1f) \n',median(CNR_ste-CNR_lte),q_CNR_ste_CNR_lte(1), q_CNR_ste_CNR_lte(3))
fprintf('\n')


p = signrank(CNR_lte,CNR_ste);
fprintf('Wilcoxon signed rank test for means in CNR LTE to CNR STE p = %0.2e\n',p)

p = signrank(CNR_lte-CNR_ste);
fprintf('Wilcoxon signed rank test for differences CNR STE - CNR LTE p = %0.2e\n ',p)

print(sprintf('histo.png'),'-dpng','-r300')
