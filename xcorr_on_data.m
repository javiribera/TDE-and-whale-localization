[data1,Fs]=audioread('data/T1/27Apr09_174921_026_p1.wav');
[data2,Fs]=audioread('data/T1/27Apr09_174921_026_p2.wav');

% seconds of interest
Tmin = 39; Tmax = 44;
data1 = data1(Tmin*Fs :  Tmax*Fs);
data2 = data2(Tmin*Fs :  Tmax*Fs);

frame_length=100; % samples to be correlated
n_frames = floor(length(data1)/frame_length);
% slice the data in frames and compute de delay of each one
for i=1:n_frames
    delay(i) = delay_xcorr(data1(1+(i-1)*frame_length : i*frame_length),...
                           data2(1+(i-1)*frame_length : i*frame_length) );
end

% play that funky music
soundsc(data1, Fs)

% evolution of the estimated delay
plot(delay)