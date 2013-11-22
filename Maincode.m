%Load Signal
[Signal,sampling1,bits1] = wavread('27Apr09_174921_026_p1.wav');
[Signal2,sampling2,bits2] = wavread('27Apr09_174921_026_p2.wav');

%Times
primerevento_inicial=2880000;
primerevento_final=3840000;
segundoevento_inicial=50880000;
segundoevento_final=51840000;

%¡ lenght, sample freq and print
[fileLength2,num_channels2]=size(Signal2);
[fileLength1,num_channels1]=size(Signal);
duration1=fileLength1/sampling1;
duration2=fileLength2/sampling2;
text1=sprintf(' Signal1. Sampling frequency: %d Hz.\n Number of samples: %d\n Time duration: %.1f seconds', sampling1, fileLength1, duration1)
text2=sprintf(' Signal2. Sampling frequency: %d Hz.\n Number of samples: %d\n Time duration: %.1f seconds',  sampling2, fileLength2, duration2)
DEBUG=1;
Fs=sampling1;

%Cut the SIGNAL
inicio=primerevento_inicial;
final=primerevento_final;


Signalcortada=Signal(inicio:final);
Signal2cortada=Signal2(inicio:final);
M =length(Signalcortada)

%%

%Mirar la señal--NOOOOO

%clear ax;
%cortada=0.33*length(Signal);
%time=(0:cortada-1)/Fs;
%ax(1)=subplot(3,1,1); plot(time,Signal)
%ylabel('Amplitude');
%title('Signal #1');
%hold on;
%ax(2)=subplot(3,1,2); plot(time,Signal2)
%ylabel('Amplitude');
%title('Signal #2');
%linkaxes(ax,'x');
%zoom
%set(gca,'xlim',[6.66 6.73]);
% Let us listen to the first two clicks at hydrophone #1. 
%soundsc(Signal(150*Fs:165*Fs),Fs);

%% Real noise see--NOOO
%real_noise=Signal(1.26e4:1.46e4);
%real_noise_std=std(real_noise)

%clf;
%pwelch(real_noise,[],[],[],Fs);



%% Time Gain normalization substracting noise (powepoint Ludwig)
N=final-inicio;
alpha=0.9;
p=2;
r=1;

    Signalmedia(1)=abs(Signalcortada(1));
    Signalestimada(1)=abs(Signalcortada(1));
for i=2:N
Signalmedia(i)=(alpha.*(abs(Signalmedia(i-1)).^p)+(1-alpha).*(abs(Signalcortada(i)).^p)).^(1/p);
Signalestimada(i)=r.*max((Signalcortada(i)./Signalestimada(i-1)),eps);
end

 Signal2media(1)=abs(Signal2cortada(1));
    Signal2estimada(1)=abs(Signal2cortada(1));
for i=2:N
Signal2media(i)=(alpha.*(abs(Signal2media(i-1)).^p)+(1-alpha).*(abs(Signal2cortada(i)).^p)).^(1/p);
Signal2estimada(i)=r.*max((Signal2cortada(i)./Signal2estimada(i-1)),eps);
end
figure(1)  
specgram(Signalmedia)
figure(2)  
specgram(Signalestimada)
figure(3)  
specgram(Signalcortada)





%% Percentile noise substraction
N=final-inicio;
c=1;
percentil=90;
M=length(S);

S=spectrogram(Signalcortada);
S2=spectrogram(Signal2cortada);

for i=1:M
    for k=1:7
N=prctile(S(i,k),90);
Sestimada(i,k)=max(0,S(i,k)-N);
N2=prctile(S2(i,k),90);
Sestimada2(i,k)=max(0,S2(i,k)-N);
    end
end

%ANTITRANSFORM OF SPECTROGRAM TO SIGNAL

figure(1)
plot(Sestimada)
figure(2)
plot (Sestimada2)



%% Frequency band normalization
N=final-inicio;
c=1;
Signalresultant=0;
Sx=spectrogram(Signalcortada);
Signalresultant2=0;
Sx2=spectrogram(Signal2cortada);
M=length(Sx);
alpha1=0.8;
for k=1:7
    Smedia(1,k)=Sx(1,k);
    Sresultante(1,k)=Sx(1,k)-Smedia(1,k);
    Smedia2(1,k)=Sx2(1,k);
    Sresultante2(1,k)=Sx2(1,k)-Smedia2(1,k);
for i=2:M
 Smedia(i,k)=alpha1.*Smedia(i-1,k)+(1-alpha1).*Sx(i,k);
 Sresultante(i,k)=Sx(i,k)-Smedia(i,k);
 Smedia2(i,k)=alpha1.*Smedia2(i-1,k)+(1-alpha1).*Sx2(i,k);
 Sresultante2(i,k)=Sx2(i,k)-Smedia2(i,k);
end
end

%ANTITRANSFORM OF SPECTROGRAM TO SIGNAL

figure(1) 
plot(Signalresultant)
figure(2)
plot(Signalcortada)





%% TK--NOOO
%output_tk=teager_kaiser(input);

%ax(1)=subplot(3,1,1);
%plot(input);
%ylabel('Amplitude');
%ax(2)=subplot(3,1,2);
%plot(output_tk);
%set(gca,'ylim',[-0.01 0.01]);
%ylabel('Amplitude');
%linkaxes(ax,'x');



%% TDE on  data using xcorr and the maximum peak
gcc_mode = 'scot';
gcc_mode1 = 'cc';
gcc_mode3 = 'phat';
Signal_a_correlar=Signalestimada;
Signal_a_correlar2=Signal2estimada;

%Xcorr
xcorr_ballena = xcorr(Signal_a_correlar,Signal_a_correlar2);
[val,ind]=max(xcorr_ballena );
delay_ball= ind-M
delay_ball_s=delay_ballgccn/Fs;
%Gcorr normal
gcorr_ballena = gcc_marques_nuevo(Signal_a_correlar,Signal_a_correlar2,gcc_mode1);
[val,ind]=max(gcorr_ballena );
delay_ballgccn= ind-M
delay_ballgccn_cte=delay_ballgccn/Fs;
%Gcorr scot
gscorr_ballena = gcc_marques_nuevo(Signal_a_correlar,Signal_a_correlar2,gcc_mode);
[val,ind]=max(gscorr_ballena );
delay_ballgccs= ind-M
delay_ballgcc_scot=delay_ballgccs/Fs;
%Gcorr phat
gpcorr_ballena = gcc_marques_nuevo(Signal_a_correlar,Signal_a_correlar2,gcc_mode3);
[val,ind]=max(gpcorr_ballena );
delay_ballgccp= ind-M
delay_ballgcc_phat=delay_ballgccp/Fs;
%plot todo 
if DEBUG
    figure(1)
    plot(xcorr_ballena); title('xcorr between whales');
    
    figure(4)
    plot(xcorr_ballena); title('xcorr between whales');
 
   figure(2)
    plot(gpcorr_ballena); title('gcorr-phat between whales');
    
  figure(3)
    plot(gscorr_ballena); title('gcorr Scot between whales');
end



%% TDE 


%% DEBUG: no need of aux. variables
if ~DEBUG
    clear('DEBUG','peak*','xcorr*')
end