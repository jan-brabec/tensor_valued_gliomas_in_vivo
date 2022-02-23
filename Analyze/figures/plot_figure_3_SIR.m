clear; load('../dat.mat'); clf; clc;

bof = [dat.bof];
ind = ~isnan([dat.SIR_lte]) & ~isnan([dat.SIR_ste]) & [dat.SIR_lte] > 1.0;

SIR_lte = [dat(ind).SIR_lte];
SIR_ste = [dat(ind).SIR_ste];
bof = bof(ind);

lte_col = [79 140 191]./255;
ste_col = [192 80 77]./255;

for i = 1:size(SIR_lte,2)
    line([0 1], [SIR_lte(i), SIR_ste(i)],'LineStyle','-','Color',uint8([150 150 150]),'Linewidth',3)
end

fprintf('\n')
fprintf(' Cases %0.0f\n ',sum(ind))
fprintf('Higher first/second %0.2f\n ',sum(SIR_ste>SIR_lte)/numel(SIR_lte)*100)
fprintf('mean %0.2f +- std %0.2f vs mean %0.2f +- std %0.2f \n ',mean(SIR_lte),std(SIR_lte), mean(SIR_ste), std(SIR_ste))
fprintf('median %0.2f +- iqr %0.2f vs median %0.2f +- iqr %0.2f \n ',median(SIR_lte),iqr(SIR_lte), median(SIR_ste), iqr(SIR_ste))

fprintf('\n')
q_LTE = quantile(SIR_lte,3);
q_STE = quantile(SIR_ste,3);
fprintf('median %0.1f (%0.1f-%0.1f)  vs median %0.1f (%0.1f-%0.1f)\n ',median(SIR_lte),q_LTE(1),q_LTE(3), median(SIR_ste), q_STE(1),q_STE(3))
fprintf('\n')

fprintf('mean(STE - SIR_lte) %0.2f +-  %0.2f \n',mean(SIR_ste-SIR_lte), std(SIR_ste-SIR_lte))
fprintf('median(STE - SIR_lte) %0.2f +- IQR  %0.2f \n',median(SIR_ste-SIR_lte), iqr(SIR_ste-SIR_lte))

fprintf('\n')
q_SIR_ste_SIR_lte = quantile(SIR_ste-SIR_lte,3);
fprintf('median(STE - LTE) %0.1f (%0.1f-%0.1f) \n',median(SIR_ste-SIR_lte),q_SIR_ste_SIR_lte(1), q_SIR_ste_SIR_lte(3))
fprintf('\n')
fprintf('Median ratio = improement %0.2f\n',median(SIR_ste)/median(SIR_lte))

fprintf('\n')


hold on
plot(zeros(1,size(SIR_lte,2)),SIR_lte,'.','MarkerSize',50,'Color',lte_col)
plot(ones(1,size(SIR_ste,2)),SIR_ste,'.','MarkerSize',50,'Color',ste_col)

xlim([-0.35 1.2])
ylim([0.5 3])
xticks([0 1])
yticks([1 1.5 2 2.5 3])
yticklabels({'1.0','1.5','2.0','2.5','3.0'})

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

p = signrank(SIR_lte,SIR_ste);

fprintf('Wilcoxon signed rank test for means p = %0.2e\n',p)

p = signrank(SIR_ste-SIR_lte);

fprintf('Wilcoxon signed rank test for differences SIR_ste - SIR_lte p = %0.2e\n ',p)

print(sprintf('histo.png'),'-dpng','-r300')

