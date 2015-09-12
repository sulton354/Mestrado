function [Y, timeTest] = testSIFT( trainData, testData, k, path, nnThreshold )
%TESTSIFT Test of SIFT
% trainData - data train
% testData - test train
% k - number of image model by classes
% path - path to read the image
% nnThreshold - threshold

numTest = length(testData.labels);
numTrain = length(trainData.labels);

Y = zeros(1,numTest);
numIndex = zeros(1, numTrain);
timeTest = zeros(1, numTest);
for i = 1 : numTest
    tic
    img = imread(sprintf('%s%s', path, testData.imgs{i}));
    img = single(rgb2gray(img));
    
    [~, descrsTest] = vl_sift(img);
%         [~, descrsTest] = getFeatures(img);
    
    for j = 1 : numTrain
        imgTrain = imread(sprintf('%s%s', path, trainData.imgs{j}));
        imgTrain = single(rgb2gray(imgTrain));
        
        [~, descrsTrain] = vl_sift(imgTrain);
%                 [~, descrsTrain] = getFeatures(imgTrain);
        
        [~, dist] = findNeighbours(single(descrsTest), single(descrsTrain), 2);
        ratio = dist(1,:) ./ dist(2,:);
        ok = ratio <= nnThreshold^2;
        
        numIndex(j) = sum(ok);                
                
        fprintf('%d %d \n', i, j);
    end
    [~, lbs] = sort(numIndex, 'descend');
    Y(i) = lbs(1:k);
    timeTest(i) = toc;
end

end