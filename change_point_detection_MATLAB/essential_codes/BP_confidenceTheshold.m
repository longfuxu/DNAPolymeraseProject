function[C] = BP_confidenceTheshold(N,significancelevel)
		
h = log(N)^(3/2)/N;
T = log((1-h^2)/(h^2));

%C = lsqnonlin(@(x) BP_Critical_Region(x,T,OneMa),3,0,4,'Algorithm',{'Levenberg-marquardt',.001});
C = fzero(@(x) BP_Critical_Region(x,T,significancelevel),[3 5]);

%BP_Critical_Region(p,T);

%function[output] = BP_getValue(p) 				
%    delta = 1e-6;%
				
%    for i = 0 : length(p)
%        p(i) = p(i) + delta;
%        dyda(i) = BP_Critical_Region(p,T);
%        p(i) = p(i) - 2 * delta;
%        dyda(i) = dyda(i) - BP_Critical_Region(p,T);
%        p(i) = p(i) + delta;
%        dyda(i) = dyda(i)/ (2 * delta);
%    end

%	output(get(p))
%end
		


end