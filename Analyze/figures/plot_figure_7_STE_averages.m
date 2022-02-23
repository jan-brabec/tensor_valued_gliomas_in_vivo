function plot_figure_7_STE_averages()

if (nargin < 1), c_subject = 1; end

clc
warning off
sss = readtable('figs_print.xlsx');
warning on
sss = table2cell(sss);
sss(find([sss{:,1}] ~= c_subject),:) = [];

ss{1} = num2str(sss{2});
ss{2} = num2str(sss{3});
ss{3} = (sss{4});
ss{4} = [str2num(sss{5}) str2num(sss{6})];
ss{5} = [str2num(sss{7}) str2num(sss{8})];
ss{6} = [str2num(sss{9}) str2num(sss{10})];
ss{7} = [str2num(sss{11}) str2num(sss{12})];

contrast_scale_list = ...
    {[(sss{22}) (sss{23})],...
    [(sss{22}) (sss{23})],...
    [(sss{22}) (sss{23})],...
    [(sss{22}) (sss{23})]};

subject_name = strcat('BoF130_APTw_',ss{1});
disp(subject_name)

data_dir =  fullfile('../../data/processed', subject_name, ss{2}, 'T1_coreg');
data_ROI_dir =  fullfile('../../data/roi_Enhancements');

%ROIs
ROI_WM_fn  = fullfile(data_ROI_dir,strcat(ss{1},'_',ss{2},'_WM_contra.nii.gz'));
ROI_ste_fn = fullfile(data_ROI_dir,strcat(ss{1},'_',ss{2},'_STE_enh.nii.gz'));
I_roi_WMc = mdm_nii_read(ROI_WM_fn);
I_roi_ste = mdm_nii_read(ROI_ste_fn);
%

contrast_name_list = {...
    'STE_single_shotsc.nii.gz'...
    'STE_single_shotsc.nii.gz'...
    'STE_single_shotsc.nii.gz'...
    'STE_single_shotsc.nii.gz'};

I_mask = mdm_nii_read(fullfile(data_dir,'mask.nii.gz'));
I_mask = I_mask(:,:,ss{3});

c_contrast_select = [1 2 3 4];
n_contrast = numel(contrast_scale_list);

n_exam  = 1;

m_upper = 0.1;
m_lower = 0.1;
m_left  = 0.1;
m_right = 0.1;
cnw     = 0;
ph      = 1;
phm1    = 0.1;
phm2    = 0.25;
phm     = [phm2 phm1 phm1 0];
enh     = 0;
pw      = 1;
pwm     = [0 0 0];

% Axis setup
fh = m_upper + enh  + n_exam * ph  + sum(phm)  + m_lower;
fw = m_left  + cnw  + n_contrast * pw  + sum(pwm) + m_right;

m_upper = m_upper / fh;
m_left  = m_left / fw;
ph      = ph / fh;
enh     = enh / fw;
pw      = pw / fw;

figure(183)
clf
set(gcf,'color', 'w');

for c_con = 1:n_contrast
    
    nii_fn = fullfile(data_dir, contrast_name_list{c_contrast_select(c_con)});
    I      = mdm_nii_read(nii_fn);
    
    ax_l = m_left  + (c_con-1) * pw;
    ax_b = 1 - m_upper  - enh - 1 * ph;
    ax_w = pw;
    ax_h = ph;
    axes('position', [ax_l ax_b  ax_w ax_h]);
    
    tmp  = I(:,:,ss{3},:);
    tmp1  = crop_image(tmp,    ss{4}, ss{5});
    mask  = crop_image(I_mask, ss{4}, ss{5});
    
    % Plot
    if c_con == 1
        what = 1:1;
        msf_imagesc(mean(double(tmp1(:,:,what)),3) .* double(mask));
        
        % SIR of this tmp
        for i = 1:12
            image = mean(double(I(:,:,:,i)),4);
            ste2000(i) = mean(image(I_roi_ste > 0),'omitnan') / mean(image(I_roi_WMc > 0),'omitnan');
        end
        fprintf('1: Mean: %0.3g, STD: %0.2g \n',mean(ste2000),std(ste2000))
        clear ste2000
        
    elseif c_con == 2
        what = 1:3;
        msf_imagesc(mean(double(tmp1(:,:,what)),3) .* double(mask));
        
        %
        for i=1:4
            image = mean(double(I(:,:,:,i*3-2:i*3)),4);
            ste2000(i) = mean(image(I_roi_ste > 0),'omitnan') / mean(image(I_roi_WMc > 0),'omitnan');
        end
        fprintf('2: Mean: %0.3g, STD: %0.2g \n',mean(ste2000),std(ste2000))
        clear ste2000
        %
        
    elseif c_con == 3
        what = 1:6;
        msf_imagesc(mean(double(tmp1(:,:,what)),3) .* double(mask));
        
        %
        for i = 1:2
            image = mean(double(I(:,:,:,i*6-5:i*6)),4);
            ste2000(i) = mean(image(I_roi_ste > 0),'omitnan') / mean(image(I_roi_WMc > 0),'omitnan');
        end
        fprintf('3: Mean: %0.3g, STD: %0.2g \n',mean(ste2000),std(ste2000))
        clear ste2000
        %
        
    elseif c_con == 4
        what = 1:16;
        msf_imagesc(mean(double(tmp1(:,:,what)),3) .* double(mask));
        
        %
        i = 1;
        image = mean(double(I(:,:,:,1:16)),4);
        ste2000(i) = mean(image(I_roi_ste > 0),'omitnan') / mean(image(I_roi_WMc > 0),'omitnan');
        
        fprintf('4: Mean: %0.3g, STD: %0.2g \n',mean(ste2000),std(ste2000))
        clear ste2000
        %
    end
    
    hold on;
    caxis(contrast_scale_list{c_contrast_select(c_con)});
    colormap gray
end

set(gcf,'Color','k')
set(gcf, 'InvertHardcopy', 'off')
print(sprintf('STE_averages.png',c_subject),'-dpng','-r300')



end