function regions = trackMSregions(train_path, image_files, im_idx, feature_params)

     img1 = imread(strcat(train_path,image_files(im_idx).name)); img1 = im2single(img1);
     img2 = imread(strcat(train_path,image_files(im_idx+1).name)); img2 = im2single(img2);
     img3 = imread(strcat(train_path,image_files(im_idx+2).name)); img3 = im2single(img3);
     regions1 = detectMSERFeatures(img1);
     regions2 = detectMSERFeatures(img2);
     regions3 = detectMSERFeatures(img3);
     
     region_idxs = [];
     for i = 1: regions1.Count
         d12 = dist(regions1.Location(i,:), regions2.Location');
         %d13 = dist(regions1.Location(i,:), regions3.Location');
         [d12_sort idx1] = sort(d12, 'ascend');
         if(d12_sort(1) < 6); %Hard threshold
             d13 = dist(regions2.Location(idx1(1),:), regions3.Location');
             [d13_sort idx2] = sort(d13, 'ascend');
             if (d13_sort(1) < 6);
                 region_idxs = [region_idxs; i idx1(1) idx2(1)];
                 % Sanity check for Axes or Orientation
             end
         end
     end
     regions.Count = size(region_idxs,1);
     regions.Location = [regions1.Location(region_idxs(:,1)) regions2.Location(region_idxs(:,2)) regions3.Location(region_idxs(:,3))];
     regions.Axes = [regions1.Axes(region_idxs(:,1)) regions2.Axes(region_idxs(:,2)) regions3.Axes(region_idxs(:,3))];
     regions.Orientation = [regions1.Orientation(region_idxs(:,1)) regions2.Orientation(region_idxs(:,2)) regions3.Orientation(region_idxs(:,3))];
     regions.PixelList{1} = regions1.PixelList(region_idxs(:,1));
     regions.PixelList{2} = regions2.PixelList(region_idxs(:,2));
     regions.PixelList{3} = regions3.PixelList(region_idxs(:,3));