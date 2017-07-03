% Load one of the provided dataset, e.g.
load('./Datasets/krvskp.mat')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Pre-process the data %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transform multi-class problems to binary in 1-vs-all strategy
X_data = preprocess_data(X_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generate under-reported datasets %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We will under-report all the features with sensitivities
% chosen randomly in the range [0.25–0.75].
SensMin = 0.25; SensMax = 0.75;
under_reported_features = 1:size(X_data,2);
% Under-report the features in X_data
X_ur_data = X_data;
for index_of_UR_features = 1:length(under_reported_features)
    x = X_data(:,under_reported_features(index_of_UR_features));
    xpos_indices = find(x==1);%Find the examples with x=1
    
    positiveSet = binornd(1,SensMin + (SensMax-SensMin)*rand(1,1),1,length(xpos_indices))';% Find which examples will be under-reported
    while sum(positiveSet~=0) == 0 && pSP1givenY1>0
        positiveSet = binornd(1,SensMin + (SensMax-SensMin)*rand(1,1),1,length(xpos_indices))';
    end; % Check if you have empty labelled set
    X_ur_data(:,under_reported_features(index_of_UR_features)) = 2;
    X_ur_data(xpos_indices(find(positiveSet==1)),under_reported_features(index_of_UR_features)) = 1;  %update  
end

% Estimate also the actual prevelance of the under-reported features
for index = 1:length(under_reported_features)
    prior_knowledge_all(index) = mean(X_data(:,under_reported_features(index))==1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Select the features using our suggested algorithms %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now we will select the top-5 features with our Corrected-mRMR and we will 
% compare this subset with the subsets without performing any correction
% and with the ideal, which is the one if we had used mRMR  the unobservable 
% correctly reported data.
topK=5;
Selected_with_correctedMRMR = correctedMRMR(X_ur_data, Y_labels, topK, under_reported_features, prior_knowledge_all);
disp('Selected features using our Corrected-mRMR:')
disp(Selected_with_correctedMRMR)
Selected_with_no_correction_mRMR = correctedMRMR(X_ur_data, Y_labels, topK);
disp('Selected features using mRMR with the under-reported features (no correction) features:')
disp(Selected_with_no_correction_mRMR)
Selected_with_ideal_mRMR = correctedMRMR(X_data, Y_labels, topK);
disp('Selected features using mRMR with the correctly reported unobserved (ideal) features:')
disp(Selected_with_ideal_mRMR)

% And the same with MIM
Selected_with_correctedMIM = correctedMIM(X_ur_data, Y_labels, topK, under_reported_features, prior_knowledge_all);
disp('Selected features using our Corrected-MIM:')
disp(Selected_with_correctedMIM)
Selected_with_no_correction_MIM = correctedMIM(X_ur_data, Y_labels, topK);
disp('Selected features using MIM with the under-reported features (no correction) features:')
disp(Selected_with_no_correction_MIM)
Selected_with_ideal_MIM = correctedMIM(X_data, Y_labels, topK);
disp('Selected features using MIM with the correctly reported unobserved (ideal) features:')
disp(Selected_with_ideal_MIM)