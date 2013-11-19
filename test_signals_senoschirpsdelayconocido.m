%
% Crea señales de prueba con un retardo conocido:
% 2 senos y 2 chirps
clear; clc;
DEBUG=1;

%% Init parameters of the signals

fs = 250e3; % sampling rate, the same as in the sensors, 250 KHz
nsamples = 2^8; % length of the sequence

delay_seconds = 50e-6; % 33us.
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
F_final = 40e3; % 10 KHz

chirp1 = chirp(time_instants, F_init, max(time_instants), F_final);
chirp2 = chirp(delayed_time_instants, F_init, max(delayed_time_instants), F_final);

%% DEBUG: Visualize test signals
if DEBUG
    subplot(1,2,1);
    hold on;
    plot(seno1,'b'); plot(seno2,'r');
    title(['2 sinus at ',int2str(F),'Hz delayed ', int2str(delay_samples),' samples']);
    xlabel('time in samples');

    subplot(1,2,2);
    hold on;
    plot(chirp1,'b'); plot(chirp2, 'r');
    title(['2 chirps delayed ', int2str(delay_samples),' samples']);
    xlabel('time in samples');
end

%% no need of aux variables
if ~DEBUG
    clear ('F', 'nsamples', 'delay', 'delay_seconds', 'DEBUG', 'time_instants', 'delayed_time_instants', 'twopif', 'F_final', 'F_init');

%% Store signals
    save('test_signals')
end