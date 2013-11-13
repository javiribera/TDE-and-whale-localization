function init_test_signals()
    % Crea señales de prueba con un retardo conocido:
    % 2 senos y 2 chirps
    %
    DEBUG=1;

    %% Init parameters of the signals

    fs = 96e3; % sampling rate, the same as in the sensors, 96 KHz
    nsamples = 2^16; % length of the sequence


    delay_seconds = 100e-6; % 100us. Low, as a large delay is undetectable in pure sinus
    delay_samples = floor(delay_seconds*fs);
    
    time_instants = [1:nsamples]./fs;
    delayed_time_instants = [1+delay_samples:nsamples+delay_samples]./fs;


    %% 1) Delayed sinus
    F = 4e3; % 4 KHz

    % for optimization purposes, we'll compute 2pi*F just once
    twopif = 2*pi*F;

    % delayed sinus
    seno1 = sin(twopif.*time_instants);
    seno2 = sin(twopif.*delayed_time_instants);


    %% 2) Delayed Chirps
    F_init = 4e3; % 4 KHz
    F_final = 10e3; % 10 KHz

    chirp1 = chirp(time_instants, F_init, max(time_instants), F_final);
    chirp2 = chirp(delayed_time_instants, F_init, max(delayed_time_instants), F_final);

    %% DEBUG: Visualize test signals
    if DEBUG
        subplot(1,2,1);
        hold on;
        plot(seno1(1:10000),'b'); plot(seno2(1:10000),'r');
        title(['2 sinus at ',int2str(F),'Hz delayed ', int2str(delay_samples),' samples']);
        xlabel('time in samples');

        subplot(1,2,2);
        hold on;
        plot(chirp1(1:10000),'b'); plot(chirp2(1:10000), 'r');
        title(['2 chirps delayed ', int2str(delay_samples),' samples']);
        xlabel('time in samples');
    end

    %% Store signals
    if ~DEBUG
        save('test_signals', 'seno1','seno2','chirp1','chirp2','delay_samples','fs');
        clear;
    end
end
