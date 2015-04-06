function histogram = visual_indexing(data_path, visual_vocab, feature_params)

image_files = dir( fullfile( train_path, '*.jpg') );
num_images = length(image_files);
visual_vocabulary = [visual_vocab.SA visual_vocab.MS]; %Merge vocabulary words 

histogram = zeros(num_images, size(visual_vocabulary,2)); %Histogram is (num_images)x(K_SA + K_MS)
for im = 1: num_images
    %Extract SA, MS per each image and compute SIFT descriptors per each
    %region
    
    numFeat = 1; % Set to the number of SIFT descriptors in SA + MS
    for feat = 1: numFeat
        idx = 1; % set idx to be the idx of the closest centroid from this feature vector to visual_vocab
        % Basically, compute mahalanobis distance from this feature
        % vector (1x128) to each of the vocabulary words and chose the
        % closest
        histogram(im, idx) = histogram(im, idx) + 1; %Updates histogram
    end
end
        

