function feat = getCNNFeatures(data, layer)
    feat = [];
    num_files = size(data,2);
    for ii = 1: num_files
        if layer == 10
          cnn_path = strcat(data{ii}(1:end-4),'.txt');
        else
            cnn_path = strcat(data{ii}(1:end-4),'layer',num2str(layer),'.txt');
        end
        feat_vector = readFeatureFile(cnn_path);
        feat = [feat feat_vector'];
    end
end