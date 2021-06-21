clear; clf; clc;
addpath(genpath('A_functions'))
load('Data/Fig2.mat');  cols;

s.fullfile = '../../data/processed/Glioma_project/20180817_1/T1_coreg';
s.base_path = '../../data/processed';
s.subject_name = 'Glioma_project_113';
s.exam_name = '20180817_1';
s.modality_name = 'T1_coreg';
s.c_exam = 2;
xps = mdm_xps_load(fullfile(s.base_path, s.subject_name,s.exam_name,s.modality_name,'FWF_topup_xps.mat'));

m_size = 60;
l_w = 3;

hold on
plot([0 700 1400 2000],[data.s0, data.lte700, data.lte1400, data.lte2000],'--','linewidth',l_w,'Color',lte_col)
plot([0 700 1400 2000],[data.s0, data.lte700, data.lte1400, data.lte2000],'.','Markersize',m_size,'Color',lte_col)
plot([0 700 1400 2000],[data.s0, data.ste700, data.ste1400, data.ste2000],'--','linewidth',l_w,'Color',ste_col)
plot([0 700 1400 2000],[data.s0, data.ste700, data.ste1400, data.ste2000],'.','Markersize',m_size,'Color',ste_col)
hold on

xticks([0 700 1400 2000])
yticks([1 1.5 2 2.5])
xlim([0 2100])
ylim([1 2.5])

set(gca,'FontSize',25)
set(gca,'box','off')
ax = gca;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;
ax = gca;
set(ax,'tickdir','out');










