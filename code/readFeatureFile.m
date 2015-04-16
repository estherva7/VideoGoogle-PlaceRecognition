function feature_vector = readFeatureFile(path)
fileID = fopen(path);
formatSpec = '%f';
if fileID > -1
    while ~feof(fileID)
        C = textscan(fileID,formatSpec);
    end
end
% Sanity check
if C{1}(1)*C{1}(2)*C{1}(3) == size(C{1},1) - 3
    feature_vector = C{1}(4:end)';
else
    feature_vector = [];
end
fclose(fileID);