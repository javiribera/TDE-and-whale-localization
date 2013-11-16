init_test_signals()
load 'test_signals.mat';
DEBUG=1;

gcc_mode = 'phat';

%% TDE on sinus using gcc and the maximum peak
gcc_sinus = gcc(seno1,seno2,gcc_mode);
peak_position_sin = find(gcc_sinus==max(findpeaks(gcc_sinus)));
delay_sinus = peak_position_sin - length(seno1);

if DEBUG
    figure
    hold on
    subplot(1,2,1)
    plot(gcc_sinus); title('gcc between sinus');
end

%% TDE on chirp using xcorr and the maximum peak
gcc_chirp = xcorr(chirp1,chirp2);
peak_position_chirp = find(gcc_chirp==max(findpeaks(gcc_chirp)));
delay_chirp = peak_position_chirp - length(chirp1);

if DEBUG
    subplot(1,2,2)
    plot(gcc_chirp); title('xcorr between chirps');
end

%% DEBUG: no need of aux. variables
if ~DEBUG
    clear('DEBUG','peak*','xcorr*','gcc_mode')
end