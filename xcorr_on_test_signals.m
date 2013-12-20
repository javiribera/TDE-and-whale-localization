addpath 'test_signals' 'algorithms_TDE'
init_test_signals()
load 'test_signals/test_signals.mat';
DEBUG=1;

%% TDE on sinus using xcorr and the maximum peak
delay_sinus = delay_xcorr(seno1, seno2);

if DEBUG
    figure
    hold on
    subplot(1,3,1)
    plot(xcorr(seno1, seno2)); title('xcorr between sinus');
end

%% TDE on chirp using xcorr and the maximum peak
delay_chirp = delay_xcorr(chirp1, chirp2);

if DEBUG
    subplot(1,3,2)
    plot(xcorr(chirp1, chirp2)); title('xcorr between chirps');
end

%% TDE on noise using xcorr and the maximum peak
delay_noise = delay_xcorr(noise1, noise2);

if DEBUG
    subplot(1,3,3)
    plot(xcorr(noise1, noise2)); title('xcorr between white noise');
end

%% DEBUG: no need of aux. variables
if ~DEBUG
    clear('DEBUG','peak*','xcorr*')
end