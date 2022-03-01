function plot_cases()

% c_subject = [123124,3,602]; %Figure 1; enhancing, non-enhancing
% c_subject = [509, 505]; %Figure 4: tu-hyperintensities vs WM
c_subject = [5, 2, 123123]; %Figure 5: interpretation figure

lte_col = [79 140 191]./255;
ste_col = [192 80 77]./255;

for c_exp = 1:numel(c_subject)
    warning off
    sss = readtable('figs_print.xlsx');
    warning on
    sss = table2cell(sss);
    sss(find([sss{:,1}] ~= c_subject(c_exp)),:) = [];
    
    ss{c_exp,1} = num2str(sss{2});
    ss{c_exp,2} = num2str(sss{3});
    ss{c_exp,3} = sss{4};
    ss{c_exp,4} = [str2num(sss{5}) str2num(sss{6})];
    ss{c_exp,5} = [str2num(sss{7}) str2num(sss{8})];
    ss{c_exp,6} = [str2num(sss{9}) str2num(sss{10})];
    ss{c_exp,7} = [str2num(sss{11}) str2num(sss{12})];
    
    contrast_scale_list{c_exp} = ...
        {[(sss{14}) (sss{15})],... %pre
        [(sss{16}) (sss{17})],... %post
        [(sss{18}) (sss{19})],... %Flair
        [(sss{24}) (sss{25})],... %S0
        [(sss{28}) (sss{29})],... %MD
        [(sss{20}) (sss{21})],... %lte 2000
        [(sss{20}) (sss{21})],... %ste 2000 of what it in there 
        [(sss{20}) (sss{21})],...
        [(sss{20}) (sss{21})]}; %%%%%LTE because it is normalized
    
    subject_name = strcat('Study_',ss{c_exp,1});
    disp(subject_name)
    
    data_dir{c_exp} =  fullfile('../../data/processed', subject_name, ss{c_exp,2}, 'T1_coreg');
    
    I_mask{c_exp} = mdm_nii_read(fullfile(data_dir{c_exp},'mask.nii.gz'));
    I_mask{c_exp} = I_mask{c_exp}(:,:,ss{c_exp,3});
    
end

contrast_name_list = {...
    'T1_MPRAGE_prec.nii.gz',...
    'T1_MPRAGE_postc.nii.gz',...
    'T2_FLAIRc.nii.gz',...
    'dtd_covariance_s0c.nii.gz'...
    'dtd_covariance_MD.nii.gz'...
    'LTE_b_2000c.nii.gz'...
    'STE_b_2000c.nii.gz'...
    'LTE_b_2000c.nii.gz',...
    'STE_b_2000c.nii.gz'};

c_contrast_select = [1 2 3 4 5 6 7 8 9];
n_contrast = numel(contrast_scale_list{1});

n_exam  = 1;
m_upper = 0;
m_lower = 0;
m_left  = 0;
m_right = 0;
cnw     = 0;
ph      = 1;
phm1    = 0;
phm2    = 0;
phm     = [phm2 phm1 phm1 0];
enh     = 0;
pw      = 1;
pwm     = [0 0 1];

% Axis setup
n_c = 8;
fh = m_upper + enh  + n_exam * 5 * ph  + sum(phm)  + m_lower;
fw = m_left  + cnw  + n_c * pw  + sum(pwm) + m_right;

m_upper = m_upper / fh;
m_left  = m_left / fw;
ph      = ph / fh;
enh     = enh / fw;
pw      = pw / fw;

figure(183)
clf
set(gcf,'color', 'w');

for c_con = 1:n_contrast
    for c_exp = 1:numel(c_subject)
        
        if strcmp(ss{c_exp,1},'abc') && c_con == 2
            I      = mdm_nii_read(fullfile(data_dir{c_exp}, 'T1_MPRAGE_prec.nii.gz'));
        else
            nii_fn = fullfile(data_dir{c_exp}, contrast_name_list{c_contrast_select(c_con)});
            
            if exist(nii_fn) == 0
                nii_fn = fullfile('../../data/processed','STE_b_2000c.nii');
            end
            I      = mdm_nii_read(nii_fn);
        end
        
        ax_l = m_left  + (c_con-1) * pw;
        
        d = 0.02;
        if c_exp == 1
            ax_b = 1 - m_upper - c_exp * ph;
        else
            ax_b = 1 - c_exp * (ph + d);
        end
        
        ax_w = pw;
        ax_h = ph;
        axes('position', [ax_l ax_b  ax_w ax_h]);
        
        tmp  = I(:,:,ss{c_exp,3});
        tmp1  = crop_image(tmp,    ss{c_exp,4}, ss{c_exp,5});
        mask  = crop_image(I_mask{c_exp}, ss{c_exp,4}, ss{c_exp,5});
        
        [tmp2,Im] = crop_image(tmp1, ss{c_exp,6}, ss{c_exp,7});
        
        if c_con == 6 %Compute LTE brightness
            lte_bright(c_exp) = mean(mean(tmp1(mask>0)));
        end
        
        if c_con == 7 %Adjust STE
            ste_bright(c_exp) = mean(mean(tmp1(mask>0)));
        end
        
        if c_con == 8 
            lte_bright(c_exp) = mean(mean(tmp2));
        end
         
        if c_con == 9 %adjust STE
            ste_bright(c_exp) = mean(mean(tmp2));
            tmp2 = tmp2 * lte_bright(c_exp)/ste_bright(c_exp);
            ste_bright2(c_exp) = mean(mean(tmp2));
        end        
        
        % Plot
        if c_con < 6
            msf_imagesc(double(tmp1) .* double(mask));
        elseif c_con == 6
            msf_imagesc(double(tmp1) .* double(mask));
            plot_roi(flipud(double(Im)'),lte_col,1.5);
        elseif c_con == 7
            msf_imagesc(double(tmp1) .* double(mask));
            plot_roi(flipud(double(Im)'),ste_col,1.5);
        elseif c_con > 7
            tmp2(1,:) = 0;
            tmp2(end,:) = 0;
            tmp2(:,1) = 0;
            tmp2(:,end) = 0;
            
            msf_imagesc(double(tmp2)); %,t,c,stroke))
            
            Im = ones(size(tmp2));
            Im(1,:) = 0;
            Im(end,:) = 0;
            Im(:,1) = 0;
            Im(:,end) = 0;
            
            if c_con == 8
                plot_roi(flipud(double(Im)'),lte_col, 2);
            elseif c_con == 9
                plot_roi(flipud(double(Im)'),ste_col,2);
            end
        end
        
        hold on;
        
        caxis(contrast_scale_list{c_exp}{c_contrast_select(c_con)});
        colormap gray
    end
end

set(gcf,'Color','k')
set(gcf, 'InvertHardcopy', 'off')

print(sprintf('Figure.png'),'-dpng','-r500')

end
