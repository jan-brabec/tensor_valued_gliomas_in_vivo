%fixes fitting error in BOF 105 that is visible on the final figure 1
clear

for c_exp = 1:2
    
    if c_exp == 1
        nii_fn =  '../data/processed/case3/Diff/ver3/Serie_01_FWF/dtd_covariance_MD.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);

    elseif c_exp == 2
        nii_fn =  '../data/processed/case3/Diff/ver3/Serie_01_FWF/dtd_covariance_s0.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);
    end
    
    s = 13;
    
    I(47,67,s) = I(47,66,s);
    I(56,67,s) = I(56,66,s);
    I(54,58,s) = I(54,57,s);
    
    s = 14;
    I(50,63,s) = I(50,62,s);
    I(54,63,s) = I(54,62,s);
    I(51,83,s) = I(51,82,s);
    I(47,66,s) = I(48,66,s);
    I(54,57,s) = I(54,58,s);
    
    s = 12;
    I(46,68,s) = I(50,61,s);
    I(47,67,s) = I(50,61,s);
    I(48,66,s) = I(50,61,s);
    I(49,65,s) = I(50,61,s);
    I(50,54,s) = I(50,61,s);
    I(57,69,s) = I(50,61,s);
    I(54,65,s) = I(50,61,s);
    I(53,58:60,s) = I(50,61,s);
    I(50,64,s) = I(50,63,s);
    I(51,44:45,s) = I(51,43,s);
    I(52,39,s) = I(53,39,s);
    I(51,40,s) = I(51,39,s);
    I(50,54,s) = I(50,55,s);
    
    mdm_nii_write(I, nii_fn, h);
    
end

s = struct;
s.fullfile = '../data/processed/case3/Diff/ver3';
s.base_path = '../data/processed';
s.subject_name = 'case3';
s.exam_name = 'case3';
s.modality_name = 'Diff/ver3';
s.c_exam = 1;

addpath('../Process');
step4_coreg2_dmri_to_t1(s);

