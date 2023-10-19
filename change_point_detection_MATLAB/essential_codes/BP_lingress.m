function[parms] = BP_lingress(xData, yData, offset, Length)
% Equations and notation taken directly from "An Introduction to Error Analysis" by Taylor 2nd edition
% y = A + Bx
% A = output[0] +/- output[1]
% B = output[2] +/- output[3]
% error is the STD here.
	
parms = zeros(1,4);

%First we determine delta (Taylor's notation)

range = offset:(offset + Length - 1);
xdat = xData(range);
ydat = yData(range);

%p = polyfit(xdat,ydat,1);
%yfit = polyval(p,xdat);

%SSQ = sum((ydat-yfit).^2);
%sigmaY = sqrt(SSQ/(Length-2));
XsumSquares = sum(xdat.^2);
Xsum = sum(xdat);
Ysum = sum(ydat);
XYsum = sum(xdat.*ydat);

Delta = Length*XsumSquares-Xsum.^2;
A = (XsumSquares*Ysum-Xsum*XYsum)/Delta;
B = (Length*XYsum-Xsum*Ysum)/Delta;
		
ymAmBxSquare = sum((yData(range)-A-B.*xData(range)).^2);

sigmaY = sqrt(ymAmBxSquare/(Length-2));
		
parms(1) = A;
parms(2) = sigmaY*sqrt(XsumSquares/Delta);
parms(3) = B;
parms(4) = sigmaY*sqrt(Length/Delta);

%parms([1 3]) = mdl.Coefficients.Estimate;
%parms([2 4]) = mdl.Coefficients.SE;
%log_likelihood = bla.LogLikelihood;

end
