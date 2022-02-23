function dat = ROI_extract_fn(s)
% function dat = ROI_extract(s)

global dat no

tp = '../data/processed';
rp = '../data/roi_Enhancements';

if (nargin == 0)
    clc; mdm_iter_lund(tp, @ROI_extract_fn); return;
end


if isempty(no)
    no = 1;
end

if (~strcmp(s.modality_name, 'T1_coreg')), return; end

op = fullfile(tp, s.subject_name, s.exam_name, 'T1_coreg');
disp(s.subject_name)

%Filenames: ROIs
roi_ste_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_STE_enh.nii.gz'));
roi_lte_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_LTE_enh.nii.gz'));
roi_WMc_fn = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_WM_contra.nii.gz'));

%Filenames: Contrasts
pgd_fn     = fullfile(op,'T1_MPRAGE_postc.nii.gz');
ste2000_fn = fullfile(op,'STE_b_2000c.nii.gz');
lte2000_fn = fullfile(op,'LTE_b_2000c.nii.gz');

%If it does not have LTE or post-Gd scan, skip
if ~exist(lte2000_fn) || ~exist(pgd_fn)
    dat(no).bof = str2num(s.subject_name(end-2:end));
    dat(no).del = 1;
    no = no + 1;
    disp('   No LTE scan or T1w post-Gd scan')
    return;
end

%Load ROIs if it has, if it does not -> non-enhaning tumor
%It is non-enhancing if ROI does not exist or SIR =< 1.0
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

% Load contrasts if they exist
I_ste2000 = mdm_nii_read(ste2000_fn);
I_lte2000 = mdm_nii_read(lte2000_fn);

%Pull out values from ROIs and save
dat(no).lte_in_hyper = mean(I_lte2000(I_roi_lte > 0),'omitnan');
dat(no).lte_in_NAWM  = mean(I_lte2000(I_roi_WMc > 0),'omitnan');
dat(no).ste_in_hyper = mean(I_ste2000(I_roi_lte > 0),'omitnan');
dat(no).ste_in_NAWM  = mean(I_ste2000(I_roi_WMc > 0),'omitnan');

%Calculate SIR
dat(no).SIR_lte = dat(no).lte_in_hyper / dat(no).lte_in_NAWM;
dat(no).SIR_ste = dat(no).ste_in_hyper / dat(no).ste_in_NAWM;

try %Fetch data for CNR and calculate CNR
    fn_STE_STD = fullfile(tp, s.subject_name, s.exam_name, 'Diff','ver2','Serie_01_FWF','STD_STE_2000.nii.gz');
    I_STE2STD  = mdm_nii_read(fn_STE_STD);
    
    fn_ROI_STE_STD = fullfile(rp,strcat(s.subject_name(end-2:end),'_',s.exam_name,'_STD2SNR_b2000.nii.gz'));
    I_roi_STD      = mdm_nii_read(fn_ROI_STE_STD);
    
    %Calculate CNR 
    dat(no).noise = mean(I_STE2STD(I_roi_STD > 0));       
    dat(no).CNR_lte = (dat(no).lte_in_hyper - dat(no).lte_in_NAWM)./dat(no).noise;
    dat(no).CNR_ste = (dat(no).ste_in_hyper - dat(no).ste_in_NAWM)./dat(no).noise;    

catch %If files do not exist
    dat(no).noise = NaN;
    dat(no).CNR_lte = NaN;
    dat(no).CNR_ste = NaN;

    disp('   No CNR')
end

%Save patient info for trackability
dat(no).patnum = str2num(s.subject_name(end-2:end));
dat(no).s = s;

no = no + 1;

end