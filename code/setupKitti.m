function data = setupKitti(kitti_path)

    images = dir(strcat(kitti_path,'*_left.jpg')); 
	n = size(images,1);

    nFr = 21; %Number of frames per place
    nPl = 10; %Number of training frames per place
    nTr = 0; %Counter of training images

    offset = round(nFr/4);
    %training
	for ii = 1: nFr: 1706
        for jj = 1:nPl
            if (ii + offset)+round(((nFr-offset)/nPl)*jj) <= n
                nTr = nTr + 1;
                data.train{nTr} = strcat(kitti_path,images((ii + offset)+round(((nFr-offset)/nPl)*jj)).name);
                data.ytrain(nTr) = ceil(ii/nFr);
            end
        end
    end
    nTest = 0;
    for ii = 1707:n
        nTest = nTest + 1;
        data.test{nTest} = strcat(kitti_path,images(ii).name);
        data.ytest(nTest) = ceil((ii-1706)/nFr);
    end
end
