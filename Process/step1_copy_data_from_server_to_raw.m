function a = step1_copy_data_from_server_to_raw(s)
% function a = step1_copy_data_from_server_to_raw(s)

a = [];
ap = '/Volumes/Glioma_study';
tp = '../data/raw/';

if (nargin == 0)
    mdm_iter_lund(ap, @step1_copy_data_from_server_to_raw);
    return;
end

if (~strcmp(s.modality_name, 'NII')), return; end

ip = fullfile(ap, s.subject_name, s.exam_name, s.modality_name);
op = fullfile(tp, s.subject_name, s.exam_name, s.modality_name);

msf_mkdir(op);

d = dir(fullfile(ip, '*.*'));

for c = 1:numel(d)
    
    x = [...
        any(strfind(d(c).name, 't2')) ...
        any(strfind(d(c).name, 'T2')) ...
        any(strfind(d(c).name, 't1')) ...
        any(strfind(d(c).name, 'T2')) ...
        any(strfind(d(c).name, 'FWF')) ...
        any(strfind(d(c).name, 'mprage')) ...
        any(strfind(d(c).name, 'rBV')) ...
        any(strfind(d(c).name, 'rBF')) ...
        any(strfind(d(c).name, 'ep2d_perf')) ...
        any(strfind(d(c).name, 'cest')) ...
        ];
    
    if (exist(fullfile(op, d(c).name), 'file')), continue; end
    
    if (~any(x))
        disp(d(c).name);
        1;
        continue;
    end
    
    copyfile( fullfile(ip, d(c).name), fullfile(op, d(c).name));
end


end