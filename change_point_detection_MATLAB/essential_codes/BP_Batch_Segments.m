function[Segment_cell,CP_cell,varargout] = BP_Batch_Segments(xData_cell,yData_cell,varargin)

DefStruct = struct('SavePathName', [],'offset', 1, 'sigma', 1e-10, 'confidencelevel', .999,...
    'SaveFileName', {[]},'k',[],'Inds',0,'Movie',0,'MinPoints',0,'Settings',1,'maxbreaks',5);
Args = parseArgs(varargin,DefStruct,[]);
Nout = nargout-2;
varargout = cell(1,3);

Ncurves = length(xData_cell);
Segment_cell = cell(1,Ncurves);
CP_cell = cell(1,Ncurves);
if Args.Movie
    CP_hist = cell(1,Ncurves);
    LLR_hist = cell(1,Ncurves);
end

Offset = Args.offset;
Sigma = Args.sigma;
Conflevel = Args.confidencelevel;
SavePathName = Args.SavePathName;
Minpoints = Args.MinPoints;
if isempty(Args.SaveFileName)
    SaveFileName = {[]};
else
    SaveFileName = Args.SaveFileName;
end
Movie = Args.Movie;

if size(gcp('nocreate'))==0
    parpool(2)
end

parfor i = 1:Ncurves

    if Movie
        [CP_positions,cphist,llrhist] = BP_binary_search(xData_cell{i}, yData_cell{i}, 'offset',...
        Offset, 'sigma', Sigma,'confidencelevel', Conflevel,'movie',Movie,'minpoints',Minpoints);
        CP_hist(i) = cphist;
        LLR_hist(i) = llrhist;
    else
        [CP_positions] = BP_binary_search(xData_cell{i}, yData_cell{i}, 'offset',...
        Offset, 'sigma', Sigma,'confidencelevel', Conflevel,'movie',0,'minpoints',Minpoints);
    end

    Segment_cell{i} = BP_Segments(xData_cell{i}, yData_cell{i}, CP_positions,...
        'SavePathName',SavePathName,'SaveFileName',SaveFileName{i});
    CP_cell{i} = CP_positions;
    
end

if isnumeric(Args.maxbreaks)
    while any(cellfun(@length,CP_cell)>Args.maxbreaks)
        Sigma = Sigma *2;
        curves = find(cellfun(@length,CP_cell)>Args.maxbreaks);
        
        for i = curves

            if Movie
                [CP_positions,cphist,llrhist] = BP_binary_search(xData_cell{i}, yData_cell{i}, 'offset',...
                Offset, 'sigma', Sigma,'confidencelevel', Conflevel,'movie',Movie,'minpoints',Minpoints);
                CP_hist(i) = cphist;
                LLR_hist(i) = llrhist;
            else
                [CP_positions] = BP_binary_search(xData_cell{i}, yData_cell{i}, 'offset',...
                Offset, 'sigma', Sigma,'confidencelevel', Conflevel,'movie',0,'minpoints',Minpoints);
            end

            Segment_cell{i} = BP_Segments(xData_cell{i}, yData_cell{i}, CP_positions,...
                'SavePathName',SavePathName,'SaveFileName',SaveFileName{i});
            CP_cell{i} = CP_positions;   
        end        
    end
end

if Args.Inds && Nout>0;
    SegmentsInds_cell = cell(1,Ncurves);
    if isempty(Args.k); Args.k = inputdlg({'you asked for indentations, what are the value for k used'},'Input required', 1,-1); end
    if Args.k ~= -1;
        for j = 1:Ncurves
            segmentsj = Segment_cell{j};
            cldefl = segmentsj(:,[2 4])/Args.k(j);           % For each Fmeas we can determine the cantileverdeflection
            segmentsj(:,[1 3]) = segmentsj(:,[1 3]) - cldefl;
            segmentsj(:,7) = (segmentsj(:,4)-segmentsj(:,2))./(segmentsj(:,3)-segmentsj(:,1));
            SegmentsInds_cell{j} = segmentsj;
        end
        varargout(1) = {SegmentsInds_cell};
    end
end

if Args.Settings && Nout>1
    varargout{2} = Args;
    movieout = [3 4];
else
    movieout = [2 3];
end

if Movie && Nout>1
    varargout(movieout) = [{CP_hist}, {LLR_hist}];
end;
