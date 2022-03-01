clear;

for c_exp = 1:2
    
    if c_exp == 1
        nii_fn =  '../data/processed/case2/Diff/ver3/Serie_01_FWF/dtd_covariance_MD.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);
        s = 24;
        w = max(max(I(:,:,s)));

    elseif c_exp == 2
        nii_fn =  '../data/processed/case2/Diff/ver3/Serie_01_FWF/dtd_covariance_s0.nii.gz';
        [I,h]  = mdm_nii_read(nii_fn);
        
    end
    
    
    s = 24;
    if c_exp == 1
        w = max(max(I(:,:,s)));
    elseif c_exp == 2
        w = max(max(I(:,:,s))) - 200;
    elseif c_exp == 3
        w = min(min(I(:,:,s)));
        I(52,61,s) = w;
    end
    
    I(52,60,s) = w;
    I(52,59,s) = w;
    I(52,60,s) = w;
    I(52,59,s) = w;
    
    xi = 56:62;
    wi = (I(51,xi,s)+I(53,xi,s))/2;
    I(52,xi,s) = wi; %%
    
    
    I(51:53,60,s) = I(51:53,59,s);
    I(50,47,s) = I(49,47,s);
    I(52,52,s) = I(51,52,s);
    I(49,70:72,s) = (I(49,73,s) + I(49,69,s))/2;
    I(31,49,s) = I(31,48,s);
    I(74,48,s) = I(74,47,s);
    I(75,48,s) = I(74,48,s);
    I(58,66,s) = I(59,66,s);
    I(66,58,s) = I(67,58,s);

    s = 25;
    if c_exp == 1
        w = max(max(I(:,:,s)));
    elseif c_exp == 2
        w = max(max(I(:,:,s))) - 250;
    elseif c_exp == 3
        w = min(min(I(:,:,s)));
        I(51:54,58:63,s) = w;
    end
    
    I(52,xi,s) = I(52,63,s); %%  
       
      
    
    I(53,62,s) = I(53,63,s);
    I(52,62,s) = I(52,63,s);
    I(51,60,s) = I(51,59,s);
    I(51,61,s) = I(52,61,s);
    
    xi = 57:62;
    wi = (I(54,xi,s)+I(52,xi,s))/2;
    I(53,xi,s) = wi; %%     
    
    I(49,48,s) = I(50,48,s);
    I(57,43,s) = I(57,42,s);
    I(59,40,s) = I(59,39,s);
    
    I(67,71,s) = I(72,67,s);
    

    
   
    
    s = 26;
    if c_exp == 1
        w = max(max(I(:,:,s)));
    elseif c_exp == 2
        w = max(max(I(:,:,s))) - 200;
    elseif c_exp == 3
        w = min(min(I(:,:,s)));
        I(51:54,58:63,s) = w;
    end
    I(52,60,s) = w;
    I(52,61,s) = w;
    I(53,61,s) = w;
    I(53,62,s) = w;
    I(52,62,s) = w;
    I(53,60,s) = w;
    
    s = 27;
    if c_exp == 1
        w = max(max(I(:,:,s)));
    elseif c_exp == 2
        w = max(max(I(:,:,s))) - 150;
    elseif c_exp == 3
        w = min(min(I(:,:,s)));
        I(51:54,58:63,s) = w;
    end

    
    I(53,60,s) = I(53,59,s);
    I(54,59,s) = I(54,58,s);
    I(54,61,s) = I(55,61,s);
    I(56,66,s) = I(56,66,s);
    I(55,67,s) = I(55,66,s);
    I(51,61,s) = I(51,60,s);
    I(52,62,s) = I(52,63,s);
    I(56,66,s) = I(56,65,s);
    I(54,47,s) = I(55,47,s);
    I(55,41,s) = I(56,41,s);
    I(43,46,s) = I(43,45,s);
    I(44,43,s) = I(44,44,s);
    I(41,31,s) = I(41,30,s);
    I(70,42,s) = I(70,41,s);
    
    I(52,60:61,s) = I(52,59,s);
    I(53,61:62,s) = I(53,60,s);
   
    
    
    
    imagesc(I(:,:,s)) 
    
    
    
    mdm_nii_write(I, nii_fn, h);
    
end

s = struct;
s.fullfile = '../data/processed/case2/Diff/ver3';
s.base_path = '../data/processed';
s.subject_name = 'case2';
s.exam_name = 'case2';
s.modality_name = 'Diff/ver3';
s.c_exam = 2;

addpath('../Process');
step4_coreg2_dmri_to_t1(s);
