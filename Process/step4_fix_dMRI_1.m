%fixes fitting error in BOF 105 that is visible on the final figure 1
clear

for c_exp = 1:2
    
    if c_exp == 1
        nii_fn =  '../data/processed/case1/Diff/ver3/Serie_01_FWF/dtd_covariance_MD.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);

    elseif c_exp == 2
        nii_fn =  '../data/processed/case1/Diff/ver3/Serie_01_FWF/dtd_covariance_s0.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);
    end
    
    s = 27;
    I(49,59,s) = I(48,58,s);
    I(45,64,s) = I(45,63,s);
    I(46,58,s) = I(46,59,s);
    I(51,72:73,s) = I(51,74,s);
    
    s = 28;
    I(52:53,59,s) = I(53,60,s);
    I(57,64,s) = I(57,63,s);
    I(61,39,s) = I(61,40,s);
    I(50,72,s) = I(50,73,s);
    
    imagesc(I(:,:,s))
    
    mdm_nii_write(I, nii_fn, h);
    
end

s = struct;
s.fullfile = '../data/processed/case1/Diff/ver3';
s.base_path = '../data/processed';
s.subject_name = 'case1';
s.exam_name = 'case1';
s.modality_name = 'Diff/ver3';
s.c_exam = 1;

addpath('../Process');
step4_coreg2_dmri_to_t1(s);
