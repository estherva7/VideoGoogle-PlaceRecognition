function data = setupCityblock(cityblock_path)

    limages = dir(strcat(cityblock_path,'images/left*.png')); rimages = dir(strcat(cityblock_path,'images/right*.png'));
    n = size(limages,1);

    nFr = 100; %Number of frames per place
    nPl = 3; %Number of training frames per place
    nTr = 0; %Counter of training images

    offset = round(nFr/4);
    for ii = 1: 100: n
        for jj = 1:nPl
            if (ii + offset)+round(((nFr-offset)/nPl)*jj) <= n
                nTr = nTr + 1;
                data.train{nTr} = strcat(cityblock_path,'images/',limages((ii + offset)+round(((nFr-offset)/nPl)*jj)).name);
                data.ytrain(nTr) = ceil(ii/nFr);
            end
        end
    end

    for ii = 1:n
        data.test{ii} = strcat(cityblock_path,'images/',rimages(ii).name);
        data.ytest(ii) = ceil(ii/nFr);
    end
end