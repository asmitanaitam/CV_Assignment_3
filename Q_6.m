% Load images
imageSetPaths = {'E:\GSU\Course Work\Computer Vision\Assignment_3\Cutlery_Dataset/Spoons/', 'E:\GSU\Course Work\Computer Vision\Assignment_3\Cutlery_Dataset/Forks/', 'E:\GSU\Course Work\Computer Vision\Assignment_3\Cutlery_Dataset/Butter_knives/', 'E:\GSU\Course Work\Computer Vision\Assignment_3\Cutlery_Dataset/Cutting_knives/', 'E:\GSU\Course Work\Computer Vision\Assignment_3\Cutlery_Dataset/Soup_spoons/'};

imgSets = [];
for i = 1:length(imageSetPaths)
    imgSets = [imgSets, imageSet(imageSetPaths{i})];
end

% Create a bag of features
bag = bagOfFeatures(imgSets, 'VocabularySize', 500, 'PointSelection', 'Detector');

% Train a classifier
categoryClassifier = trainImageCategoryClassifier(imgSets, bag);

% Evaluate classifier performance
confMatrix = evaluate(categoryClassifier, imgSets);
mean(diag(confMatrix)); % Average accuracy

% Display Confusion Matrix
disp('Confusion Matrix:');
disp(array2table(confMatrix, 'VariableNames', {'Spoon', 'Fork', 'Butter_Knife', 'Cutting_Knife', 'Ladle'}, 'RowNames', {'Spoon', 'Fork', 'Butter_Knife', 'Cutting_Knife', 'Ladle'}));

% Calculate overall accuracy
overallAccuracy = sum(diag(confMatrix)) / sum(confMatrix(:));
disp(['Overall Accuracy: ', num2str(overallAccuracy)]);

% Calculate precision, recall, and F1-score
numClasses = size(confMatrix, 1);
precision = zeros(1, numClasses);
recall = zeros(1, numClasses);
f1Score = zeros(1, numClasses);

for i = 1:numClasses
    precision(i) = confMatrix(i, i) / sum(confMatrix(:, i));
    recall(i) = confMatrix(i, i) / sum(confMatrix(i, :));
    f1Score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i));
end

% Display
T = table(precision', recall', f1Score', 'RowNames', {'Spoon', 'Fork', 'Butter_Knife', 'Cutting_Knife', 'Ladle'}, 'VariableNames', {'Precision', 'Recall', 'F1_Score'});
disp(T);
