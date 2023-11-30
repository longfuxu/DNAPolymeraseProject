% function[stepnm] = Julia_BP_find(sigma,varargin)
%This function finds breakpoint based on a linear segmentation method:
%first the curve is split up in segments (sigma controls the amount, a
%rough guideline for sigma = 3*noise flat part of the curve) and then the
%points were the curve falls are found
%Input:
% 'MaxSlope' (def .1) throw out segments with higher slope than this, 2x k_cantilever is a good starting point
% 'MinSegLength' (def 2) throw out segments shorter than this, 2nm is a good starting point
% 'MinMagnitude' (def .05) throw out drops smaller than this, set close to min. breaksize you want to detect

% DefStruct = struct('MaxSlope',30,'MinSegLength',2,'MinMagnitude',0.003);
% Args = parseArgs(varargin,DefStruct,[]);

clearvars
close all
PathName = 'C:\Users\Stefan\Desktop\test\'
FolderSave = 'C:\Users\Stefan\Desktop\test_Results\'
mkdir(FolderSave)
Results = [];
     
Ncurves = size(dir(PathName),1)
%%

listfile = dir(PathName);
% Start from 3 = 1 file
% for i_N = 3:Ncurves
    i_N = 1;
    close all
    data = [];  
    FileName = '20190925-019.xlsx';
    Data = xlsread([PathName, FileName]);

	figure(1)  
    hold off
    subplot(1,3,1)
    plot(Data(:,1),Data(:,3),'.k')
    
    VELOCITYpar = [];
    Time_s = [];
    for nbpts = 5 % Change this (Window moving)
        for it = 1+nbpts : size(Data(:,1),1)-nbpts
            p = polyfit(Data(it+[-nbpts:nbpts],2),Data(it+[-nbpts:nbpts],3),1);
            velocity_slope = p(1);
            Time_s = [Time_s;Data(it,2)];
            VELOCITYpar = [VELOCITYpar;velocity_slope];
        end
    end
    VELOCITYparall =[];  
    VELOCITYparall = [[1:nbpts-1]' VELOCITYpar(1)*ones(nbpts-1,1);Time_s VELOCITYpar; size(Data(:,1),1)+[-nbpts:0]' VELOCITYpar(end)*ones(nbpts+1,1)];
    
    % Segmentation
    
    Sigmahere = 0.05; % Change here Sigma / Noise
    [segments,CPs] = BP_Batch_Segments_for({Data(:,1)},{VELOCITYparall(:,2)},'sigma',Sigmahere,'linear',0);%%%%%%%%%
    Segments(i_N).RAW = ArraytoCSL(segments);
    Segmentsh = segments{1}(:,[1 3])'+1;

	figure(1)  
    hold off
    subplot(1,2,1)
    plot(Data(:,1),Data(:,3),'.k')
    ylabel('b.p.')
    xlabel('Time (s)')
    set(gca,'fontsize',14)
    hold on
    BPfittedall = [];
    ttbend =[];
    for iseg = 1:size(Segmentsh,2)
    plot([Segmentsh(1,iseg) Segmentsh(2,iseg)],[Data(Segmentsh(1,iseg),3) Data(Segmentsh(2,iseg),3)],'LineWidth',3)
    if iseg == size(Segmentsh,2)
        Time_fitted_seg = [Segmentsh(1,iseg):Segmentsh(2,iseg)];
        Tdata = [Segmentsh(1,iseg) Segmentsh(2,iseg)];
    else
        Time_fitted_seg = [Segmentsh(1,iseg):Segmentsh(2,iseg)-1];
        Tdata = [Segmentsh(1,iseg) Segmentsh(2,iseg)-1];
    end
    BPdata = [Data(Segmentsh(1,iseg),3) Data(Segmentsh(2,iseg),3)];
    BPfitted = interp1(Tdata,BPdata,Time_fitted_seg);
    BPfittedall = [BPfittedall;Time_fitted_seg' BPfitted'];
%     ttbend = [ttbend;Time_fitted_seg(1) Time_fitted_seg(end)];

    end
    pause(0.2)
    hold off
    subplot(1,2,2)
    hold off
    plot(Data(:,1),VELOCITYparall(:,2),'-.k')
    hold on
    plot(segments{1}(:,[1 3])',segments{1}(:,[2 4])','LineWidth',3)
    ylabel('derivative')
    xlabel('Time (s)')
    set(gca,'fontsize',14)
    saveas(1,[FolderSave,'Data_fitted_derivate_', FileName(1:end-5) ,'_nW_' num2str(nbpts,'%.0f'),'_Sigma_' num2str(Sigmahere,'%.0f'),'.png'])
    saveas(1,[FolderSave,'Data_fitted_derivate_', FileName(1:end-5) ,'_nW_' num2str(nbpts,'%.0f'),'_Sigma_' num2str(Sigmahere,'%.0f'),'.fig'])
    saveas(1,[FolderSave,'Data_fitted_derivate_', FileName(1:end-5) ,'_nW_' num2str(nbpts,'%.0f'),'_Sigma_' num2str(Sigmahere,'%.0f'),'.eps'])
    
    derivative = BPfittedall(:,2);
Time = VELOCITYparall(:,1);
slope = VELOCITYparall(:,2);
TC = table(Time,derivative,slope,'RowNames',{})
filesave = [FileName(1:end-4) ,'_nW_' num2str(nbpts,'%.0f'),'Step_Sigma =' num2str(Sigmahere,'%.2f'),'.txt']
writetable(TC,[FolderSave,filesave])

% end
%%




