function[output] = BP_log_likelihood(xData, yData, offset, Length, A, B, sigma)
% B is the slope and A is the intercept of the line.
		 
lineSum = sum((yData(offset:offset+Length-1)-B*xData(offset:offset+Length-1)-A).^2);

%I guess these pi terms cancel below so I could remove them but I will leave it for now...
output =  Length*log(1/sigma*sqrt(2*pi))-lineSum/(2*sigma.^2);

end