clear;

for c_exp = 1:2
    
    if c_exp == 1
        nii_fn =  '../data/processed/case7/Diff/ver3/Serie_01_FWF/dtd_covariance_MD.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);
        s = 24;
        w = max(max(I(:,:,s)));

    elseif c_exp == 2
        nii_fn =  '../data/processed/case7/Diff/ver3/Serie_01_FWF/dtd_covariance_s0.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);
        
    end
    
    s = 20;
    I(61,36,s) = I(62,36,s);
    
imagesc(I(:,:,s)) 

    
    s = 21;
    
    I(46,50,s) = I(46,49,s);
    I(56,61,s) = I(56,60,s);
    I(42,39,s) = I(42,38,s);

    s = 22;
    
    I(41,36,s) = I(42,36,s);
    I(41,37,s) = I(42,37,s);
    I(42,39,s) = I(43,39,s);
    I(46,41,s) = I(45,41,s);
    I(45,43,s) = I(45,42,s);
    I(51:52,50,s) = I(53,51,s);
    I(56,60,s) = I(56,59,s);
    I(58,40:41,s) = I(57,40,s);
    I(52,51,s) = I(53,52,s);
    
    s = 23;
    
    I(49,50,s) = I(49,49,s);
    I(45,45,s) = I(46,45,s);
    I(56,42,s) = I(56,41,s);
    I(60,36:37,s) = I(60,35,s);
    I(61,37,s) = I(61,36,s);
    I(50,64,s) = I(50,65,s);
    I(55,45,s) = I(55,46,s);
    
    
    s = 19;
    I(53,56:57,s) = I(53,55,s);
    I(53,59,s) = I(53,58,s);
    I(54,61,s) = I(55,61,s);
    I(56,63,s) = I(56,62,s);
    I(55,57,s) = I(55,56,s);
    I(59,37,s) = I(60,37,s);
    I(62,36,s) = I(62,35,s);
    I(51,43,s) = I(51,42,s);
   
    s = 20;
    I(48,59,s) = I(49,54,s);
    I(49,55,s) = I(49,54,s);
    I(50,56,s) = I(49,54,s);
    I(52,57,s) = I(52,58,s);
    I(55,61,s) = I(52,58,s);
    I(52,58,s) = I(61,66,s);
    I(52,59,s) = I(52,57,s);
    I(52,58,s) = I(52,57,s);
    
    s = 18;
    I(60,36,s) = I(60,35,s);
        
    s = 17;
    
%     imagesc(I(:,:,s))
%     axis image off
%     1;
    
    
    
    mdm_nii_write(I, nii_fn, h);
    
end

s = struct;
s.fullfile = '../data/processed/case7/Diff/ver3';
s.base_path = '../data/processed';
s.subject_name = 'case7';
s.exam_name = 'case7';
s.modality_name = 'Diff/ver3';
s.c_exam = 2;

addpath('../Process');
step4_coreg2_dmri_to_t1(s);
