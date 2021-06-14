clear; clf; clc;
addpath(genpath('A_functions'))
load('../Data/data.mat');  cols;

lte = [dat.lte2000];
ste = [dat.ste2000];

ind = isnan(lte) | isnan(ste); %erase those non-enhancing ones
lte = lte(~ind);
ste = ste(~ind);

% Statistic
fprintf('\n')
fprintf('Higher first/second %0.2f\n',sum(ste>lte)/numel(lte)*100)
fprintf('mean %0.2f +- std %0.2f vs mean %0.2f +- std %0.2f \n',mean(lte),std(lte), mean(ste), std(ste))
fprintf('median %0.2f +- iqr %0.2f vs median %0.2f +- iqr %0.2f \n ',median(lte),iqr(lte), median(ste), iqr(ste))

fprintf('\n')
fprintf('mean(STE - LTE) %0.2f +-  %0.2f \n',mean(ste-lte), std(ste-lte))
fprintf('median(STE - LTE) %0.2f +- IQR  %0.2f \n \n',median(ste-lte), iqr(ste-lte))

p = signrank(lte,ste);
fprintf('Wilcoxon signed rank test for means p = %0.2e\n',p)

p = signrank(ste-lte);
fprintf('Wilcoxon signed rank test for differences STE - LTE p = %0.2e\n ',p)


%Plot
hold on
for i = 1:size(lte,2)
    line([0 1], [lte(i), ste(i)],'LineStyle','-','Color',uint8([150 150 150]),'Linewidth',3)
end
plot(zeros(1,size(lte,2)),lte,'.','MarkerSize',50,'Color',lte_col)
plot(ones(1,size(ste,2)),ste,'.','MarkerSize',50,'Color',ste_col)

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



print(sprintf('SIR.png'),'-dpng','-r300')