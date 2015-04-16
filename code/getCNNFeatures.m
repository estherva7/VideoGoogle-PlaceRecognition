function feat = getCNNFeatures(data, layer)
    feat = [];
    num_files = size(data,2);
    for ii = 1: num_files
        %cnn_path = strcat(data{ii}(1:end-4),num2str(layer),'.txt'); %Add
        %layer number in text files
        cnn_path = strcat(data{ii}(1:end-4),'.txt');
        feat_vector = readFeatureFile(cnn_path);
        feat = [feat feat_vector'];
    end
end