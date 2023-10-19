function varargout=ArraytoCSL(C)

    if isnumeric(C) || isstruct(C), C=num2cell(C); end
    C=C(:).';

    varargout=C(1:nargout);