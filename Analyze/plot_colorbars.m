
if (0)
    c_subject = [3]; %enhancing, non-enhancing
    
    warning off
    sss = readtable('figs_print.xlsx');
    warning on
    sss = table2cell(sss);
    sss(find([sss{:,1}] ~= c_subject(c_exp)),:) = [];
    
    ss{c_exp,1} = num2str(sss{2});
    ss{c_exp,2} = num2str(sss{3});
    ss{c_exp,3} = (sss{4});
    ss{c_exp,4} = [str2num(sss{5}) str2num(sss{6})];
    ss{c_exp,5} = [str2num(sss{7}) str2num(sss{8})];
    ss{c_exp,6} = [str2num(sss{9}) str2num(sss{10})];
    ss{c_exp,7} = [str2num(sss{11}) str2num(sss{12})];
    
    contrast_scale_list = ...
        {[(sss{14}) (sss{15})],... %pre
        [(sss{16}) (sss{17})],... %post
        [(sss{18}) (sss{19})],... %Flair
        [(sss{28}) (sss{29})],... %MD
        [(sss{24}) (sss{25})],... %S0
        [(sss{26}) (sss{27})],... %MKI
        [(sss{38}) (sss{39})],... %MKA
        [(sss{34}) (sss{35})]...  %lte 700
        [(sss{36}) (sss{37})]...  %ste 700
        [(sss{20}) (sss{21})],... %lte 2000
        [(sss{22}) (sss{23})],... %ste 2000
        };
    
else
    
    contrast_scale_list = ...
        {[0 65],... %STE 2000
        [0 95],... %STE 1400
        [0 160],... %STE 700
        [0 90],... %LTE 2000
        [0 140],... %LTE 1400
        [0 200],... %LTE 700
        [0 450],... %S0
        };
    
end


n = 1;
for c_c = 1:numel(contrast_scale_list)
    
    colorbar
    colormap('gray');
    
    c = colorbar;
    c.LineWidth = 1.5;
    c.Ticks = [0.0,0.95];
    c.TickLabels = {num2str(contrast_scale_list{c_c}(1)) num2str(contrast_scale_list{c_c}(2))};
    % c.TickLength = 0.4;
    c.FontSize = 40;
    c.FontWeight = 'bold';
    c.Color = 'white';
    
    set(gcf,'color','black');
    set(gca,'color','black');
    fig = gcf;
    fig.InvertHardcopy = 'off';
    
    print(sprintf('bar_%d_%d.png',n,c_c),'-dpng','-r300')
    
    
    drawnow;
end
n = n + 1;
