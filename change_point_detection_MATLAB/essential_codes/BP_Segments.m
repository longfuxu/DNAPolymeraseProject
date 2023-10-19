function[Segments] = BP_Segments(xData, yData, CP_positions, varargin)

    DefStruct = struct('SavePathName', [], 'SaveFileName', 'Segments');
    Args = parseArgs(varargin,DefStruct,[]);
    
    CP_positions = [1 CP_positions length(xData)];
    NSegments = (length(CP_positions)-1);
    Segments = zeros(NSegments,8);

    for i = 1:(NSegments)
        
        range = [CP_positions(i), CP_positions(i+1)];
        Segments(i,[1 3]) = xData(range); 
        Segments(i,5:8) = BP_lingress(xData, yData, range(1), range(2)-range(1));
        Segments(i,[2 4]) = Segments(i,5)+Segments(i,7).*xData(range);
    
    end

    if ~isempty(Args.SavePathName)    
        if ~exist( Args.SavePathName,'dir' );    mkdir( Args.SavePathName );    end
        fid = fopen([Args.SavePathName Args.SaveFileName],'w');
        fprintf(fid,'%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\r\n','x1','y1','x2','y2','A','sigma_A','B','Sigma_B');
        PrintSegments = double([(1:size(Segments,1))', Segments]);
        fprintf(fid,'%i\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\r\n',PrintSegments');
        fclose(fid);
    end
    
end
    
    