function data = setupKitti(kitti_path)

    images = dir(strcat(kitti_path,'\*_left.jpg')); 
	
    %kitti_path = 'C:\Users\shuzhe\Desktop\Computer Vision Final\malaga-urban-dataset-extract-07_short_loopclosure\malaga-urban-dataset-extract-07\malaga-urban-dataset-extract-07_rectified_800x600_Images\';
	 n = size(images,1);

    nFr = 21; %Number of frames per place
    nPl = 3; %Number of training frames per place
    nTr = 0; %Counter of training images

    offset = round(nFr/4);
    %training
	 for ii = 1: nFr: 1743
        for jj = 1:nPl
            if (ii + offset)+round(((nFr-offset)/nPl)*jj) <= n
                nTr = nTr + 1;
                data.train{nTr} = strcat(kitti_path,images((ii + offset)+round(((nFr-offset)/nPl)*jj)).name);
                data.ytrain(nTr) = ceil(ii/nFr);
            end
        end
    end

    for ii = 1744:n
        data.test{ii} = strcat(kitti_path,images(ii).name);
        data.ytest(ii) = ceil(ii/nFr);
    end
end
