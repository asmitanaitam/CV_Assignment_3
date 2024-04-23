% 1. Treating Every Previous Frame as a Reference Frame
% Create video reader
videoReader = VideoReader('IMG_2046.MOV');
opticFlow = opticalFlowLK('NoiseThreshold', 0.009);

while hasFrame(videoReader)
    frameRGB = readFrame(videoReader);
    frameGray = rgb2gray(frameRGB); % Convert to grayscale

    % Compute optical flow
    flow = estimateFlow(opticFlow, frameGray); 

    % Display the video frame with flow vectors
    imshow(frameRGB);
    hold on;
    plot(flow, 'DecimationFactor', [5 5], 'ScaleFactor', 10);
    hold off;
    pause(10^-3);  % Pause to view results
end
