function dat = ROI_extract_fn(s)
% function dat = ROI_extract(s)

global dat iter_no

tp = '../data/processed';
rp = '../data/roi_Enhancements';

if (nargin == 0)
    clc; mdm_iter_lund(tp, @ROI_extract_fn); return;
end

if (~strcmp(s.modality_name, 'T1_coreg')), return; end
% if (~strcmp(s.subject_name(end-2:end), '113')), return; end

op = fullfile(tp, s.subject_name, s.exam_name, 'T1_coreg');

disp(s.subject_name)

roi_ste_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_STE_enh.nii.gz'));
roi_lte_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_LTE_enh.nii.gz'));
roi_WMc_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_WM_contra.nii.gz'));

pgd_fn = fullfile(op,'T1_MPRAGE_postc.nii.gz');

ste2000_fn = fullfile(op,'STE_b_2000c.nii.gz');
lte2000_fn = fullfile(op,'LTE_b_2000c.nii.gz');

if ~exist(lte2000_fn) || ~exist(pgd_fn)
    dat(iter_no).pat = str2num(s.subject_name(end-2:end));
    dat(iter_no).del = 1;
    iter_no = iter_no + 1;
    return;
end

try
    I_roi_ste = mdm_nii_read(roi_ste_fn);
catch
    I_roi_ste = 0;
end

try
    I_roi_lte = mdm_nii_read(roi_lte_fn);
catch
    I_roi_lte = 0;
end

try
    I_roi_WMc = mdm_nii_read(roi_WMc_fn);
catch
    I_roi_WMc = 0;
end

try
    I_ste2000 = mdm_nii_read(ste2000_fn);
catch
    I_ste2000 = 0;
end

try
    I_lte2000 = mdm_nii_read(lte2000_fn);
catch
    I_lte2000 = 0;
end

lte2000 = mean(I_lte2000(I_roi_lte > 0),'omitnan') / mean(I_lte2000(I_roi_WMc > 0),'omitnan');
sprintf('LTE2000: %0.2g',lte2000)

ste2000 = mean(I_ste2000(I_roi_ste > 0),'omitnan') / mean(I_ste2000(I_roi_WMc > 0),'omitnan');
sprintf('STE2000: %0.2g',ste2000)

dat(iter_no).pat = str2num(s.subject_name(end-2:end));
dat(iter_no).lte2000 = lte2000;
dat(iter_no).ste2000 = ste2000;
dat(iter_no).del     = 0;
dat(iter_no).no_of_voxel_in_roi_wmc = numel(find(I_roi_WMc>0));
dat(iter_no).no_of_voxel_in_lte     = numel(find(I_roi_lte>0));
dat(iter_no).no_of_voxel_in_ste     = numel(find(I_roi_ste>0));
dat(iter_no).s = s;
sprintf('-----------------')



if strcmp(s.subject_name(end-2:end), '113') && strcmp(s.exam_name, '20180817_1') %This is for figure 2
    
    I_s0      = mdm_nii_read(fullfile(op,'dtd_covariance_s0.nii.gz'));
    I_ste1400 = mdm_nii_read(fullfile(op,'STE_b_1400c.nii.gz'));
    I_lte1400 = mdm_nii_read(fullfile(op,'LTE_b_1400c.nii.gz'));
    I_ste700  = mdm_nii_read(fullfile(op,'STE_b_700c.nii.gz'));
    I_lte700  = mdm_nii_read(fullfile(op,'LTE_b_700c.nii.gz'));
    
    lte2000 = mean(I_lte2000(I_roi_lte > 0),'omitnan') / mean(I_lte2000(I_roi_WMc > 0),'omitnan');
    lte1400 = mean(I_lte1400(I_roi_lte > 0),'omitnan') / mean(I_lte1400(I_roi_WMc > 0),'omitnan');
    lte700 = mean(I_lte700(I_roi_lte > 0),'omitnan') / mean(I_lte700(I_roi_WMc > 0),'omitnan');
    
    ste2000 = mean(I_ste2000(I_roi_lte > 0),'omitnan') / mean(I_ste2000(I_roi_WMc > 0),'omitnan');
    ste1400 = mean(I_ste1400(I_roi_ste > 0),'omitnan') / mean(I_ste1400(I_roi_WMc > 0),'omitnan');
    ste700 = mean(I_ste700(I_roi_ste > 0),'omitnan') / mean(I_ste700(I_roi_WMc > 0),'omitnan');
    
    s_s0     = mean(I_s0(I_roi_lte > 0),'omitnan') / mean(I_s0(I_roi_WMc > 0),'omitnan');
    
    I_all = mdm_nii_read(fullfile(s.base_path, s.subject_name,s.exam_name,s.modality_name,'FWF_topup.nii.gz'));
    
    for i = 1:size(I_all,4)
        I2 = I_all(:,:,:,i);
        signal_tu(i) = mean(I2(I_roi_lte > 0),'omitnan');
        signal_wm(i) = mean(I2(I_roi_WMc > 0),'omitnan');
    end
    
    data.lte2000   = lte2000;
    data.lte1400   = lte1400;
    data.lte700    = lte700;    
    
    data.ste2000   = ste2000;
    data.ste1400   = ste1400;
    data.ste700    = ste700;
    
    data.s0        = s_s0;
    
    data.signal_tu = signal_tu;
    data.signal_wm = signal_wm;
    data.pat = str2num(s.subject_name(end-2:end));
    
    save(fullfile('Data','Fig2.mat'),'data')
    
end


iter_no = iter_no + 1;

end


