%Load Signal
[Signal,sampling1,bits1] = wavread('27Apr09_174921_026_p1.wav');
[Signal2,sampling2,bits2] = wavread('27Apr09_174921_026_p2.wav');

%Times
primerevento_inicial=13440000;
primerevento_final=15840000;
segundoevento_inicial=49920000;
segundoevento_final=51840000;

%� lenght, sample freq and print
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
% Let us compute the PSD of the background noise in hydrophone #3, for
% later use. It appears that the noise is pink, 
L=96000*110;
L2=L+960000;
real_noise=Signal(L:L2);
real_noise_std=std(real_noise)

clf;
pwelch(real_noise,[],[],[],Fs);
%% FILTER OF XAVI!

%Mirar la se�al--NOOOOO

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

 Fs=96e3; % 96 KHz
    
        % 1. hydrophone signal is not zero mean :0
        signal1 = Signalcortada - mean(Signalcortada);
        % signal1= input;

        % 2. Just looking for minke whales
        % Band-pass filter
        % Generated by MATLAB(R) 8.1 and the DSP System Toolbox 8.4.
        % Generated on: 22-Nov-2013 14:26:55
        % Chebyshev Type I Bandpass filter designed using FDESIGN.BANDPASS.
        % All frequency values are in Hz.
        Fs = 96000;  % Sampling Frequency
        N      = 50;     % Order
        Fpass1 = 1e3;   % First Passband Frequency
        Fpass2 = 12e3;  % Second Passband Frequency
        Apass  = 1;      % Passband Ripple (dB)
        % Construct an FDESIGN object and call its CHEBY1 method.
        h  = fdesign.bandpass('N,Fp1,Fp2,Ap', N, Fpass1, Fpass2, Apass, Fs);
        Hd = design(h, 'cheby1');
        signal2 = sosfilt(Hd.sosMatrix,signal1);
        % DEBUG: visualize the frequency response of the filter
       % fvtool(Hd);
        % signal2=signal1;
        Signalcortada=signal2;
        
        
        %LA SEGUNDA
       signal1 = Signal2cortada - mean(Signal2cortada);
        signal2 = sosfilt(Hd.sosMatrix,signal1);
        Signal2cortada=signal2;
        
        figure(1)  
plot(Signalcortada)
figure(2)  
plot(Signal2cortada)
        

%% Time Gain norma

Signalcortada=time_gain(Signalcortada);
Signal2cortada=time_gain(Signal2cortada);

figure  
specgram(Signalcortada)




%%
%Percentil con funcion
Signalprocesada=percentile(Signalcortada,50,Fs);
Signal2procesada=percentile(Signal2cortada,50,Fs);

figure(1)
plot(Signalprocesada)
figure(2)
plot(Signalcortada)
figure(3) 
specgram(Signalprocesada)
figure(4) 
specgram(Signalcortada)

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





%% TK--USE AFTER THE DENOISING!!!!!
Signalcortadatk=teager_kaiser(Signalcortada);
Signal2cortadatk=teager_kaiser(Signal2cortada);

ax(1)=subplot(3,1,1);
plot(Signalcortada);
ylabel('Amplitude');
ax(2)=subplot(3,1,2);
plot(Signalcortadatk);
ylabel('Amplitude');
linkaxes(ax,'x');

figure
ax(1)=subplot(4,1,1);
plot(Signal2cortada);
ylabel('Amplitude');
ax(2)=subplot(4,1,2);
plot(Signal2cortadatk);
ylabel('Amplitude');
linkaxes(ax,'x');



%% TDE PROCESS THE TIME DELAY STIMATION WITH CC GCC CTE,PHAT,SCOT
gcc_mode = 'scot';
gcc_mode1 = 'cc';
gcc_mode3 = 'phat';
Signal_a_correlar=Signalprocesada;
Signal_a_correlar2=Signal2procesada;

%Xcorr
xcorr_ballena = xcorr(Signal_a_correlar,Signal_a_correlar2);
[val,ind]=max(xcorr_ballena );
delay_ball= ind-M
delay_ball_s=delay_ball/Fs;
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
    plot(gcorr_ballena); title('gcorr between whales');
 
   figure(2)
    plot(gpcorr_ballena); title('gcorr-phat between whales');
    
  figure(3)
    plot(gscorr_ballena); title('gcorr Scot between whales');
end



%% TDE Eigenvalue Descomposition
Signal_a_correlar=Signalcortadatk;
Signal_a_correlar2=Signal2cortadatk;

R=xcorr(Signal_a_correlar,Signal_a_correlar2);
[eigenvec,lambda]=eig(R);   %sacar eigenvectors y eigenvalues
if (length(R)==length(eigenvec))   %mirar que tengan el mismo rango (R y eigenvec)
    
   %caso no ruido
   %Buscar el eigenvalue 0. Entonces coger el
    %vector de ese eigenvalue sera el chanel response u=(h1,-h0) de la se�al
    %Rx0x1. 
    %Despues, miramos que h1 y h0 no contengan ningun 0 en comun
    %finalmente, T=argmax h1,l - argmax h0,l   con valores abs
    
    %caso ruido
    %u(k+1)=   (u(k)-mu*error*x)/(norma(u-mu*error*x))  con norma(u)2=1 con
    %error=u*x     PROBLEMA DE INICIALIZAR!!! LEER MA�ANA    
    
    
end

    
   
    
    


%% DEBUG: no need of aux. variables
if ~DEBUG
    clear('DEBUG','peak*','xcorr*')
end