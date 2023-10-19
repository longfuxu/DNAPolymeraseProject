function[output] = BP_Critical_Region(C,T,significancelevel)
    p = (C.^2);
    output = (p/2).*exp(-p/2).*(T - (2*T)./p + 4./p)-significancelevel;
end
