init_test_signals()
load 'test_signals.mat';
DEBUG=1;

%% TDE on sinus using xcorr and the maximum peak
delay_sinus = delay_xcorr(seno1, seno2);

if DEBUG
    figure
    hold on
    subplot(1,2,1)
    plot(xcorr_sinus); title('xcorr between sinus');
end

%% TDE on chirp using xcorr and the maximum peak
delay_chirp = delay_xcorr(chirp1, chirp2);

if DEBUG
    subplot(1,2,2)
    plot(xcorr_chirp); title('xcorr between chirps');
end

%% DEBUG: no need of aux. variables
if ~DEBUG
    clear('DEBUG','peak*','xcorr*')
end