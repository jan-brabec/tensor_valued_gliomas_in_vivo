function a = step3_glioma_pipe(s)
% function a = step2_glioma_pipe(s)

a = [];
ap = '../data/raw';
tp = '../data/processed';
zp = '../data/interim';

if (nargin == 0)
    mdm_iter_lund(ap, @step3_glioma_pipe);
    return;
end

% if (~strcmp(s.subject_name(end-2:end), '113')) || (~strcmp(s.exam_name, '20180817_1')), return; end
% if  (~strcmp(s.subject_name(end-2:end), '105')) &&...
%     (~strcmp(s.subject_name(end-2:end), '108'))&&...
%     (~strcmp(s.subject_name(end-2:end), '111')) &&...
%     (~strcmp(s.subject_name(end-2:end), '120')) &&...
%     (~strcmp(s.subject_name(end-2:end), '131')) &&...
%     (~strcmp(s.subject_name(end-2:end), '139')) &&...
%     (~strcmp(s.subject_name(end-2:end), '146')) &&...
%     (~strcmp(s.subject_name(end-2:end), '147')) &&...
%     (~strcmp(s.subject_name(end-2:end), '152')), return;
% end

disp(s.subject_name);
disp(s.exam_name);

% set options
opt = mdm_opt;
opt = mio_opt(opt);
opt.mio.ref_extrapolate.do_subspace_fit = 1;
opt.do_overwrite = 1;
opt.mask.do_overwrite = 1;
opt.verbose      = 1;
opt.filter_sigma = 0.6;
opt.dtd_covariance.do_regularization = 1;


% set paths
ip = fullfile(ap, s.subject_name, s.exam_name, s.modality_name); %path to raw
op_f = fullfile(tp, s.subject_name, s.exam_name, 'T1/ver1');
op_m = fullfile(tp, s.subject_name, s.exam_name, 'Diff/ver2', 'Serie_01_FWF'); %path to save motion corrected
op_d = fullfile(tp, s.subject_name, s.exam_name, 'Diff/ver3', 'Serie_01_FWF'); %path to save after distortion correction
wp = fullfile(zp, s.subject_name, s.exam_name, 'Diff/ver3', 'Serie_01_FWF');   %interim path
msf_mkdir(op_m); msf_mkdir(op_d); msf_mkdir(wp);

if (1)
    
    %% MOTION CORRECTION
    fprintf('\n Motion correction \n \n')
    
    % connect to data and merge it
    s_lte = mdm_s_from_nii(msf_find_fn(ip, {'*LTE.nii*', '*LTE_v2.nii.gz','*LTE_v3.nii.gz'}), 1);
    s_ste = mdm_s_from_nii(msf_find_fn(ip, {'*STE.nii*', '*STE_v2.nii.gz','*STE_v3.nii.gz'}), 0);
    
    % copy STE LTE   
    
    copyfile( s_lte.nii_fn, fullfile(op_d,'LTE.nii.gz'));
    copyfile( s_ste.nii_fn, fullfile(op_d,'STE.nii.gz'));
    
    s_struc = mdm_s_merge({s_lte, s_ste}, op_m, 'FWF', opt);
    
    % motion correction of reference
    p_fn = elastix_p_write(elastix_p_affine(200), fullfile(op_m, 'p.txt'));
    
    s_lowb = mdm_s_subsample(s_lte, s_lte.xps.b < 1.1e9, op_m, opt);
    s_mec  = mdm_mec_b0(s_lowb, p_fn, op_m, opt);
    
    % extrapolation-based motion correction
    s_mc = mdm_mec_eb(s_struc, s_mec, p_fn, op_m, opt);
    
    % powder average
    s_pa = mdm_s_powder_average(s_mc, op_m, opt);
    
    %% DISTORTION CORRECTION
    fprintf('\n Distortion correction \n \n')
    
    s_pa = mdm_s_from_nii(msf_find_fn(ip, {'*STE_PA.nii*', '*STE_v2_PA.nii.gz', '*STE_v3_PA.nii.gz'}),0);
    s_ap = mdm_s_from_nii(msf_find_fn(fullfile(tp, ...
        s.subject_name, s.exam_name, 'Diff/ver2', 'Serie_01_FWF'), ...
        'FWF_mc.nii*'));
    
    % select the low b-acquisition
    topup_fn = fullfile(op_d, 'FWF_topup.nii.gz');
    
    s_corr    = mdm_s_topup(s_ap, s_pa, wp, topup_fn, opt);
    s_corr_pa = mdm_s_powder_average(s_corr, op_d, opt);
    
    %% T1 coregistration
    fprintf('\n T1 coregistration \n \n')
    
    % coreg t1
    i_t1_nii_fn = msf_find_fn(op_f,'T1_MPRAGE_pre.nii.gz');
    o_t1_nii_fn = fullfile(op_d, 'T1_MPRAGE.nii.gz');
    
    if (~opt.do_overwrite && exist(o_t1_nii_fn, 'file'))
        
        disp('T1 already registered');
        
    elseif (~isempty(i_t1_nii_fn))
        s_corr_pa = mdm_s_from_nii(msf_find_fn(op_d, 'FWF_topup_pa.nii.gz'));
        
        % Use the highest b-value for the registration
        s_tmp = mdm_s_subsample(s_corr_pa, 7 == (1:s_corr_pa.xps.n), wp, opt);
        
        % Do rigid body registration
        p_fn   = elastix_p_write(elastix_p_6dof(150), fullfile(wp, 'p_t1_fwf.txt'));
        res_fn = elastix_run_elastix(i_t1_nii_fn, s_tmp.nii_fn, p_fn, wp);
        
        % Save the result
        [I,h] = mdm_nii_read(res_fn);
        mdm_nii_write(I, o_t1_nii_fn, h);
    end
    
    % coreg FLAIR
    i_flair_nii_fn = msf_find_fn(op_f,'T1_MPRAGE_pre.nii.gz');
    o_flair_nii_fn = fullfile(op_d, 'FLAIR.nii.gz');
    
    if (~opt.do_overwrite && exist(o_flair_nii_fn, 'file'))
        
        disp('FLAIR already registered');
        
    elseif (~isempty(i_flair_nii_fn))
        
        s_corr_pa = mdm_s_from_nii(msf_find_fn(op_d, 'FWF_topup_pa.nii.gz'));
        
        % Use the highest b-value for the registration
        s_tmp = mdm_s_subsample(s_corr_pa, 7 == (1:s_corr_pa.xps.n), wp, opt);
        
        % Do rigid body registration
        p_fn   = elastix_p_write(elastix_p_6dof(150), fullfile(wp, 'p_flair_fwf.txt'));
        res_fn = elastix_run_elastix(i_flair_nii_fn, s_tmp.nii_fn, p_fn, wp);
        
        % Save the result
        [I,h] = mdm_nii_read(res_fn);
        mdm_nii_write(I, o_flair_nii_fn, h);
    end
    
end

%% Covariance analysis
fprintf('\n Covariance analysis \n \n')

s_struc = mdm_s_from_nii(fullfile(op_d, 'FWF_topup.nii.gz'));
s_struc.mask_fn = fullfile(op_d, 'mask.nii.gz');

warning off
dtd_covariance_pipe(s_struc, op_d, opt);
warning on

end
