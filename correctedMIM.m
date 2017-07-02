function [selectedFeatures] = correctedMIM(X_ur_data,Y_labels, topK, under_reported_features, prior_knowledge)
% Summary 
%    Corrected-MIM algorithm for feature selection (Section 5.1)
% Inputs
%    X_ur_data: n x d matrix X, with binary values for n examples and d
%               features, some of which are under-reported
%    Y_labels: n x 1 vector with the labels
%    topK: Number of features to be selected
%    under_reported_features: Indeces of under-reported features
%    prior_knowledge: The prior belief over the prevelance (gamma = p(x=1))
%                     of each under-reported feature

if nargin<3
    error('Not enough input arguments');
else if nargin<5
        % Without any UR features it becomes not corrected MIM
        under_reported_features = [];
        prior_knowledge = [];
    end
end

if size(under_reported_features)~=size(prior_knowledge)
        error('The vector with the under-reported features and the one with the prior belief over their prevalence should have the same size');
end

numf = size(X_ur_data,2);
classMI = zeros(numf,1);

for n = 1 : numf
    if ismember(n,under_reported_features)
        gamma = prior_knowledge(find(under_reported_features==n)); %% the actual prior
        classMI(n)   = urMI1(Y_labels, X_ur_data(:,n), gamma);

    else
	  classMI(n) =mi(Y_labels,X_ur_data(:,n));
    end
end

[scoreVector index] = sort(classMI,'descend');

selectedFeatures = index(1:topK)';


