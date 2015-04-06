function visual_vocab = build_vocab(features, feature_params)
% Here features is a struct containing features.SA and features.MS
% Perform k-means (with Mahalanobis distance if possible) for SA and MS
% features independently. The paper exracted about 6k clusters for SA and
% 10k clusters for MS 


visual_vocab.SA = []; %Should return the centroids of SA (dimensions K_SAx128)
visual_vocab.MS = []; %Should return the centroids of MS (dimensions K_MSx128)



