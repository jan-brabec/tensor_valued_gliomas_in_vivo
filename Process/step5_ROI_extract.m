clear all; clc;

global iter_no dat
iter_no = 1;
dat = ROI_extract_fn();

i = size(dat,2); %delete those that dont have post-Gd or diff scan
while i > 0
    if dat(i).del == 1
        dat(i) = [];
    end
    i = i - 1;
end

i = size(dat,2); %keep just first timepoints, delete other timepoints
while i > 1
    if dat(i).pat == dat(i-1).pat
        dat(i) = [];
    end
    i = i - 1;
    disp(dat(i).s.subject_name)
    disp(dat(i).s.exam_name)
end

histo_info; %add histological info to the data structure
save(fullfile('../Data/data.mat'),'dat')