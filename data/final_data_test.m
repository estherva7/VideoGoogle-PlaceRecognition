files = dir('C:\Users\shuzhe\Desktop\Computer Vision Final\data_tracking_oxts\testing\oxts\*.txt');
file_num = length(files);   %number of files/frames
format long


location = zeros(2,file_num);        %initialize location

%import latlon data
for i = 1:file_num
    Data = dlmread(files(i).name,' '); 
    Data = Data(1:2); 
    location(:,i) = Data'; 
end
lat = location(1,:);
lon = location(2,:);

%find path boundary and total distance
dist_max = 0;
max_frame = 0;
total_dist = 0;
start_latlon = [lat(1) lon(1)];
for i = 1:file_num-1
    latlon = [lat(i) lon(i)];
    latlon_next = [lat(i+1) lon(i+1)];
    distkm = lldistkm(start_latlon,latlon);
    total_dist = total_dist + lldistkm(latlon,latlon_next);
    if distkm>dist_max
        dist_max = distkm;
        max_frame = i;
    end
end
plot(lon([1 max_frame]),lat([1 max_frame]),'.r','MarkerSize',20)
plot_google_map

%find label step and label all frame
dist_max = dist_max*1000;
Label_dist = 0.005;                                         %distance between places
Label_step = file_num/(total_dist/Label_dist);  
Label_step = int64(Label_step);                             %step for looping the file when labeling
Label_step = 5;
Place_label_define = zeros(2,int64(file_num/Label_step));          %array for places labels for defining places,1:label number 2:#th frames
Place_label = zeros(2,file_num);                            %array of label num of all frames 1: label number 2: 0 for unique 1 for overlaping frames



%set frame 1
Place_label_define(:,1) = [1;1];
Place_label(:,1) = [1;0];
%has one label now
Label_num = 1;
%initiate minimum distance and nearest label
min_dist = 100;
nearest_label = 0;
for i = 2:file_num
    min_dist = 100;
    latlon = [lat(i) lon(i)];
    for j = 1:Label_num
        label_frame = Place_label_define(2,j);
        label_latlon = [lat(label_frame) lon(label_frame)];
        dist = lldistkm(latlon,label_latlon);
        if dist<min_dist
            min_dist = dist;
            nearest_label = j;
        end
    end
    if min_dist<0.005
        Place_label(1,i) = nearest_label;
    elseif min_dist>=0.005
        Label_num = Label_num+1;
        Place_label_define(:,Label_num) = [Label_num;i];
        Place_label(1,i) = Label_num;
    end
end


for i = 1:file_num
    max = 0;
    for j = 1:i
        if Place_label(1,j)>Place_label(1,i)
            Place_label(2,i) = 1
        end
    end
end






%draw path in real time
for i = 1:file_num
    plot(lon(i),lat(i),'.r','MarkerSize',20);
    pause(0.02);
end




