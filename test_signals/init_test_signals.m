%% Crea señales de prueba con un retardo conocido
clear; clc;

%% 1) Senos separados 'delay' segundos
fs=250000; % sampling rate, the same as in the sensors, 250 KHz
nsamples=2^16;
F=4e3; % 4 KHz
f=F/fs;

% for optimization purposes, we'll compute 2pi*f just once
twopif=2*pi*f;

seno1=sin(twopif.*[1:nsamples]);

delay_seconds = 6.66e-3; % 6.66ms.
delay_samples = delay_seconds*fs;

% delayed sinus
seno2=sin(twopif.*[delay_samples:nsamples+delay_samples]);

%% no need of aux variables
clear ('fs', 'nsamples', 'F', 'f', 'delay', 'delay_seconds', 'delay_samples');