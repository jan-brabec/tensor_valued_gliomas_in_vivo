clear;

for c_exp = 1:2
    
    if c_exp == 1
        nii_fn =  '../data/processed/case6/Diff/ver3/Serie_01_FWF/dtd_covariance_MD.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);

    elseif c_exp == 2
        nii_fn =  '../data/processed/case6/Diff/ver3/Serie_01_FWF/dtd_covariance_s0.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);
        
    end
    
    s = 18;
    I(43,52,s) = I(43,51,s);
    I(56,54,s) = I(56,53,s);
    
    
    s = 19;
    I(43,47,s) = I(43,46,s);
    I(44,44,s) = I(44,43,s);
    I(58,51,s) = I(58,50,s);
    
    s = 17;    
    I(48,42,s) = I(47,42,s);
    I(47,45,s) = I(47,44,s);
    I(55,55,s) = I(55,54,s);
    I(59,54:55,s) = I(59,53,s);
    I(42,48,s) = I(42,47,s);
    
    imagesc(I(:,:,s))
    
    mdm_nii_write(I, nii_fn, h);
    
end

s = struct;
s.fullfile = '../data/processed/case6/Diff/ver3';
s.base_path = '../data/processed';
s.subject_name = 'case6';
s.exam_name = 'case6';
s.modality_name = 'Diff/ver3';
s.c_exam = 1;

addpath('../Process');
step4_coreg2_dmri_to_t1(s);
