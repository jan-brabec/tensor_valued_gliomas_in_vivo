function a = step5_coreg1_t1_post_to_pre(s)
% function a = coreg1_t1_post_to_pre(s)

a = [];
ap = '../data/processed';
tp = '../data/processed';
zp = '../data/interim';

if (nargin == 0)
    clc; mdm_iter_lund(ap, @step5_coreg1_t1_post_to_pre); return;
end

if (~strcmp(s.modality_name, 'T1/ver1')), return; end

disp(s.subject_name);

opt = mdm_opt;
opt.do_overwrite = 1;
opt.verbose      = 1;

% ip - input path, op - output path, wp - interim path
ip = fullfile(ap, s.subject_name, s.exam_name, s.modality_name);
op = fullfile(tp, s.subject_name, s.exam_name, 'T1_coreg');
wp = fullfile(zp, s.subject_name, s.exam_name, 'T1_coreg', 'tmp');
msf_mkdir(op); msf_mkdir(wp);

% identify pre and post contrast files
i_t1_post_nii_fn = msf_find_fn(ip, 'T1_MPRAGE_post.nii.gz', 0);
i_t1_pre_nii_fn  = msf_find_fn(ip, 'T1_MPRAGE_pre.nii.gz', 0);

% copy to pre contrast to output
o_t1_pre_nii_fn = fullfile(op, 'T1_MPRAGE_pre.nii.gz');

if (opt.do_overwrite || ~exist(o_t1_pre_nii_fn, 'file'))
    copyfile(i_t1_pre_nii_fn, o_t1_pre_nii_fn);
end

% register post to pre T1 with rigid body registration
o_t1_post_nii_fn = fullfile(op, 'T1_MPRAGE_post.nii.gz');

if (opt.do_overwrite || ~exist(o_t1_post_nii_fn, 'file'))
    p_fn = elastix_p_write(elastix_p_6dof(1500), fullfile(wp, 'p_t1_pre_post.txt'));
    res_fn = elastix_run_elastix(i_t1_post_nii_fn, o_t1_pre_nii_fn, p_fn, wp);
    
    % Save the result
    [I_post,h] = mdm_nii_read(res_fn);
    mdm_nii_write(I_post, o_t1_post_nii_fn, h);
end

% Check the result
if (1)
    I_pre = mdm_nii_read(o_t1_pre_nii_fn);
    I_post = mdm_nii_read(o_t1_post_nii_fn);
    
    figure(10);
    msf_imagesc(cat(1, I_pre, I_post));
end