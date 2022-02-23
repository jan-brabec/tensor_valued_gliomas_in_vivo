function EG = mgui_def_loop_BOF130_enhancements(do_open_mgui)
% function EG = mgui_def_loop_BOF130_enhancements(do_open_mgui)

% run ../../../MATLAB/mdm_gui/setup_paths

if (nargin == 0), do_open_mgui = 1; end
if (do_open_mgui), mgui_close; end

cp = fileparts(mfilename('fullpath'));
addpath(fullfile(cp,'Process'))
addpath(genpath(fullfile(cp,'data')))
bp = fullfile(cp,'/data/processed');

o = mdm_iter_lund(bp, @ret_s);

c = 1; %identify those where LTE exist and only first timepoint
for k = 1:numel(o)
    for i = 1:size(o{k},1) %to 1 if just first timepoint, if all timepoints then size(o{k},1)
        s_tmp = o{k}{i,8}; %was there 8
        
        lp = fullfile(s_tmp.subject_name,s_tmp.exam_name,'T1_coreg');
        lte_fn = fullfile(bp, lp, 'LTE_b_2000c.nii.gz');

        if exist(lte_fn,'file')
            s{c} = s_tmp;
            c = c + 1;
        end
    end
end

c = 1; % show only those where LTE exist
for k = 1:numel(s)
    
    lp = fullfile(s{k}.subject_name,s{k}.exam_name,'T1_coreg');
    
    EG.data.ref(c).subject_name = strcat(s{k}.subject_name(end-2:end),'_',s{k}.exam_name);
    
    if (0)
        t1_mprage = fullfile(bp, lp, 'T1_MPRAGE_postc.nii.gz');
        mki_fn = fullfile(bp, lp, 'dtd_covariance_s0.nii.gz');
        lte_fn = fullfile(bp, lp, 'LTE_b_2000c.nii.gz');
        ste_fn = fullfile(bp, lp, 'STE_b_2000c.nii.gz');
        
    else
        t1_mprage = fullfile(bp, lp, 'T1_MPRAGE_postc.nii.gz');
        mki_fn = fullfile(bp, lp, 'STE_b_700c.nii.gz');
        lte_fn = fullfile(bp, lp, 'LTE_b_2000c.nii.gz');
        ste_fn = fullfile(bp, lp, 'STE_b_2000c.nii.gz');
    end
    
    if (1)
        lp_raw = fullfile(s{k}.subject_name,s{k}.exam_name,'Diff','ver3','Serie_01_FWF'); 
        t1_mprage = fullfile(bp, lp_raw, 'T1_MPRAGE.nii.gz');
        mki_fn = fullfile(bp, lp_raw, 'dtd_covariance_s0.nii.gz');
        lte_fn = fullfile(bp, lp_raw, 'STE_b_2000.nii.gz');
        
        lp_raw_STD = fullfile(s{k}.subject_name,s{k}.exam_name,'Diff','ver2','Serie_01_FWF');
        ste_fn = fullfile(bp, lp_raw_STD, 'STD_STE_2000.nii.gz');    
    end
    
    if ~exist(t1_mprage,'file')
        t1_mprage = fullfile(bp, lp, 'T1_MPRAGE_prec.nii.gz');
        if ~exist(t1_mprage,'file')
            t1_mprage = fullfile(bp, 'blank.nii');
        end
    end
    
    if ~exist(mki_fn,'file')
        mki_fn = fullfile(bp, 'blank.nii');
    end
    if ~exist(lte_fn,'file')
        lte_fn = fullfile(bp, 'blank.nii');
    end
    if ~exist(ste_fn,'file')
        ste_fn = fullfile(bp, 'blank.nii');
    end
    
    EG.data.ref(c).fn = {...
        t1_mprage, ...
        mki_fn, ...
        lte_fn, ...
        ste_fn};
    
    EG.data.ref(c).name = EG.data.ref(c).subject_name;
    c = c + 1;
end

EG.data.roi_list = {'Whole tumor - postGD','Whole tumor - preGD','Post-Gd enh','MKI enh','LTE enh','STE enh','WM contra','STD2SNR'};

% Make roi filename
    function roi_fn = make_roi_fn(c_file, c_roi)
        
        roi_path = fullfile(...
            fileparts(mfilename('fullpath')), ...
            '/data/roi_Enhancements');
        
        if strcmp(EG.data.roi_list{c_roi},'Whole tumor - postGD')
            roi_name = 'TF1';
        elseif strcmp(EG.data.roi_list{c_roi},'Whole tumor - preGD')
            roi_name = 'preGD_whole';
        elseif strcmp(EG.data.roi_list{c_roi},'Post-Gd enh')
            roi_name = 'Gd_enh';
        elseif strcmp(EG.data.roi_list{c_roi},'MKI enh')
            roi_name = 'MKI_enh';
        elseif strcmp(EG.data.roi_list{c_roi},'LTE enh')
            roi_name = 'LTE_enh';
        elseif strcmp(EG.data.roi_list{c_roi},'STE enh')
            roi_name = 'STE_enh';
        elseif strcmp(EG.data.roi_list{c_roi},'WM contra')
            roi_name = 'WM_contra';
        elseif strcmp(EG.data.roi_list{c_roi},'STD2SNR')
            roi_name = 'STD2SNR_b2000';            
        end
        
        %         roi_name = lower(strrep(EG.data.roi_list{c_roi}, ' ', '_'));
        
        ext = '.nii.gz';
        
        roi_fn = fullfile(roi_path, [EG.data.ref(c_file).subject_name '_' roi_name ext]);
        
        disp(roi_fn);
    end

% Link the roi filename function to the GUI
EG.data.nii_fn_to_roi_fn = @(nii_fn, c_roi) make_roi_fn(nii_fn, c_roi);

% Use the multipane view
if (do_open_mgui)
    mgui(EG, 4);
end

end

