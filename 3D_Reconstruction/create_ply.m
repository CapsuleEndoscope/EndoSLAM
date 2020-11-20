filePath = 'test.mat';
data = load(filePath);
data.points;

ptCloud = pointCloud(data.points);
pcwrite(ptCloud,'<ply_file_name>','PLYFormat','ascii');
