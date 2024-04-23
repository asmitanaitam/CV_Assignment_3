% 1. Treating Every 31st Frame as a Reference Frame

videoReader = VideoReader('IMG_2046.MOV');
opticFlow = opticalFlowLK('NoiseThreshold', 0.009);

refFrame = [];
frameCount = 0;

while hasFrame(videoReader)
    frameRGB = readFrame(videoReader);
    frameGray = rgb2gray(frameRGB); % Convert to grayscale
    frameCount = frameCount + 1;

    % Set or reset reference frame every 31st frame
    if mod(frameCount, 31) == 1
        refFrame = frameGray;
        reset(opticFlow); % Reset optical flow to clear previous history
    end

    % Calculate optical flow if reference frame is set
    if ~isempty(refFrame)
        flow = estimateFlow(opticFlow, frameGray); 

        % Display the video frame with flow vectors
        imshow(frameRGB);
        hold on;
        plot(flow, 'DecimationFactor', [5 5], 'ScaleFactor', 10);
        hold off;
        pause(10^-3);  % Pause to view results
    end
end
