function[CP_positions,varargout] = BP_binary_search(xData, yData, varargin)
% Here we implement the recursive binary segmentation algorithm.

DefStruct = struct('offset', 1, 'sigma', 5e-11, 'confidencelevel', .999, 'movie', 0, 'minpoints',0);
Args = parseArgs(varargin,DefStruct,[]);
Nout = nargout;

cp_history = cell(1);
llr_history = cell(1);
Length = length(xData);
% We consider the start and end points of the trajectory as change points for convenience.
CP_positions = [Args.offset Length];
i = 1;
counter = 1;

while i  < length(CP_positions)
    k = i;
    [cp,llr] = BP_changePoint(xData, yData, CP_positions(i), CP_positions(i+1)-CP_positions(i), Args.sigma, Args.confidencelevel);
    if (cp ~= -1)
        CP_positions = [CP_positions(1:i) cp CP_positions(i+1:end)];
    else
        i = i+1;
    end
    
        
    if Args.movie && Nout > 1
        %We need to store the current version of CP_positions for the movie...
        cp_history{counter} = cp;
        llr_history{counter} = [CP_positions(k):(CP_positions(k)+length(llr)-1);llr];
        counter = counter + 1;
    end
            
    
end	
	
%Next we refine the positions of the change points based on the new bounds if at least one change point was found...

j = 1;
if length(CP_positions) > 2 
    while j < (length(CP_positions) - 1)
        k = j;
        [cp,llr] = BP_changePoint(xData, yData, CP_positions(j), CP_positions(j+2)-CP_positions(j), Args.sigma, Args.confidencelevel);
        CP_positions(j+1) = [];        
        if (cp ~= -1) && (CP_positions(j+1)-cp) > Args.minpoints && (cp-CP_positions(j)) > Args.minpoints
            CP_positions(j+1:end+1) = [cp CP_positions(j+1:end)];
            j = j+1;
        end         
                
        if Args.movie && Nout > 1
            %We need to store the current version of CP_positions for the movie... Here I think it changes every time.
            cp_history{counter} = cp;
            llr_history{counter} = [CP_positions(k):(CP_positions(k)+length(llr)-1);llr];
            counter = counter +1;
        end
                
    end

CP_positions([1 end]) = [];    
    
end

if Args.movie && Nout > 1
    varargout = {{cp_history},{llr_history}};
else
    varargout = {0,0};
end
        

