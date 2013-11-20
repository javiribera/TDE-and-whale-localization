%cargar se�al
[Signal,sampling1,bits1] = wavread('27Apr09_174921_026_p1.wav');
[Signal2,sampling2,bits2] = wavread('27Apr09_174921_026_p3.wav');

%calcular lenght, sample freq y sacarlo por pantalla
[fileLength2,num_channels2]=size(Signal2);
[fileLength1,num_channels1]=size(Signal);
duration1=fileLength1/sampling1;
duration2=fileLength2/sampling2;
text1=sprintf(' Signal1. Sampling frequency: %d Hz.\n Number of samples: %d\n Time duration: %.1f seconds', sampling1, fileLength1, duration1)
text2=sprintf(' Signal2. Sampling frequency: %d Hz.\n Number of samples: %d\n Time duration: %.1f seconds',  sampling2, fileLength2, duration2)
DEBUG=1;
Fs=sampling1;

%cortar la se�al pq es muy grande
inicio=12960000;
final=14880000;
Signalcortada=Signal(inicio:final);
Signal2cortada=Signal2(inicio:final);
M =length(Signalcortada);

%%

%Mirar la se�al--NOOOOO

clear ax;
cortada=0.33*length(Signal);
time=(0:cortada-1)/Fs;
ax(1)=subplot(3,1,1); plot(time,Signal)
ylabel('Amplitude');
title('Signal #1');
hold on;
ax(2)=subplot(3,1,2); plot(time,Signal2)
ylabel('Amplitude');
title('Signal #2');
linkaxes(ax,'x');
%zoom
%set(gca,'xlim',[6.66 6.73]);
% Let us listen to the first two clicks at hydrophone #1. 
soundsc(Signal(150*Fs:165*Fs),Fs);

%% Real noise see--NOOO
real_noise=Signal(1.26e4:1.46e4);
real_noise_std=std(real_noise)

clf;
pwelch(real_noise,[],[],[],Fs);



%% Spectral substracting noise (powepoint Ludwig)
N=final-inicio;
alpha=0.85;
p=2;
r=(max(Signalcortada)-min(Signalcortada))./2

    Signalmedia(1)=abs(Signalcortada(1));
    Signalestimada(1)=abs(Signalcortada(1));
for i=2:N
Signalmedia(i)=(alpha.*(abs(Signalmedia(i-1)).^p)+(1-alpha).*(abs(Signalcortada(i)).^p)).^(1/p);
Signalestimada(i)=r.*Signalcortada(i)./(Signalestimada(i-1));
end

 Signal2media(1)=abs(Signal2cortada(1));
    Signal2estimada(1)=abs(Signal2cortada(1));
for i=2:N
Signal2media(i)=(alpha.*(abs(Signal2media(i-1)).^p)+(1-alpha).*(abs(Signal2cortada(i)).^p)).^(1/p);
Signal2estimada(i)=r.*Signal2cortada(i)./(Signal2estimada(i-1));
end



%% Percentile noise substraction
N=final-inicio;
c=1;
NFFT=2*N+1;
S=spectrogram(Signalcortada);
for i=1:N
N=prctile(S(i),50);
Sestimada(i)=max(0,S(i)-c.*N);
end

S2=spectrogram(Signal2cortada);
for i=1:N
N2=prctile(S2(i),50);
Sestimada2(i)=max(0,S2(i)-c.*N2);
end






%% TK--NOOO
output_tk=teager_kaiser(input);

ax(1)=subplot(3,1,1);
plot(input);
ylabel('Amplitude');
ax(2)=subplot(3,1,2);
plot(output_tk);
set(gca,'ylim',[-0.01 0.01]);
ylabel('Amplitude');
linkaxes(ax,'x');



%% TDE on  data using xcorr and the maximum peak
gcc_mode = 'phat';
gcc_mode1 = 'cc';


%Xcorr
xcorr_ballena = xcorr(Signalcortada,Signal2cortada);
[val,ind]=max(xcorr_ballena );
delay_ball= ind-M
%Gcorr normal
gcorr_ballena = gcc_marques_nuevo(Signalcortada,Signal2cortada,gcc_mode1);
[val,ind]=max(gcorr_ballena );
delay_ballgccn= ind-M

%Gcorr phat
gpcorr_ballena = gcc_marques_nuevo(Signalcortada,Signal2cortada,gcc_mode);
[val,ind]=max(gpcorr_ballena );
delay_ballgccp= ind-M
%plot todo 
if DEBUG
    figure(1)
    plot(xcorr_ballena); title('xcorr between whales');
 
   figure(2)
    plot(gcorr_ballena); title('gcorr-corr between whales');figure
    
  figure(3)
    plot(gpcorr_ballena); title('gcorr phat between whales');
end



%% TDE 


%% DEBUG: no need of aux. variables
if ~DEBUG
    clear('DEBUG','peak*','xcorr*')
end