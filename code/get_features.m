function features_pos = get_features(train_path, feature_params)

image_files = dir( fullfile( train_path, '*.png') );
num_images = length(image_files);

% For each image, extract SA and MS regions (and track them to keep the ones that survive every three frames)
% For each region survived after every three frames, extract SIFT features
% and average them.

% ADVANCED: From the paper: "Regions are tracked through contiguous frames, and a
% mean vector descriptor x computed for each of the i regions. To reject
% unstable regions, the 10% of tracks with the largest covariance matrix
% are rejected." The paper kept about 1000 regions per frame

%Help MS: http://www.mathworks.com/help/vision/ref/mserregions-class.html?refresh=true


features.SA = []; %Should return RSAx128 vector, where RSA is the total number of regions kept using SA
features.MS = []; %Should return RMSx128 vector, where RMS is the total number of regions kept using MS
for im = 1: 3: num_images
    regionsMS = trackMSregions(train_path, image_files, im, feature_params);
    SIFT_MS = extractAverageSIFT(train_path, image_files, im, regionsMS, feature_params);
%     [fl,dl] = vl_sift(im2single(img));
%     features.SA = [features.SA; hog_feature];
end
