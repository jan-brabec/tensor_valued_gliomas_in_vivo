clear;

for c_exp = 1:2
    
    if c_exp == 1
        nii_fn =  '../data/processed/case4/Diff/ver3/Serie_01_FWF/dtd_covariance_MD.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);

    elseif c_exp == 2
        nii_fn =  '../data/processed/case4/Diff/ver3/Serie_01_FWF/dtd_covariance_s0.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);
        
    end
    
    s = 11;
    I(47,64,s) = I(47,63,s);
    I(50,62,s) = I(50,61,s);
    I(57,58,s) = I(57,57,s);
    I(50,62,s) = I(50,61,s);
    I(58:59,65,s) = I(59,64,s);
    I(74,60,s) = I(73,60,s);
    
    
    s = 10;
    I(59,67,s) = I(59,66,s);
    I(60,40,s) = I(60,41,s);
    I(62,43,s) = I(62,42,s);
    
    s = 12;
    I(49,60,s) = I(59,49,s);
    I(51,59,s) = I(51,58,s);
    I(52,53,s) = I(52,54,s);
    I(53,48,s) = I(53,49,s);
    I(58,63,s) = I(58,62,s);
    I(60,62,s) = I(60,61,s);
    I(27,64,s) = I(27,63,s);
    
    imagesc(I(:,:,s))
    
    mdm_nii_write(I, nii_fn, h);
    
end

s = struct;
s.fullfile = '../data/processed/case4/Diff/ver3';
s.base_path = '../data/processed';
s.subject_name = 'case4';
s.exam_name = 'case4';
s.modality_name = 'Diff/ver3';
s.c_exam = 1;

addpath('../Process');
step4_coreg2_dmri_to_t1(s);
