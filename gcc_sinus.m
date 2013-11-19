
load 'test_signals.mat';
DEBUG=1;

gcc_mode = 'phat';
figure
    hold on
    figure(1)
    plot(seno1,'b'); plot(seno2,'r');
    figure(2)
    
    plot(chirp1,'b'); plot(chirp2,'r');

%% TDE on sinus using gcc and the maximum peak
gcc_sinus = gcc_marques_nuevo(seno1,seno2,gcc_mode);
peak_position_sin = find(gcc_sinus==max(findpeaks(gcc_sinus)));
delay_sinusgcc = peak_position_sin - length(seno1)
cc_sinus=xcorr(seno1,seno2);
peak_position_sin1 = find(cc_sinus==max(findpeaks(cc_sinus)));
delay_sinuscc = peak_position_sin1 - length(seno1)
if DEBUG
    figure
    hold on
    subplot(1,2,1)
    plot(gcc_sinus); title('gcc between sinus');
    
    subplot(1,2,2)
    plot(cc_sinus); title('cc between sinus');
end

%% TDE on chirp using xcorr and the maximum peak
cc_chirp = xcorr(chirp1,chirp2);
peak_position_chirp = find(cc_chirp==max(findpeaks(cc_chirp)));
delay_chirpcc = peak_position_chirp - length(chirp1)
gcc_chirp = gcc_marques_nuevo(chirp1,chirp2,gcc_mode);
peak_position_chirpgcc = find(gcc_chirp==max(findpeaks(gcc_chirp)));
delay_chirpgcc = peak_position_chirpgcc - length(chirp1)

if DEBUG
    figure;
    subplot(1,1,1)
    plot(cc_chirp); title('xcorr between chirps');
    figure(2);
    plot(gcc_chirp); title('gcc between chirps');
end
%% DEBUG: no need of aux. variables
if ~DEBUG
    clear('DEBUG','peak*','xcorr*','gcc_mode')
end