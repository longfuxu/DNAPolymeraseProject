% The following code blocks are intended for break-point detection in
% single-molecule study, based on a previous publication(Kerssemakers, J.,et al.Nature, 2006), 
% and is further customerized and developed by Noemie.B.Danne (n.b.danne@vu.nl) and Longfu Xu (l2.xu@vu.nl).

% The first step is to calculate the first derivative of single molecule
% trace after a moving-window filter to reduce the noise

% The second step is to fit the slope (first derivative)-time curve with a
% step-finding algorithm, and thus detect the change-point.

% The third step is to overlap the detected change-points with the
% single-molecule trace, followed by slope calculation

clearvars
close all
PathName = 'E:\OneDrive - Vrije Universiteit Amsterdam\DNAp_project_updated_jan2022\RawData_ProcessingData\20191017-006-1-exo+pol -good +5mM Mg2+\'
FolderSave = 'E:\OneDrive - Vrije Universiteit Amsterdam\DNAp_project_updated_jan2022\RawData_ProcessingData\20191017-006-1-exo+pol -good +5mM Mg2+\ChangePoints_Results\'
FileName = 'force data-cycle#01-processedData.xlsx'
mkdir(FolderSave)
Results = [];

% window-size defines the moving window size for denoising; sigma_noise
% defines the noise level of the first derivative curves. These two are the
% only two parameters can be tuned during the analysis.

window_size = 4 % smaller window_size will give more segments (default value = 6)
sigma_noise = 0.04 % smaller sigma_noise will give more segments (default value = 0.04)
%% this step is to read and visualize the raw data
Data = xlsread([PathName, FileName]);
% Data1 = readtable([PathName, FileName]);
% Data = table2array(Data1)
% figure(10)  
% hold off
% subplot(1,1,1)
% plot(Data(:,1),Data(:,5),'.k')

% this step is to calculate the first derivative of single molecule
% trace after a moving-window filter to reduce the noise
VELOCITYpar = [];
Time_s = [];
for nbpts = window_size
    for it = 1+nbpts : size(Data(:,1),1)-nbpts
        p = polyfit(Data(it+[-nbpts:nbpts],2),Data(it+[-nbpts:nbpts],5),1);
        velocity_slope = p(1);
        Time_s = [Time_s;Data(it,2)];
        VELOCITYpar = [VELOCITYpar;velocity_slope];
    end
end
VELOCITYparall =[];  
VELOCITYparall = [[1:nbpts-1]' VELOCITYpar(1)*ones(nbpts-1,1);Time_s VELOCITYpar; size(Data(:,1),1)+[-nbpts:0]' VELOCITYpar(end)*ones(nbpts+1,1)];

% this step is to detect the change-point and overlap the detected change-points with single-molecule trace; and plot and save all the data 
% Segmentation
Sigmahere = sigma_noise; % the Sigma of Noise
[segments,CPs] = BP_Batch_Segments_for({Data(:,1)},{VELOCITYparall(:,2)},'sigma',Sigmahere,'linear',0);%%%%%%%%%
Segments(1).RAW = ArraytoCSL(segments);
Segmentsh = segments{1}(:,[1 3])'+1;

figure(1)  
hold off
subplot(1,3,1)
plot(Data(:,1),Data(:,5),'.k')
ylabel('b.p.')
xlabel('Time Index')
set(gca,'fontsize',14)

subplot(1,3,2)
hold off
plot(Data(:,1),VELOCITYparall(:,2),'-.k')
hold on
plot(segments{1}(:,[1 3])',segments{1}(:,[2 4])','LineWidth',3)
ylabel('1st Derivative')
xlabel('Time Index')
set(gca,'fontsize',14)

subplot(1,3,3)
plot(Data(:,1),Data(:,5),'.k')
ylabel('b.p.')
xlabel('Time Index')
set(gca,'fontsize',14)
hold on
BPfittedall = [];
ttbend =[];
for iseg = 1:size(Segmentsh,2)
plot([Segmentsh(1,iseg) Segmentsh(2,iseg)],[Data(Segmentsh(1,iseg),5) Data(Segmentsh(2,iseg),5)],'LineWidth',3)
if iseg == size(Segmentsh,2)
    Time_fitted_seg = [Segmentsh(1,iseg):Segmentsh(2,iseg)];
    Tdata = [Segmentsh(1,iseg) Segmentsh(2,iseg)];
else
    Time_fitted_seg = [Segmentsh(1,iseg):Segmentsh(2,iseg)-1];
    Tdata = [Segmentsh(1,iseg) Segmentsh(2,iseg)-1];
end
% BPdata = [Data(Segmentsh(1,iseg),3) Data(Segmentsh(2,iseg),3)];
% BPfitted = interp1(Tdata,BPdata,Time_fitted_seg);
% BPfittedall = [BPfittedall;Time_fitted_seg' BPfitted'];

end
pause(0.2)
hold off

saveas(1,[FolderSave,'Data_fitted_derivate_', FileName(1:end-4) ,'_WinSize_' num2str(nbpts,'%.0f'),'_Sigma_' num2str(Sigmahere,'%.0f'),'.png'])
saveas(1,[FolderSave,'Data_fitted_derivate_', FileName(1:end-4) ,'_WinSize_' num2str(nbpts,'%.0f'),'_Sigma_' num2str(Sigmahere,'%.0f'),'.fig'])
saveas(1,[FolderSave,'Data_fitted_derivate_', FileName(1:end-4) ,'_WinSize_' num2str(nbpts,'%.0f'),'_Sigma_' num2str(Sigmahere,'%.0f'),'.eps'])

% derivative = BPfittedall(:,2);
% Time = VELOCITYparall(:,1);
% slope = VELOCITYparall(:,2);
% TC = table(Time,derivative,slope,'RowNames',{})
% filesave = [FileName(1:end-5) ,'_WindowSize_' num2str(nbpts,'%.0f'),'SigmaValue =' num2str(Sigmahere,'%.2f'),'.xlsx']
% writetable(TC,[FolderSave,filesave]);


cp_startIndex = segments{1}(:,1);
cp_endIndex = segments{1}(:,3);
TC = table(cp_startIndex,cp_endIndex,'RowNames',{});
filesave = [FileName(1:end-5),'-change_point_analyzed','.xlsx'];
writetable(TC,[FolderSave,filesave]);