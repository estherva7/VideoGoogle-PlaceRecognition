function SIFT_descriptors = extractAverageSIFT(train_path, image_files, im_idx, regionsMS, feature_params)
    img1 = imread(strcat(train_path,image_files(im_idx).name)); img1 = im2single(img1);
    img2 = imread(strcat(train_path,image_files(im_idx+1).name)); img2 = im2single(img2);
    img3 = imread(strcat(train_path,image_files(im_idx+2).name)); img3 = im2single(img3);
    [f1,d1] = vl_sift(img1);
    [f2,d2] = vl_sift(img2);
    [f3,d3] = vl_sift(img3);
    