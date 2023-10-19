function[output,v_ll_ratio] = BP_changePoint_offset(xData, yData, offset, Length, sigma, confidenceLevel)	
% returns the change-po position if one is found.  Otherwise returns -1;

%DefStruct = struct('Minpoints',0);
%Args = parseArgs(varargin,DefStruct,[]);

%Here we store the llr curve for the movie
cur_Y_llr = zeros(1);
cur_X_llr = zeros(1);
		
%First we determine the fit for the null hypothesis...
null_line = BP_lingress_offset(yData, offset, Length);
null_ll = BP_log_likelihood_offset(yData, offset, Length, null_line(1), sigma);

%current max log-likelihood ratio value and position.
llr_max = 0;
llr_max_position = -1; 
v_ll_ratio = zeros(1,Length-3);
		
% Next we determine the fit for each pair of lines and store the log-likelihood
for w = 2:Length - 2
    %linear fit for first half
	segA_line = BP_lingress_offset(yData, offset, w);
	%linear fit for second half
	segB_line = BP_lingress_offset(yData, offset + w, Length - w);
			
	ll_ratio = BP_log_likelihood_offset(yData, offset, w, segA_line(1), sigma) +...
        BP_log_likelihood_offset(yData, offset + w, Length - w, segB_line(1), sigma) - null_ll;
    v_ll_ratio(w-1) = ll_ratio;
			
	cur_Y_llr = cur_Y_llr + ll_ratio;
	cur_X_llr = cur_X_llr + (xData(offset + w));
			
    if ll_ratio > llr_max 
        llr_max = ll_ratio;
        llr_max_position = offset + w;
    end
end

confidenceT = BP_confidenceTheshold(Length, 1 - confidenceLevel);

    if sqrt(2*llr_max) > confidenceT
        output =  llr_max_position;
    else
        output =  -1;
    end
		
end
             
