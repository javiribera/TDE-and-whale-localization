init_test_signals()
load 'test_signals.mat';
DEBUG=1;

gcc_mode = 'phat';

%% TDE on sinus using gcc and the maximum peak
delay_sinus = delay_gcc(seno1, seno2);

if DEBUG
    figure
    hold on
    subplot(1,2,1)
    plot(gcc_sinus); title('gcc between sinus');
end

%% TDE on chirp using xcorr and the maximum peak
delay_sinus = delay_gcc(chirp1, chirp2);

if DEBUG
    subplot(1,2,2)
    plot(gcc_chirp); title('xcorr between chirps');
end

%% DEBUG: no need of aux. variables
if ~DEBUG
    clear('DEBUG','peak*','xcorr*','gcc_mode')
end