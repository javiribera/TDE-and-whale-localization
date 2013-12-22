function output = percentile(input,percentile_params)

%% Percentile noise substraction

% Original Source from Thierry Dutoit, Ferran Marquès, 
%   "Applied Signal Processing-A MATLAB-Based Proof of Concept"
%   Springer:New-York, 2009


% assure input vectors to be columns
input = input(:);
    
global Fs;
percentil = percentile_params.percentil;
c = percentile_params.c;
gamma=2;

Window_length=(Fs*0.075);   %75 ms
Window_overlap=(Fs*0.0375);    %37.5 ms
NFFT=2048;
Noise_Frames=input(1:100000);    %The first second of the simulation! It is noise!
NumOfFrames=floor(length(input)/Window_overlap);
NumOfNoiseFrames=floor(length(Noise_Frames)/Window_overlap);
Window=hann(Window_length); % A Hann window is chosen
windowEnergy=sum(Window.^gamma);
Window=Window.*sqrt(Window_length/windowEnergy); % Normalization of the window 

ProcessedSignal=zeros(length(input),1);  
 
for k=1:NumOfNoiseFrames-1   %Estimate the NOISE SPECTROGRAM
    
   index1=(k-1)*(Window_overlap)+1;
   index2=(k-1)*(Window_overlap)+Window_length;
   Frame=Noise_Frames(index1:index2);
   WindowedFrame=Frame.*Window;
   FrameFFT=fft(WindowedFrame);
   FrameSpec=((abs(FrameFFT)).^gamma)*(1/Window_length);
   S(:,k)=FrameSpec;    
end

F=length(FrameFFT);
    for i=1:F
    N(i)=prctile(abs(S(i,:)),percentil);     %Calculate the percentile vector of the NOISE FRAMES
   end

    for k=1:NumOfFrames-1     %Calculating the signal spectrogram
    
   index1=(k-1)*(Window_overlap)+1;
   index2=(k-1)*(Window_overlap)+Window_length;
   Frame=input(index1:index2);
   WindowedFrame=Frame.*Window;
   FrameFFT=fft(WindowedFrame);
   FrameSpec=((abs(FrameFFT)).^gamma)*(1/Window_length);
   Sx(:,k)=FrameSpec;    
   
    end

    
  for i=1:(NumOfFrames-1)                        %Substract the Percentile process!
   index1=(i-1)*(Window_overlap)+1;
   index2=(i-1)*(Window_overlap)+Window_length;
    FramePhase=angle(Sx(:,i));  %cCalculate the phase to reconstruct
   
      
         FrameSpec=max(abs(Sx(:,i))-c.*N',0);   %Substract the Percentile
         
        
         
% Re-synthesize the cleaned speech frame using the phase of the noisy frame   
   FrameOutputFFT= sqrt(FrameSpec).*cos(FramePhase) +...
       i.*sqrt(FrameSpec).*sin(FramePhase);
   FrameOutput=real(ifft(FrameOutputFFT,Window_length)).*sqrt(Window_length);
   
   ProcessedSignal(index1:index2)= ProcessedSignal(index1:index2) +...
       FrameOutput;
  
    
  % Notice the frames are 50% overlapped
  end
  output=ProcessedSignal;
  
end