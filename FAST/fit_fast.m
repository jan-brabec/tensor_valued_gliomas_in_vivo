function a = fit_fast(s,follow_part)
% function a = fit_fast(s)

a = [];
tp = '../data/processed/';

if (nargin == 0)
    mdm_iter_lund(tp, @fit_fast);
    return;
end

if (nargin == 1)
    follow_part = [];
end

%%%
% 'T1', 'T2', 'dMRI' or 'T1_follow', 'T2_follow', 'dMRI_follow'
what = 'dMRI';
%%%

if (~strcmp(s.modality_name, 'T1_coreg')), return; end
% if (~strcmp(s.subject_name(end-2:end), '113')), return; end

% 
if  (~strcmp(s.subject_name(end:end), '0')) &&...
    (~strcmp(s.subject_name(end-2:end), '105')) &&...
    (~strcmp(s.subject_name(end-2:end), '108'))&&...
    (~strcmp(s.subject_name(end-2:end), '111')) &&...
    (~strcmp(s.subject_name(end-2:end), '113')) &&...
    (~strcmp(s.subject_name(end-2:end), '120')) &&...
    (~strcmp(s.subject_name(end-2:end), '131')) &&...
    (~strcmp(s.subject_name(end-2:end), '139')) &&...
    (~strcmp(s.subject_name(end-2:end), '146')) &&...
    (~strcmp(s.subject_name(end-2:end), '147')) &&...
    (~strcmp(s.subject_name(end-2:end), '152')), return; end

% pat = str2num(s.subject_name(end-2:end));
% if pat < 152, return; end

disp(s.subject_name)

% if exist(fullfile(tp,s.subject_name,s.exam_name,'T1_coreg','LTE_b_2000c.nii.gz'))
%     return;
% end

tmp_dir = fullfile(s.base_path,s.subject_name,s.exam_name,'tmp_fast');
if (~exist(tmp_dir, 'dir')), mkdir(tmp_dir); end

if strcmp(what,'dMRI')
    % Compute field on B0 field and apply to b > 0 images
    i_nii_fn = fullfile(s.fullfile,'FWF_topup_pa.nii.gz');
elseif strcmp(what,'dMRI_follow')
    i_nii_fn = fullfile(s.fullfile,strcat(num2str(follow_part),'_FWF_topup_pa.nii.gz'));        
elseif strcmp(what,'T1')
    i_nii_fn = fullfile(s.fullfile,'T1_MPRAGE_pre.nii.gz');
elseif strcmp(what,'T2')
    i_nii_fn = fullfile(s.fullfile,'T2_FLAIR.nii.gz');
elseif strcmp(what,'T1_follow')
    i_nii_fn = fullfile(s.fullfile,strcat(num2str(follow_part),'_T1_MPRAGE_pre.nii.gz'));        
elseif strcmp(what,'T2_follow')
    i_nii_fn = fullfile(s.fullfile,strcat(num2str(follow_part),'_T2_FLAIR.nii.gz'));        
end

[~, ~, my_ext] = msf_fileparts(i_nii_fn);
tmp_fn          = fullfile(tmp_dir, ['tmp' my_ext]);
tmp_bet_fn      = fullfile(tmp_dir, ['tmp_bet' my_ext]);
tmp_field_fn    = fullfile(tmp_dir, ['tmp_bet_bias' my_ext]);

[I,h] = mdm_nii_read(i_nii_fn);
I = I(:,:,:,1); %select B0,
mdm_nii_write(I, tmp_fn, h);

% Run BET
cmd = sprintf('bet %s %s -f 0.1', tmp_fn, tmp_bet_fn);
cmd_full = ['/bin/bash --login -c '' ' cmd ' '' '];
system(cmd_full);

% Run FAST, -l is bias field smoothing extent (FWHM) in mm; default=20
if strcmp(what,'dMRI') || strcmp(what,'dMRI_follow')
    cmd = sprintf('fast -n 3 -t 1 -b -v -l 55 %s', tmp_bet_fn);
elseif strcmp(what,'T1') || strcmp(what,'T1_follow')
    cmd = sprintf('fast -n 3 -t 1 -b -v -l 45 %s', tmp_bet_fn);
elseif strcmp(what,'T2') || strcmp(what,'T2_follow')
    cmd = sprintf('fast -n 3 -t 1 -b -v -l 45 %s', tmp_bet_fn);
end

cmd_full = ['/bin/bash --login -c '' ' cmd ' '' '];
system(cmd_full);

% Bias field correction
if strcmp(what,'dMRI')
    i_contrasts = {...
        'STE_b_700.nii.gz'...
        'STE_b_1400.nii.gz'...
        'STE_b_2000.nii.gz'...
        'LTE_b_700.nii.gz'...
        'LTE_b_1400.nii.gz'...
        'LTE_b_2000.nii.gz'...
        'STE_single_shots.nii.gz'...
        'dtd_covariance_s0.nii.gz'};
    
    o_contrasts = {...
        'STE_b_700c.nii.gz'...
        'STE_b_1400c.nii.gz'...
        'STE_b_2000c.nii.gz'...
        'LTE_b_700c.nii.gz'...
        'LTE_b_1400c.nii.gz'...
        'LTE_b_2000c.nii.gz'...
        'STE_single_shotsc.nii.gz'...
        'dtd_covariance_s0c.nii.gz'};
    
elseif strcmp(what,'dMRI_follow')
    i_contrasts = {...
        strcat(num2str(follow_part),'_STE_b_2000.nii.gz')...
        strcat(num2str(follow_part),'_LTE_b_2000.nii.gz')};
    
    o_contrasts = {...
        strcat(num2str(follow_part),'_STE_b_2000c.nii.gz')...
        strcat(num2str(follow_part),'_LTE_b_2000c.nii.gz')};    
    
elseif strcmp(what,'T1')
    
    i_contrasts = {...
        'T1_MPRAGE_pre.nii.gz'...
        'T1_MPRAGE_post.nii.gz'};
    
    o_contrasts = {...
        'T1_MPRAGE_prec.nii.gz'...
        'T1_MPRAGE_postc.nii.gz'};
    
elseif strcmp(what,'T1_follow')
    
    i_contrasts = {...
        strcat(num2str(follow_part),'_T1_MPRAGE_pre.nii.gz')...
        strcat(num2str(follow_part),'_T1_MPRAGE_post.nii.gz')};  
    
    o_contrasts = {...
        strcat(num2str(follow_part),'_T1_MPRAGE_prec.nii.gz')...
        strcat(num2str(follow_part),'_T1_MPRAGE_postc.nii.gz')};        
    
elseif strcmp(what,'T2')
    
    i_contrasts = {'T2_FLAIR.nii.gz'};
    o_contrasts = {'T2_FLAIRc.nii.gz'};    
    
elseif strcmp(what,'T2_follow')
    
    i_contrasts = {strcat(num2str(follow_part),'_T2_FLAIR.nii.gz')};
    o_contrasts = {strcat(num2str(follow_part),'_T2_FLAIRc.nii.gz')};    
    
end

I_bias_f = mdm_nii_read(tmp_field_fn);

for c_exp = 1:numel(i_contrasts)
    
    i_nii_contrast_fn  = fullfile(s.fullfile,i_contrasts{c_exp});
    [I_con,h] = mdm_nii_read(i_nii_contrast_fn);
    
    %Apply bias field
    I_corr = double(I_con) ./ double(I_bias_f);
    
    % Save field and image
    if strcmp(what,'dMRI') || strcmp(what,'dMRI_follow')
        o_nii_mask_fn     = fullfile(s.fullfile,'FAST_field_dMRI.nii.gz');
    elseif strcmp(what,'T1') || strcmp(what,'T1_follow')
        o_nii_mask_fn     = fullfile(s.fullfile,'FAST_field_T1.nii.gz');
    elseif strcmp(what,'T2') || strcmp(what,'T2_follow')
        o_nii_mask_fn     = fullfile(s.fullfile,'FAST_field_T2.nii.gz');
    end
    
    o_nii_contrast_fn = fullfile(s.fullfile,o_contrasts{c_exp});
    
    mdm_nii_write(I_bias_f, o_nii_mask_fn, h);
    mdm_nii_write(I_corr, o_nii_contrast_fn, h);
    disp(['Corrected: ' o_nii_contrast_fn]);
    
end

rmdir(tmp_dir, 's');

end
