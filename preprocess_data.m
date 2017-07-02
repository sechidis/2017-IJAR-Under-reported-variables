function [data] = preprocess_data( originaldata )
%%% Each nominal attribute is expaned into several binary attributes.
% Summary: 
%    This function uses 1-vs-all strategy to expand each nominal feature 
%    into several binary attributes
% Inputs:
%    originaldata: n x d matrix X, with categorical values for n examples and d features



count = 1;

for fnum = 1:size(originaldata,2)
    
    feat = originaldata(:,fnum);
    [unique_elem d1 d2] = unique(feat);
    if length(unique_elem)<3
        data(:,count) = feat;
        count = count+1;
    else
    for index = 1:length(unique_elem)
        data(:,count) = double(feat==unique_elem(index));
        count = count+1;
    end
    end
    
end
