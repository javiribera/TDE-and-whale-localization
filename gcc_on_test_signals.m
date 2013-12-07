addpath 'test_signals'
init_test_signals()
load 'test_signals/test_signals.mat';
DEBUG=1

gcc_mode = 'scot';

%% TDE on sinus using gcc and the maximum peak
delay_sinus = delay_gcc(seno1, seno2, gcc_mode);

if DEBUG
    figure
    hold on
    subplot(1,3,1)
    plot(gcc(seno1, seno2, gcc_mode)); title('gcc between sinus');
end

%% TDE on chirp using gcc and the maximum peak
delay_chirp = delay_gcc(chirp1, chirp2, gcc_mode);

if DEBUG
    subplot(1,3,2)
    plot(gcc(chirp1, chirp2, gcc_mode)); title('gcc between chirps');
end


%% TDE on chirp using gcc and the maximum peak
delay_noise = delay_gcc(noise1, noise2, gcc_mode);

if DEBUG
    subplot(1,3,3)
    plot(gcc(noise1, noise2, gcc_mode)); title('gcc between white noise');
end

%% DEBUG: no need of aux. variables
if ~DEBUG
    clear('DEBUG','peak*','xcorr*','gcc_mode', 'noise*')
end