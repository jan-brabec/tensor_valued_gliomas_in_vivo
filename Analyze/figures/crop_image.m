function [I,Im] = crop_image(I, xy_start, s_window)
% function [I,Im] = crop_image(I, xy_start, s_window)
%
% Written by Bjorn Lampinen


if size(I,1) ~= 3
    [n_row, n_col, ~] = size(I);
    
    plot_part_col = [xy_start(1) xy_start(1) + s_window(1)];
    plot_part_row = [xy_start(2) xy_start(2) + s_window(2)];
    
    rowrange = max(1, floor(plot_part_row(1) * n_row)):...
        min(n_row, floor(plot_part_row(2) * n_row));
    colrange = max(1, floor(plot_part_col(1) * n_col)):...
        min(n_col, floor(plot_part_col(2) * n_col));
    
    Im = zeros(size(I));
    Im(colrange, rowrange,:) = 1;
    
    I = I(colrange, rowrange,:);
    
elseif size(I,1) == 3
    [I1,Im1] = crop_image(squeeze(I(1,:,:)), xy_start, s_window);
    [I2,Im2] = crop_image(squeeze(I(2,:,:)), xy_start, s_window);
    [I3,Im3] = crop_image(squeeze(I(3,:,:)), xy_start, s_window);
    
    I = [];
    I(1,:,:) = I1;
    I(2,:,:) = I2;
    I(3,:,:) = I3;
    
    Im = [];
    Im(1,:,:) = Im1;
    Im(2,:,:) = Im2;
    Im(3,:,:) = Im3; 
    
end
end
