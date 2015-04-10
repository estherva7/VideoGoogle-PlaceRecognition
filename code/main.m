close all; clear all; 

%% Set Paths
vlfeat_path = '/Users/esthervasiete/Dropbox/MatlabToolboxes/vlfeat-0.9.20/toolbox/';
addpath(vlfeat_path);
data_path = '/Users/esthervasiete/Dropbox/ComputerVision/Project-PlaceRecognition/'; 
train_path = fullfile(data_path, 'data/train/'); 
test_path = fullfile(data_path,'data/test/');
run('vl_setup');

%% Feature parameters - defined as a struct (new parameters can be added as needed)
feature_params = struct('K_SA', 6000, 'K_MS', 10000); %Paremeters: K in K-means, other parameters to be added...

%% Step 1. Load training data and extract SIFT features
features_train = get_features( train_path, feature_params );


% features_test = get_features( test_path, feature_params );
%features_val = get_features(validation_path, feature_params);

% %% Step 2. Build visual vocabulary
% visual_vocab = build_vocab( features_train, feature_params );
% 
% %% Step 3. Visual indexing
% histogram_train = visual_indexing( train_path, visual_vocab, feature_params);
% histogram_test = visual_indexing( test_path, visual_vocab, feature_params);
% % ADVANCED: Normalize histograms using tf-idf (e.g. histograms_train = normalize_tfidf(histograms_train))
% 
% %% Step 4. Evaluation
% % ADVANCED (And beyond the paper): Train multimodal SVM instead of using
% % normalized scalar product
% rank = compute_rank(histogram_train, histogram_test, feature_params);
% 
% %% Step 5. Precision-recall curves
