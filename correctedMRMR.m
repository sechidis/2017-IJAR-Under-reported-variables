function [selected_features] = correctedMRMR(X_ur_data,Y_labels, topK, under_reported_features, prior_knowledge)
% Summary 
%    Corrected-mRMR algorithm for feature selection (Section 5.2)
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

numf = size(X_ur_data,2);
MIxy = zeros(numf,1);
MIx1x2 = zeros(numf,numf);

%%%% Calculate the Relevancy terms - Vector
for n = 1 : numf
    if ismember(n,under_reported_features)
        gamma = prior_knowledge(find(under_reported_features==n)); %% the actual prior
        MIxy(n)  = urMI1(Y_labels, X_ur_data(:,n), gamma);       
    else
	  MIxy(n)  = mi(Y_labels,X_ur_data(:,n));
    end
end

%%%%%%%%% The mRMR Algorithm
[score selected_features] =  max(MIxy);
not_selected_features = setdiff(1 : numf,selected_features);

while length(selected_features)<topK
    num_sel = length(selected_features);
    for not_selected_index = 1:length(not_selected_features)
        
        score_ns( not_selected_index)=MIxy(not_selected_features(not_selected_index));
        for selected_index = 1:length(selected_features)
            %%% Estimate the relevancy mutual information 
                        x1 = not_selected_features(not_selected_index);
            x2 = selected_features(selected_index);
            if ismember(x1,under_reported_features)
            gamma1 = prior_knowledge(find(under_reported_features==x1)); %% the actual prior
            
            if ismember(x2,under_reported_features)
                gamma2 = prior_knowledge(find(under_reported_features==x2)); %% the actual prior
                MIx1x2  = urMI2( X_ur_data(:,x2), X_ur_data(:,x1), gamma2,gamma1);
            else
                MIx1x2  = urMI1( X_ur_data(:,x2), X_ur_data(:,x1), gamma1);
                %      classMI(n) =puConditionalMI_ci(labels, data(:,n), data(:,1),data(:,n),gamma,0.80);
            end
        else
            if ismember(x2,under_reported_features)
                gamma2 = prior_knowledge(find(under_reported_features==x2)); %% the actual prior
                MIx1x2  = urMI1( X_ur_data(:,x1), X_ur_data(:,x2), gamma2);
            else
                
                MIx1x2= mi(X_ur_data(:,x2),X_ur_data(:,x1));
            end
                    
        end

        %%% Update the score
           score_ns( not_selected_index) = score_ns( not_selected_index) -  MIx1x2/num_sel;
        end
    end
    [score selected_featuresNew_index] =  max(score_ns);
   selected_features = [selected_features not_selected_features(selected_featuresNew_index)];
   not_selected_features = setdiff(1 : numf,selected_features);
   clear score_ns;
end

selected_features = selected_features;


