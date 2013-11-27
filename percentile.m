function output = percentile( input,percentil,Fs)

%% 4. Percentile noise substraction- ENPROCESO
       gamma=2;
c=1;

Window_length=(Fs*0.15);   %50 ms
Window_overlap=(Fs*0.075);    %25 ms
NFFT=512;
   
NumOfFrames=floor(length(input)/Window_overlap);
Window=hann(Window_length); % A Hann window is chosen
windowEnergy=sum(Window.^gamma);
Window=Window.*sqrt(Window_length/windowEnergy); % Normalization of the window 

ProcessedSignal=zeros(length(input),1);
 [S,F,T]=spectrogram(input,Window_length,Window_overlap,NFFT,Fs); 
 
   % for k=1:length(F)
%N(k)=prctile(S(k,:),90);


 %   end
for k=1:Window_length
    
   index1=(k-1)*(Window_overlap)+1;
   index2=(k-1)*(Window_overlap)+Window_length;
   Frame=input(index1:index2);
   WindowedFrame=Frame.*Window;
   FrameFFT=fft(WindowedFrame);
   FrameSpec=((abs(FrameFFT)).^gamma)*(1/Window_length);
   N(k)=prctile(FrameSpec(k),percentil); % Averaging
end
    
    
    
  for i=1:(NumOfFrames-1)
   index1=(i-1)*(Window_overlap)+1;
   index2=(i-1)*(Window_overlap)+Window_length;
   Frame=input(index1:index2);
   WindowedFrame=Frame.*Window;
   FrameFFT=fft(WindowedFrame);
   FrameSpec=((abs(FrameFFT)).^gamma)*(1/Window_length); % Frame periodogram
   FramePhase=angle(FrameFFT); % Save the phase function
   
% ********************************************
% Implement the spectral subtraction equations
% ********************************************
 
      FrameSpec=max(FrameSpec-N,0);
      
  
   
% Re-synthesize the cleaned speech frame using the phase of the noisy frame   
   FrameOutputFFT= sqrt(FrameSpec).*cos(FramePhase) +...
       i*sqrt(FrameSpec).*sin(FramePhase);
   FrameOutput=real(ifft(FrameOutputFFT))*sqrt(Window_length);
   ProcessedSignal(index1:index2)= ProcessedSignal(index1:index2) +...
       FrameOutput;
   output=ProcessedSignal;
  % Notice the frames are 50% overlapped
  end  
end