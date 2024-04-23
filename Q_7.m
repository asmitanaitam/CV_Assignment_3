% Load the images 
image1 = imread('Q_7_Left.JPG');
image2 = imread('Q_7_Right.JPG');

% Detect SURF features in both images
points1 = detectSURFFeatures(rgb2gray(image1));
points2 = detectSURFFeatures(rgb2gray(image2));

% Extract feature descriptors
[features1, validPoints1] = extractFeatures(rgb2gray(image1), points1);
[features2, validPoints2] = extractFeatures(rgb2gray(image2), points2);

% Match features using their descriptors
indexPairs = matchFeatures(features1, features2);
matchedPoints1 = validPoints1(indexPairs(:, 1));
matchedPoints2 = validPoints2(indexPairs(:, 2));

% Visualize matched features
figure; showMatchedFeatures(image1, image2, matchedPoints1, matchedPoints2, 'montage');
title('Matched SURF points, including outliers');

% Estimate the fundamental matrix
[fMatrix, epipolarInliers, status] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2, 'Method', 'RANSAC', 'NumTrials', 10000, 'DistanceThreshold', 0.1);

% Keep only inlier points after RANSAC
inlierPoints1 = matchedPoints1(epipolarInliers, :);
inlierPoints2 = matchedPoints2(epipolarInliers, :);

% Visualize inlier matches
figure; showMatchedFeatures(image1, image2, inlierPoints1, inlierPoints2, 'montage');
title('Inlier matches');

% Rectify the images using the fundamental matrix
[t1, t2] = estimateUncalibratedRectification(fMatrix, inlierPoints1, inlierPoints2, size(image2));
[rectifiedImage1, rectifiedImage2] = rectifyStereoImages(image1, image2, t1, t2);

% Display rectified images
figure; imshow(stereoAnaglyph(rectifiedImage1, rectifiedImage2));
title('Rectified Images');
