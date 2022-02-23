

if (1)
    clear all
    addpath('..')
    
    s.fullfile = '../../data/processed/casex/T1_coreg';
    s.base_path = '../../data/processed';
    s.subject_name = 'casex';
    s.exam_name = 'casex';
    s.modality_name = 'T1_coreg';
    s.c_exam = 2;
    
    tp = '../../data/processed';
    rp = '../../data/roi_Enhancements';
    op = fullfile(tp, s.subject_name, s.exam_name, 'T1_coreg');
    
    s0_fn      = fullfile(op,'dtd_covariance_s0.nii.gz');
    ste2000_fn = fullfile(op,'STE_b_2000c.nii.gz');
    lte2000_fn = fullfile(op,'LTE_b_2000c.nii.gz');
    ste1400_fn = fullfile(op,'STE_b_1400c.nii.gz');
    lte1400_fn = fullfile(op,'LTE_b_1400c.nii.gz');
    ste700_fn  = fullfile(op,'STE_b_700c.nii.gz');
    lte700_fn  = fullfile(op,'LTE_b_700c.nii.gz');
    
    roi_ste_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_STE_enh.nii.gz'));
    roi_lte_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_LTE_enh.nii.gz'));
    roi_WMc_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_WM_contra.nii.gz'));
    
    I_ste2000 = mdm_nii_read(ste2000_fn);
    I_lte2000 = mdm_nii_read(lte2000_fn);
    I_ste1400 = mdm_nii_read(ste1400_fn);
    I_lte1400 = mdm_nii_read(lte1400_fn);
    I_ste700 = mdm_nii_read(ste700_fn);
    I_lte700 = mdm_nii_read(lte700_fn);
    I_s0     = mdm_nii_read(s0_fn);
    
    I_roi_lte = mdm_nii_read(roi_lte_fn);
    
    I_roi_WMc = mdm_nii_read(roi_WMc_fn);
    
    s_lte2000 = mean(I_lte2000(I_roi_lte > 0),'omitnan');
    s_lte1400 = mean(I_lte1400(I_roi_lte > 0),'omitnan');
    s_lte700  = mean(I_lte700(I_roi_lte > 0),'omitnan');
    
    s_ste2000 = mean(I_ste2000(I_roi_lte > 0),'omitnan');
    s_ste1400 = mean(I_ste1400(I_roi_lte > 0),'omitnan');
    s_ste700  = mean(I_ste700(I_roi_lte > 0),'omitnan');
    
    s_s0     = mean(I_s0(I_roi_lte > 0),'omitnan');
    
    w_lte2000 = mean(I_lte2000(I_roi_WMc > 0),'omitnan');
    w_lte1400 = mean(I_lte1400(I_roi_WMc > 0),'omitnan');
    w_lte700  = mean(I_lte700(I_roi_WMc > 0),'omitnan');
    
    w_ste2000 = mean(I_ste2000(I_roi_WMc > 0),'omitnan');
    w_ste1400 = mean(I_ste1400(I_roi_WMc > 0),'omitnan');
    w_ste700  = mean(I_ste700(I_roi_WMc > 0),'omitnan');
    
    w_s0     = mean(I_s0(     I_roi_WMc > 0),'omitnan');
    
    lte2000 = s_lte2000 / w_lte2000;
    lte1400 = s_lte1400 / w_lte1400;
    lte700  = s_lte700  / w_lte700;
    ste2000 = s_ste2000 / w_ste2000;
    ste1400 = s_ste1400 / w_ste1400;
    ste700  = s_ste700  / w_ste700;
    s0      = s_s0      / w_s0;
    
    I = mdm_nii_read(fullfile(s.base_path, s.subject_name,s.exam_name,s.modality_name,'FWF_topup.nii.gz'));
    xps = mdm_xps_load(fullfile(s.base_path, s.subject_name,s.exam_name,s.modality_name,'FWF_topup_xps.mat'));
    
end

lte_col = [79 140 191]./255;
ste_col = [192 80 77]./255;
m_size = 60;
l_w = 3;


clf;


opt = mdm_opt;
opt = mio_opt(opt);
opt.mio.ref_extrapolate.do_subspace_fit = 1;
opt.do_overwrite = 1;
opt.mask.do_overwrite = 1;
opt.verbose      = 1;
opt.filter_sigma = 0.6;
opt.dtd_covariance.do_regularization = 1;
opt = dtd_covariance_opt(opt);
for i = 1:57
    I2 = I(:,:,:,i);
    signal_tu(i) = mean(I2(I_roi_lte > 0),'omitnan');
    signal_wm(i) = mean(I2(I_roi_WMc > 0),'omitnan');
end
% [m,cond,n_rank] = dtd_covariance_1d_data2fit(signal', xps, opt)


subplot(4,1,1)
my_dtd_covariance_plot(signal_tu', xps)



subplot(4,1,2)
my_dtd_covariance_plot(signal_wm', xps)


subplot(4,1,3)
hold on
plot([0 0.700 1.4 2.0],[s0, s_lte700/w_lte700, s_lte1400/w_lte1400, s_lte2000/w_lte2000],':','linewidth',l_w,'Color',lte_col)
plot([0 0.700 1.4 2.0],[s0, s_lte700/w_lte700, s_lte1400/w_lte1400, s_lte2000/w_lte2000],'.','Markersize',m_size,'Color',lte_col)
plot([0 0.700 1.4 2.0],[s0, s_ste700/w_ste700, s_ste1400/w_ste1400, s_ste2000/w_ste2000],'--','linewidth',l_w,'Color',ste_col)
plot([0 0.700 1.4 2.0],[s0, s_ste700/w_ste700, s_ste1400/w_ste1400, s_ste2000/w_ste2000],'.','Markersize',m_size,'Color',ste_col)

xticks([0 0.7 1.4 2.0])
xticklabels({'0' '700' '1400' '2000'})
yticks([1 1.5 2 2.5])
xlim([0 2.1])
ylim([1 2.5])

set(gca,'FontSize',25)
set(gca,'box','off')
ax = gca;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;
ax = gca;
set(ax,'tickdir','out');





subplot(4,1,4)
hold on

fn_STE_STD = fullfile(tp, s.subject_name, s.exam_name, 'Diff','ver2','Serie_01_FWF','STD_STE_2000.nii.gz');
I_STE2STD = mdm_nii_read(fn_STE_STD);

fn_ROI_STE_STD = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_STD2SNR_b2000.nii.gz'));
I_roi_STD = mdm_nii_read(fn_ROI_STE_STD);

noise = mean(I_STE2STD(I_roi_STD > 0));


CNR_LTE0 = (s_s0-w_s0)/noise;
CNR_LTE700 = (s_lte700-w_lte700)/noise;
CNR_LTE1400 = (s_lte1400-w_lte1400)/noise;
CNR_LTE2000 = (s_lte2000-w_lte2000)/noise;

CNR_STE0 = (s_s0-w_s0)/noise;
CNR_STE700 = (s_ste700-w_ste700)/noise;
CNR_STE1400 = (s_ste1400-w_ste1400)/noise;
CNR_STE2000 = (s_ste2000-w_ste2000)/noise;

hold on
plot([0 0.700 1.4 2.0],[CNR_LTE0, CNR_LTE700, CNR_LTE1400, CNR_LTE2000],':','linewidth',l_w,'Color',lte_col)
plot([0 0.700 1.4 2.0],[CNR_LTE0, CNR_LTE700, CNR_LTE1400, CNR_LTE2000],'.','Markersize',m_size,'Color',lte_col)
plot([0 0.700 1.4 2.0],[CNR_STE0, CNR_STE700, CNR_STE1400, CNR_STE2000],'--','linewidth',l_w,'Color',ste_col)
plot([0 0.700 1.4 2.0],[CNR_STE0, CNR_STE700, CNR_STE1400, CNR_STE2000],'.','Markersize',m_size,'Color',ste_col)
hold on

xticks([0 0.7 1.4 2.0])
xticklabels({'0' '700' '1400' '2000'})
xlim([0 2.1])
ylim([0 6])
yticks([0 2 4 6])
yticklabels({'0' '2' '4' '6'})

set(gca,'FontSize',25)
set(gca,'box','off')
ax = gca;
ax.XAxis.LineWidth = 3;
ax.YAxis.LineWidth = 3;
ax = gca;
set(ax,'tickdir','out');