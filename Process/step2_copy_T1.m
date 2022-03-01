function a = step2_copy_T1(s)
% function a = copy_T1(s)

a = [];
rp = '../data/raw/';
tp = '../data/processed/';

if (nargin == 0)
    mdm_iter_lund(rp, @step2_copy_T1);
    return;
end

ip = fullfile(rp, s.subject_name, s.exam_name, 'NII');
op = fullfile(tp, s.subject_name, s.exam_name, 'T1/ver1');

msf_mkdir(op);

disp(s.subject_name)

%standard patterns
tmp = msf_find_fns(ip, '*mprage*', 0);

if (strcmp(s.subject_name(end-2:end), 'abc'))
    i_T1_post_fn = tmp{1};
    o_T1_post_fn = 'T1_MPRAGE_post.nii.gz';
    
    copyfile(i_T1_post_fn, fullfile(op,o_T1_post_fn));
    op2 = fullfile(tp, s.subject_name, s.exam_name, 'T1_coreg');
    copyfile(i_T1_post_fn, fullfile(op2,o_T1_post_fn));
        
elseif (strcmp(s.subject_name(end-2:end), 'abc'))
    i_T1_post_fn = tmp{1};
    o_T1_post_fn = 'T1_MPRAGE_pre.nii.gz';
    
    copyfile(i_T1_post_fn, fullfile(op,o_T1_post_fn));
    op2 = fullfile(tp, s.subject_name, s.exam_name, 'T1_coreg');
    copyfile(i_T1_post_fn, fullfile(op2,o_T1_post_fn));
    
elseif (strcmp(s.subject_name(end-2:end), 'abc')) && (strcmp(s.exam_name, 'xyz'))
    i_T1_post_fn = tmp{5};
    i_T1_pre_fn  = tmp{6};
    o_T1_post_fn = 'T1_MPRAGE_post.nii.gz';
    o_T1_pre_fn =  'T1_MPRAGE_pre.nii.gz';
    
    copyfile(i_T1_post_fn, fullfile(op,o_T1_post_fn));
    copyfile(i_T1_pre_fn, fullfile(op,o_T1_pre_fn));
    
    op2 = fullfile(tp, s.subject_name, s.exam_name, 'T1_coreg');
    copyfile(i_T1_post_fn, fullfile(op2,o_T1_post_fn));
    
elseif (strcmp(s.subject_name(end-2:end), 'abc')) && (strcmp(s.exam_name, 'xyz'))
    i_T1_post_fn = tmp{1};
    i_T1_pre_fn  = tmp{2};
    o_T1_post_fn = 'T1_MPRAGE_post.nii.gz';
    o_T1_pre_fn =  'T1_MPRAGE_pre.nii.gz';
    
    copyfile(i_T1_post_fn, fullfile(op,o_T1_post_fn));
    copyfile(i_T1_pre_fn, fullfile(op,o_T1_pre_fn));
    
    op2 = fullfile(tp, s.subject_name, s.exam_name, 'T1_coreg');
    copyfile(i_T1_post_fn, fullfile(op2,o_T1_post_fn));
    
else
    if (numel(tmp) ~= 2) && (~strcmp(s.subject_name(end-2:end), 'abc'))
        error('did not find pre+post T1s');
    end
    
    if (strcmpi(tmp{1}(numel(ip)+2), 'S'))
        i_T1_pre_fn  = tmp{1}; %pre
        i_T1_post_fn = tmp{2}; %post
    else
        i_T1_pre_fn  = tmp{2}; %pre
        i_T1_post_fn = tmp{1}; %post
        warning('first not a serie, changing order')
        
    end
    
    if (~strcmpi(tmp{2}(numel(ip)+2), 's'))
        warning('second not a serie, check naming')
    end
    
    disp('pre:')
    disp(i_T1_pre_fn(numel(ip)+2:end))
    disp('post:')
    disp(i_T1_post_fn(numel(ip)+2:end))
    
end

%unangulated
h_pre = mdm_nii_read_header(i_T1_pre_fn);
h_post  = mdm_nii_read_header(i_T1_post_fn);

if (abs(h_post.quatern_b) > 1e-5)
    disp('Post T1 is angulated!');
end

%for all the same
o_T1_post_fn = 'T1_MPRAGE_post.nii.gz';
o_T1_pre_fn =  'T1_MPRAGE_pre.nii.gz';

copyfile(i_T1_pre_fn,  fullfile(op,o_T1_pre_fn));
copyfile(i_T1_post_fn, fullfile(op,o_T1_post_fn));

end









