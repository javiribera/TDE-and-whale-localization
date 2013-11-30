function output = percentile(input,percentile_params)

%% Percentile noise substraction- ENPROCESO
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
  %%
  
  %%PERCENTILE CURVE

%L=floor(length(T)/2);
 %for j=1:100
  %      resultado(j)=prctile(S(L,:),j);
% end
 %resultado=abs(resultado);
    %PLOT ALL
%figure()
%plot(resultado);
%ylabel('Spectrogrmvalue');
%xlabel('percentil');
  
  %% BASURA QUE PUEDE SER UTIL EN EL FUTURO
  %
  %for k=1:Window_length
    
 %  index1=(k-1)*(Window_overlap)+1;
  % index2=(k-1)*(Window_overlap)+Window_length;
   %Frame=input(index1:index2);
   %WindowedFrame=Frame.*Window;
   %FrameFFT=fft(WindowedFrame);
   %FrameSpec=((abs(FrameFFT)).^gamma)*(1/Window_length);
   %N(k)=prctile(FrameSpec(k),percentil); % Averaging
%end


 %Frame=Signalcortada(index1:index2);
   %WindowedFrame=Frame.*Window;
   %FrameFFT=fft(WindowedFrame,NFFT);
   %FrameSpec=((abs(FrameFFT)).^gamma)*(1/Window_length); % Frame periodogram
   %FramePhase=angle(FrameFFT); % Save the phase function
  % FrameSpec=((abs(S(:,i))))*(1/Window_length); % Frame periodogram
   %FramePhase(i)=angle(S(:,i)); % Save the phase function
      %  FrameSpec=max(FrameSpec-N,0);
    
end