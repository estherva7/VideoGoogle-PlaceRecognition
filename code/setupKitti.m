function data = setupKitti(kitti_path)
    
    %test_frames = [1707 1724 1743 1762 1782 1798 1814 1830 1849 1860 1880 1896 1914 1932 1950 1968 1990 2015 2040	2060 2082 2102 2126 2146 2166 2183 2202	2222 2242];
    test_frames = [1707 1743 1782 1814 1849 1880 1914 1950 1990 2040 2082 2126 2166 2202 2242];
    labels = 1:length(test_frames);
    images = dir(strcat(kitti_path,'*_left.jpg')); 
	n = size(images,1);

    %nFr = 21; %Number of frames per place
    nFr = 42;
    nPl = 10; %Number of training frames per place
    nTr = 0; %Counter of training images

    offset = round(nFr/4);
    %training
	for ii = 1: nFr: 1706
        for jj = 1:nPl
            if (ii + offset)+round(((nFr-offset)/nPl)*jj) <= n
                nTr = nTr + 1;
                data.train{nTr} = strcat(kitti_path,images((ii + offset)+round(((nFr-offset)/nPl)*jj)).name);
                imshow(data.train{nTr})
                data.ytrain(nTr) = ceil(ii/nFr);
                data.ytrain(nTr)
                pause(1)
            end
        end
    end
    nTest = 0;
    for ii = 1707:n
        dummy = find(test_frames <= ii);
        nTest = nTest + 1;
        data.test{nTest} = strcat(kitti_path,images(ii).name);
        data.ytest(nTest) = labels(dummy(end));
    end
end
