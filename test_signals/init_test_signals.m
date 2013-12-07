% Crea señales de prueba con un retardo conocido:
% 2 senos, 2 chirps, y ruido blanco
%
DEBUG=0;

%% Init parameters of the signals

fs = 96e3; % sampling rate, the same as in the sensors, 96 KHz
nsamples = 2^14; % length of the sequence


delay_seconds = 0.001;  % possible real delay, -> but larger than sinus period,
                    % so delay on sinus is periodic
delay_samples = floor(delay_seconds*fs);

time_instants = [1:nsamples+delay_samples]./fs;


%% 1) Delayed sinus
F = 4e3; % 4 KHz

% for optimization purposes, we'll compute 2pi*F just once
twopif = 2*pi*F;
bigseno = sin(twopif.*[1:nsamples+delay_samples]./fs);

% delayed sinus
seno1 = bigseno(1:nsamples);
seno2 = bigseno(1+delay_samples:nsamples+delay_samples);


%% 2) Delayed Chirps
F_init = 1e3; % 1 KHz
F_final = 10e3; % 10 KHz

bigchirp = chirp([1:nsamples+delay_samples]./fs, F_init, (nsamples+delay_samples)/fs, F_final);
chirp1 = bigchirp(1:nsamples);
chirp2 = bigchirp(1+delay_samples:nsamples+delay_samples);

%% 3) Delayed White noise
bignoise = randn(1,nsamples+delay_samples);
noise1 = bignoise(1:nsamples);
noise2 = bignoise(1+delay_samples:nsamples+delay_samples);

%% DEBUG: Visualize test signals
if DEBUG
    subplot(1,3,1);
    hold on;
    plot(seno1,'b'); plot(seno2,'r');
    title(['2 sinus at ',int2str(F),'Hz delayed ', int2str(delay_samples),' samples']);
    xlabel('time in samples');

    subplot(1,3,2);
    hold on;
    plot(chirp1,'b'); plot(chirp2, 'r');
    title(['2 chirps delayed ', int2str(delay_samples),' samples']);
    xlabel('time in samples');

    subplot(1,3,3);
    hold on;
    plot(noise1,'b'); plot(noise2, 'r');
    title(['2 noises delayed ', int2str(delay_samples),' samples']);
    xlabel('time in samples');
end

%% Store signals
real_delay_samples = delay_samples;
save('test_signals/test_signals', 'seno1','seno2','chirp1','chirp2','noise1', 'noise2', 'real_delay_samples','fs');
wavwrite(seno1, fs, 'test_signals/seno1.wav')
wavwrite(seno2, fs, 'test_signals/seno2.wav')
wavwrite(noise1, fs, 'test_signals/noise1.wav')
wavwrite(noise2, fs, 'test_signals/noise2.wav')
wavwrite(chirp1, fs, 'test_signals/chirp1.wav')
wavwrite(chirp2, fs, 'test_signals/chirp2.wav')

if ~DEBUG
    clear;
end