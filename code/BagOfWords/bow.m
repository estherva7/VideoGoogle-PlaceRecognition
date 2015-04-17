% PLACE RECOGNITION
clear all; close all;
vlfeat_path = '/Users/esthervasiete/Dropbox/MatlabToolboxes/vlfeat-0.9.20/';
project_path = '/Users/esthervasiete/Dropbox/ComputerVision/Project-PlaceRecognition/';
addpath(genpath(vlfeat_path));
addpath(genpath(project_path));
run('vl_setup.m');

opts.dataset = 'kitti'; % Options: 'kitti', 'hw4', 'campus'
opts.prefix = 'bovw' ; % Do not change this
opts.encoderParams = {'type', 'bovw'} ; % Do not change this
opts.seed = 1 ;
opts.lite = false ;
opts.C = 1 ; 
opts.kernel = 'linear' ; % We could probably just stick to linear
opts.dataDir = 'data';
opts.featureExtractionMethod = 'cnn'; % Options: 'bow', 'cnn'

%Update paths!!
if strcmp(opts.dataset, 'hw4') == 1
   dataset_path = '/Users/esthervasiete/Dropbox/ComputerVision/Homework4/cityblock/';
   data = setupCityblock(dataset_path);
else if strcmp(opts.dataset, 'kitti') == 1
	dataset_path = '/Users/esthervasiete/Dropbox/ComputerVision/malaga-urban-dataset-extract-07/malaga-urban-dataset-extract-07_rectified_800x600_Images/';                    %'kitti dataset path'
	data = setupKitti(dataset_path);
    end
end

% Bag of words 
if strcmp(opts.featureExtractionMethod, 'bow') == 1   
    encoder = trainEncoder(data.train, opts.encoderParams{:});
    descrs_train = encodeImage(encoder, data.train) ;
    descrs_test = encodeImage(encoder, data.test) ;
end

% CNN feature extraction
if strcmp(opts.featureExtractionMethod, 'cnn') == 1
    layer = 10;
    descrs_train = getCNNFeatures(data.train, layer);
    descrs_test = getCNNFeatures(data.test, layer);
end

% Apply kernel maps - Learn what this is
switch opts.kernel
  case 'linear'
  case 'hell'
    descrs_train = sign(descrs_train) .* sqrt(abs(descrs_train)) ;
    descrs_test = sign(descrs_test) .* sqrt(abs(descrs_test)) ;
  case 'chi2'
    descrs_train = vl_homkermap(descrs_train,1,'kchi2') ;
    descrs_test = vl_homkermap(descrs_test,1,'kchi2') ;
  otherwise
    assert(false) ;
end
descrs_train = bsxfun(@times, descrs_train, 1./sqrt(sum(descrs_train.^2))) ;
descrs_test = bsxfun(@times, descrs_test, 1./sqrt(sum(descrs_test.^2))) ;

% SVM
lambda = 1 / (opts.C*numel(data.train)) ;
par = {'Solver', 'sdca', 'Verbose', ...
       'BiasMultiplier', 1, ...
       'Epsilon', 0.001, ...
       'MaxNumIterations', 100 * numel(data.train)} ;
class_labels = unique(data.ytest);
y = data.ytrain;
ytest = data.ytest;
for c = 1: numel(class_labels)
    c
    y(find(data.ytrain == c)) = ones(1,numel(find(data.ytrain == c)));
    y(find(data.ytrain ~= c)) = -1 * ones(1,numel(find(data.ytrain ~= c)));
    [w{c},b{c}] = vl_svmtrain(descrs_train, y, lambda, par{:}) ;
    scores{c} = w{c}' * descrs_test + b{c} ;
    
    ytest(find(data.ytest == c)) = ones(1,numel(find(data.ytest == c)));
    ytest(find(data.ytest ~= c)) = -1 * ones(1,numel(find(data.ytest ~= c)));
    test_labels{c} = ytest;
    if numel(find(ytest == 1)) > 0 
        [~,~,info] = vl_pr(ytest, scores{c}) ;
    
        [tpr{c},tnr{c}] = vl_roc(ytest, scores{c});
        ap(c) = info.ap ;
        ap11(c) = info.ap_interp_11 ; %11-pts interpolated avr precision
        plot(tnr{c},tpr{c}); drawnow
        pause(0.5);
    end
end
% Average ROC - Is this good??
scores = cat(1,scores{:}) ;
labels = cat(1, test_labels{:});
vl_roc(labels, scores, 'Plot', 'tptn');


% confusion matrix (can be computed only if each image has only one label)
[~,preds] = max(scores, [], 1) ;
numClasses = numel(class_labels);
confusion = zeros(numClasses) ;
for c = 1:numClasses
    sel = find(data.ytest == c) ;
    tmp = accumarray(preds(sel)', 1, [numClasses 1]) ;
    tmp = tmp / max(sum(tmp),1e-10) ;
    confusion(c,:) = tmp(:)' ;
end

% figures
meanAccuracy = sprintf('mean accuracy: %f\n', mean(diag(confusion)));
mAP = sprintf('mAP: %.2f %%; mAP 11: %.2f', mean(ap) * 100, mean(ap11) * 100) ;

figure(2) ; clf ;
imagesc(confusion) ; axis square ;
title([opts.prefix ' - ' meanAccuracy]) ;
vl_printsize(1) ;

figure(3) ; clf ; bar(ap * 100) ;
title([opts.prefix ' - ' mAP]) ;
ylabel('AP %%') ; xlabel('class') ;
grid on ;
vl_printsize(1) ;
ylim([0 100]) ;

disp(meanAccuracy) ;
disp(mAP) ;

