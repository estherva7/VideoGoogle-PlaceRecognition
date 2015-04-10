%BAG OF WORDS
clear all; close all;
vlfeat_path = '/Users/esthervasiete/Dropbox/MatlabToolboxes/vlfeat-0.9.20/';
project_path = '/Users/esthervasiete/Dropbox/ComputerVision/Project-PlaceRecognition/';
addpath(genpath(vlfeat_path));
addpath(genpath(project_path));
run('vl_setup.m');

opts.dataset = 'hw4' ;
opts.prefix = 'bovw' ;
opts.encoderParams = {'type', 'bovw'} ;
opts.seed = 1 ;
opts.lite = false ;
opts.C = 1 ; % Is this used anywhere? What is this?
opts.kernel = 'linear' ;
opts.dataDir = 'data';
opts.cacheDir = '/Users/esthervasiete/Dropbox/ComputerVision/Project-PlaceRecognition/data/cache';

if strcmp(opts.dataset, 'hw4') == 1
   dataset_path =  '/Users/esthervasiete/Dropbox/ComputerVision/Project-PlaceRecognition/data/hw4/';
   imdb = dir(dataset_path); 
end

for ii = 3: length(imdb)
    train_images{ii-2} = fullfile(dataset_path, imdb(ii).name);
end

numTrain = 10;
if opts.lite, numTrain = 10 ; end

encoder = trainEncoder(train_images, opts.encoderParams{:});
descrs = encodeImage(encoder, train_images, 'cacheDir', opts.cacheDir) ;

% apply kernel maps
switch opts.kernel
  case 'linear'
  case 'hell'
    descrs = sign(descrs) .* sqrt(abs(descrs)) ;
  case 'chi2'
    descrs = vl_homkermap(descrs,1,'kchi2') ;
  otherwise
    assert(false) ;
end
descrs = bsxfun(@times, descrs, 1./sqrt(sum(descrs.^2))) ;

% SVM
lambda = 1 / (opts.C*numel(train)) ;
par = {'Solver', 'sdca', 'Verbose', ...
       'BiasMultiplier', 1, ...
       'Epsilon', 0.001, ...
       'MaxNumIterations', 100 * numel(train)} ;

for c = 1:numel(class_labels)
  [w{c},b{c}] = vl_svmtrain(descrs(:,train), y(train), lambda, par{:}) ;
  scores{c} = w{c}' * descrs + b{c} ;

  [~,~,info] = vl_pr(y(test), scores{c}(test)) ;
  ap(c) = info.ap ;
  ap11(c) = info.ap_interp_11 ;
  fprintf('class %s AP %.2f; AP 11 %.2f\n', imdb.meta.classes{classRange(c)}, ...
          ap(c) * 100, ap11(c)*100) ;
end