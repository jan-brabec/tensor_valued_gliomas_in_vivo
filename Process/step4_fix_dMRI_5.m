clear;

for c_exp = 1:2
    
    if c_exp == 1
        nii_fn =  '../data/processed/case5/Diff/ver3/Serie_01_FWF/dtd_covariance_MD.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);

    elseif c_exp == 2
        nii_fn =  '../data/processed/case5/Diff/ver3/Serie_01_FWF/dtd_covariance_s0.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);
    end
    
    s = 21;
    I(45,67,s) = I(45,68,s);
    I(46,60:62,s) = I(46,59,s);
    I(50,49:50,s) = I(50,48,s);
    I(43:44,53,s) = I(44,52,s);
    I(44,43,s) = I(45,43,s);
    I(45,39,s) = I(45,40,s);
    I(40,43,s) = I(40,42,s);
    I(41,45,s) = I(41,44,s);
    I(42,46,s) = I(42,45,s);
    I(60,30,s) = I(60,31,s);
    I(61,31,s) = I(61,32,s);
    I(63,30,s) = I(63,31,s);
    I(64,38,s) = I(64,39,s);
    I(52,41,s) = I(52,42,s);
    I(59,38,s) = I(59,37,s);
    I(61,41,s) = I(61,40,s);
    I(59,52,s) = I(59,53,s);
    I(40,32,s) = I(40,33,s);
    I(42,37,s) = I(42,38,s);
    I(44,60,s) = I(44,59,s);
    I(42,83,s) = I(42,84,s);
    
    I(73:74,40,s) = I(74,41,s);
    I(79,46,s) = I(79,45,s);
    I(72,42,s) = I(72,41,s);
    I(73,41,s) = I(73,42,s);
    
%         imagesc(I(:,:,s))
%     axis image off
%     1;
    
    
    
    s = 22;
    I(45:48,60,s) = I(46,59,s);
    I(45:47,61,s) = I(59,45,s);
    I(46,62,s) = I(46,58,s);
    I(42,67,s) = I(42,68,s);
    I(56,61,s) = I(56,60,s);
    I(58,63,s) = I(58,62,s);
    I(43,50,s) = I(43,51,s);
    I(44,37,s) = I(44,38,s);
    I(39,32,s) = I(39,33,s);
    I(27,40,s) = I(27,39,s);
    I(38,38,s) = I(38,37,s);
    I(21,45,s) = I(22,45,s);
    I(59,31,s) = I(60,31,s);
    I(62,36,s) = I(62,35,s);
    I(62,39,s) = I(62,38,s);
    I(60,48,s) = I(60,49,s);
    
        

    
    s = 23;
    
    I(41,33,s) = I(41,34,s);
    I(42,40,s) = I(42,41,s);
    I(44,39,s) = I(44,40,s);
    I(39,37,s) = I(39,38,s);
    I(38,35,s) = I(38,36,s);
    I(39,42,s) = I(39,41,s);
    I(42,49,s) = I(42,50,s);
    I(48,45,s) = I(48,44,s);
    I(44,50,s) = I(44,51,s);
    I(45,59,s) = I(45,58,s);
    I(45,61,s) = I(45,60,s);
    I(46,60,s) = I(46,61,s);
    I(47,58,s) = I(47,57,s);
    I(48,59,s) = I(48,58,s);
    I(59,39,s) = I(59,40,s);
    
    I(60,31,s) = I(60,32,s);
    I(64,36:37,s) = I(64,38,s);
    I(55:59,32,s) = I(59,33,s);
    I(57,35,s) = I(57,36,s);
    I(57,33,s) = I(57,34,s);
    
    I(60,42,s) = I(60,41,s);
    I(61,45,s) = I(61,46,s);
    I(53,56,s) = I(53,55,s);
    
    I(59,46,s) = I(59,47,s);
    I(60,49:50,s) = I(60,48,s);
    I(60,62,s) = I(60,63,s);
    I(58,64,s) = I(58,63,s);
    I(48,73,s) = I(48,74,s);
    
    I(28,40:41,s) = I(29,40,s);
    I(26,41,s) = I(26,40,s);
    I(27,39,s) = I(27,40,s);

    
    
    mdm_nii_write(I, nii_fn, h);
    
end

s = struct;
s.fullfile = '../data/processed/case5/Diff/ver3';
s.base_path = '../data/processed';
s.subject_name = 'case5';
s.exam_name = 'case5';
s.modality_name = 'Diff/ver3';
s.c_exam = 1;

addpath('../Process');
step4_coreg2_dmri_to_t1(s);
