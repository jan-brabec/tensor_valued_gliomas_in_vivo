function a = step6_coreg2_dmri_to_t1(s)
% function a = step4_coreg2_dmri_to_t1(s)

a = [];
ap = '../data/raw';
tp = '../data/processed';
zp = '../data/interim';

if (nargin == 0)
    clc; mdm_iter_lund(tp, @step6_coreg2_dmri_to_t1); return;
end

if (~strcmp(s.modality_name, 'Diff/ver3')), return; end

disp(s.subject_name);

opt = mdm_opt;
opt = mio_opt(opt);
opt.do_overwrite = 1;
opt.verbose      = 1;

% ip - input path, op - output path, wp - interim path
ip = fullfile(tp, s.subject_name, s.exam_name, s.modality_name, 'Serie_01_FWF');
op = fullfile(tp, s.subject_name, s.exam_name, 'T1_coreg');
wp = fullfile(zp, s.subject_name, s.exam_name, 'T1_coreg', 'tmp');
msf_mkdir(op); msf_mkdir(wp);

% identify pre contrast image and the powder averaged dMRI data
i_t1_nii_fn = msf_find_fn(op, 'T1_MPRAGE_pre.nii.gz', 0);
i_pa_nii_fn = msf_find_fn(ip, 'FWF_topup_pa.nii.gz', 0);

dmri_contrasts = {...
    'dtd_covariance_MD.nii.gz', ...
    'dtd_covariance_MKi.nii.gz', ...
    'dtd_covariance_MKa.nii.gz'...
    'dtd_covariance_s0.nii.gz'...
    'dtd_covariance_FA.nii.gz'...
    'dtd_covariance_FA_u_rgb.nii.gz'...
    'LTE_b_2000.nii.gz'...
    'STE_b_2000.nii.gz'...
    'LTE_b_700.nii.gz'...
    'STE_b_700.nii.gz'...
    'LTE_b_1400.nii.gz'...
    'STE_b_1400.nii.gz'...
    'STE_single_shots.nii.gz'... 
    'FWF_topup_pa.nii.gz'...
    'FWF_topup.nii.gz'};

for c = 1:numel(dmri_contrasts)
    i_dmri_nii_fns{c} = fullfile(ip, dmri_contrasts{c});
    o_dmri_nii_fns{c} = fullfile(op, dmri_contrasts{c});
end

if (opt.do_overwrite) || (~exist(i_dmri_nii_fns{end}, 'file'))
    
    % Find the transform using the last PA data
    [I_T1, h_T1] = mdm_nii_read(i_t1_nii_fn);
    [I_PA, h_PA] = mdm_nii_read(i_pa_nii_fn);
    
    %Fix one problem in a single case
    if strcmp(s.subject_name(end-2:end), 'abc') && strcmp(s.exam_name, 'xyz')
        I_PA(:,:,36:37,:) = [];
        I_PA(:,:,1,:) = [];
        I_PA(:,90:end,:,:) = 0;
    end
    
    %Separate STE_powder, LTE_powder into separate files
    mdm_nii_write(I_PA(:,:,:,3),fullfile(ip,'LTE_b_700.nii.gz'), h_PA);
    mdm_nii_write(I_PA(:,:,:,4),fullfile(ip,'STE_b_700.nii.gz'), h_PA);
    mdm_nii_write(I_PA(:,:,:,5),fullfile(ip,'LTE_b_1400.nii.gz'), h_PA);
    mdm_nii_write(I_PA(:,:,:,6),fullfile(ip,'STE_b_1400.nii.gz'), h_PA);
    mdm_nii_write(I_PA(:,:,:,7),fullfile(ip,'LTE_b_2000.nii.gz'), h_PA);
    mdm_nii_write(I_PA(:,:,:,8),fullfile(ip,'STE_b_2000.nii.gz'), h_PA);
    
    %Separate STE 1 shots @b = 2000
    i_fwf_nii_fn = msf_find_fn(ip, 'FWF_topup.nii.gz', 0);
    [I_FWF, h_FWF] = mdm_nii_read(i_fwf_nii_fn);
    load(fullfile(ip,'FWF_topup_xps.mat'),'xps');
    ind = find(xps.b>1.97e9 & xps.b_delta<0.1);
    I_single_shots(:,:,:,:)     = I_FWF(:,:,:,ind);
    mdm_nii_write(I_single_shots, fullfile(ip,'STE_single_shots.nii.gz'),  h_FWF);
    
    if  (~strcmp(s.subject_name(end-2:end), 'abc')) &&...
            (~strcmp(s.subject_name(end-2:end), 'abc')) &&...
            (~strcmp(s.subject_name(end-2:end), 'abc')) &&...
            (~strcmp(s.subject_name(end-2:end), 'abc')) &&...
            (~strcmp(s.subject_name(end-2:end), 'abc'))
        
        p = elastix_p_affine(500);
        
        if (strcmp(s.subject_name(end-2:end), 'abc')) && (strcmp(s.exam_name, 'xyz'))
            [I_reg, tp, ~, elastix_t] = mio_coreg(I_PA(:,:,2:end-2,end), I_T1, p, opt, h_PA, h_T1);
        end
        
        [I_reg, tp, ~, elastix_t] = mio_coreg(I_PA(:,:,:,end), I_T1, p, opt, h_PA, h_T1);
        
    else
        PA_high_b_fn = fullfile(wp,'PA_high_b.nii.gz');
        
        if strcmp(s.subject_name(end-2:end), 'abc')
            I_PA(:,:,34:37,end) = 3;
            I_PA(:,:,1    ,end) = 3;
            
            I_PA(90:100,1:100,1:37,end) = 3;
            I_PA(1:20,1:100,1:37,end) = 3;
            I_PA(1:100,1:10,1:37,end) = 3;
            I_PA(1:100,90:100,1:37,end) = 3;
        end
        
        mdm_nii_write(I_PA(:,:,:,end),PA_high_b_fn, h_PA);
        p_fn = elastix_p_write(elastix_p_6dof(1500), fullfile(wp, 'p_dmri2t1_pre.txt'));
        
        [res_fn,elastix_t_fn] = elastix_run_elastix(PA_high_b_fn, i_t1_nii_fn, p_fn, wp);
        elastix_t = elastix_p_read(elastix_t_fn);
    end
    
    % Apply the transform to all dMRI contrasts, take care of RGB separately
    for c = 1:numel(i_dmri_nii_fns)
        disp(dmri_contrasts{c})
        
        I = double(mdm_nii_read(i_dmri_nii_fns{c}));
        
        if strcmp(dmri_contrasts{c},'dtd_covariance_FA_u_rgb.nii.gz')
            I = permute(I, [2 3 4 1]);
        end
        
        T = mio_transform(I, elastix_t, h_PA, opt);
        
        if strcmp(dmri_contrasts{c},'dtd_covariance_FA_u_rgb.nii.gz')
            mdm_nii_write(T, o_dmri_nii_fns{c}, h_PA);
        else
            mdm_nii_write(T, o_dmri_nii_fns{c}, h_PA);
        end
        
    end
    
    return;
    
end

end