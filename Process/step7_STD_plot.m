function a = step7_STD_plot(s)
% function a dat = ROI_extract(s)

tp = '../data/processed';

if (nargin == 0)
    clc; mdm_iter_lund(tp, @step7_STD_plot); return;
end

a = [];

if (~strcmp(s.modality_name, 'Diff/ver2')), return; end

disp(s.subject_name)

op = fullfile(tp, s.subject_name, s.exam_name, 'Diff/ver2','Serie_01_FWF');

[I_FWF,h_FWF] = mdm_nii_read(fullfile(op,'FWF.nii.gz'));
xps           = mdm_xps_load(fullfile(op,'FWF_xps.mat'));

ste2000_ind = xps.b > 1.9e9 & xps.b_delta < 0.1 & xps.b_delta > -0.1;
I_ste2000_all = I_FWF(:,:,:,ste2000_ind);
I_ste2000_std = std(I_ste2000_all, [], 4);

mdm_nii_write(I_ste2000_std,fullfile(op,'STD_STE_2000.nii.gz'),h_FWF);

end


