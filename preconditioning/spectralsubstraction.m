function output = spectralsubstraction(input,signal_substraction_params)

%% SPECTRAL SUBSTRACTION

% Original Source from Thierry Dutoit, Ferran Marquès, 
%   "Applied Signal Processing-A MATLAB-Based Proof of Concept"
%   Springer:New-York, 2009

% assure input vectors to be columns
input = input(:);

global Fs;
alpha = signal_substraction_params.alpha;
beta = signal_substraction_params.beta;
gamma=2; % Exponent of magnitude spectrum
frameShiftDuration=10; % in ms
frameDuration=20; % in ms
initialNoiseDuration=1000; 
numNoiseSamples=initialNoiseDuration*Fs/1000; % Number of silence
% samples used to estimate the noise spectrum  

% Initialization of the frame-based processing:
frameShiftLength=frameShiftDuration*Fs/1000; 
frameLength=frameDuration*Fs/1000;
fileLength=length(input);
numOfFrames=floor(fileLength/frameShiftLength);
numNoiseFrames=floor(numNoiseSamples/frameShiftLength);  
 
Window=hann(frameLength); % A Hann window is chosen
windowEnergy=sum(Window.^gamma);
Window=Window.*sqrt(frameLength/windowEnergy); % Normalization of the window 
% energy to frameLength

% Computation of the Welch estimate (averaging of periodograms):

NoiseSpec=zeros(frameLength,1);

for k=1:numNoiseFrames
    
   index1=(k-1)*(frameShiftLength)+1;
   index2=(k-1)*(frameShiftLength)+frameLength;
   Frame=input(index1:index2);
   WindowedFrame=Frame.*Window;
   FrameFFT=fft(WindowedFrame);
   FrameSpec=((abs(FrameFFT)).^gamma)*(1/frameLength);
   NoiseSpec=NoiseSpec+FrameSpec./numNoiseFrames; % Averaging
end


% figure(2); plot(NoiseSpec(1:frameLength/2+1));

% Working frame-by-frame, subtract the noise spectrum estimate from the 
% noisy speech spectrum, with the usual spectral subtraction equations. 


ProcessedSignal=zeros(fileLength,1);

for k=1:(numOfFrames-1)
   index1=(k-1)*(frameShiftLength)+1;
   index2=(k-1)*(frameShiftLength)+frameLength;
   Frame=input(index1:index2);
   WindowedFrame=Frame.*Window;
   FrameFFT=fft(WindowedFrame);
   FrameSpec=((abs(FrameFFT)).^gamma)*(1/frameLength); % Frame periodogram
   FramePhase=angle(FrameFFT); % Save the phase function
   
% ********************************************
% Implement the spectral subtraction equations
% ********************************************
 
      FrameSpec=max(FrameSpec-alpha*NoiseSpec,beta*FrameSpec);
      
  
   
% Re-synthesize the cleaned speech frame using the phase of the noisy frame   
   FrameOutputFFT= sqrt(FrameSpec).*cos(FramePhase) +...
       i*sqrt(FrameSpec).*sin(FramePhase);
   FrameOutput=real(ifft(FrameOutputFFT))*sqrt(frameLength);
   ProcessedSignal(index1:index2)= ProcessedSignal(index1:index2) +...
       FrameOutput; % Notice the frames are 50% overlapped
   
end  
 output=ProcessedSignal;
end