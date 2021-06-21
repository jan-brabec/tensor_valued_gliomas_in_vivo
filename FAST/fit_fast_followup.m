
ss =  {'107', '20180420_1', '20180118_1', 2, 1;
    '108', '20180410_1', '20180125_1', 2, 1;
    '113', '20180817_1', '20180321_1', 2, 1;
    '121', '20181112_1', '20180903_1', 2, 1;
    '122', '20181206_1', '20180914_1', 2, 1;
    '131', '20190506_1', '20190125_1', 2, 1;
    '136', '20191011_1', '20190709_1', 2, 1;
    '140', '20191212_1', '20191022_1', 2, 1;
    '147', '20200130_1', '20191219_1', 2, 1;
    '117', '20180810_1', '20180608_1', 2, 1;
    '117', '20181025_1', '20180608_1', 3, 1;
    '117', '20190118_1', '20180608_1', 4, 1};

for k = 1:size(ss,1)
    s{k}.base_path = '../data/processed';
    s{k}.subject_name = strcat('Glioma_project_',ss{k,1});
    s{k}.exam_name = ss{k,2};
    s{k}.exam_name_first = ss{k,3};
    s{k}.modality_name = 'T1_coreg2first';
    s{k}.c_exam = 1;
    s{k}.fullfile = fullfile(s{k}.base_path,s{k}.subject_name,s{k}.exam_name,s{k}.modality_name);
end

for c_exp = 1:size(s,2)
    
    fit_fast(s{c_exp},ss{c_exp,5})
    fit_fast(s{c_exp},ss{c_exp,4})
   
end