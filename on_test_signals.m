init_test_signals()
load 'test_signals.mat';
DEBUG=0;

%% TDE on sinus using xcorr and the maximum peak
xcorr_sinus = xcorr(seno1,seno2);
peak_position_sin = find(xcorr_sinus==max(findpeaks(xcorr_sinus)));
delay_sinus = peak_position_sin - length(seno1);

if DEBUG
    hold on
    subplot(1,2,1)
    plot(xcorr_sinus); title('xcorr between sinus');
end

%% TDE on chirp using xcorr and the maximum peak
xcorr_chirp = xcorr(chirp1,chirp2);
peak_position_chirp = find(xcorr_chirp==max(findpeaks(xcorr_chirp)));
delay_chirp = peak_position_chirp - length(chirp1);

if DEBUG
    subplot(1,2,2)
    plot(xcorr_chirp); title('xcorr between chirps');
end

%% DEBUG: no need of aux. variables
if ~DEBUG
    clear('DEBUG','peak*','xcorr*')
end