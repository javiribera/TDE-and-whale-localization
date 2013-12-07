echo on

% SPEAKER LOCALIZATION AND TRACKING DEMO
%
% speaker moves from 90° (broadside) to 0° (endfire), back to 90°, and
% finally to 180°
%
% show usage of program doa_aevd2.m
%
% (c) G. Doblinger, Vienna University of Technology, 2006
% g.doblinger@tuwien.ac.at
% http://www.nt.tuwien.ac.at/about-us/staff/gerhard-doblinger/
%

           % load microphone array geometry

[X1] = wavread('27Apr09_174921_026_p1.wav');
[X2,Fs] = wavread('27Apr09_174921_026_p2.wav');
% load microphone signals
       sensor1 = [6566 -9617 -4500];
    sensor2 = [6635 -2132 -4500];
    sensor3 = [6520 5240 -4650];
    sensor4 = [6865 12844 -4750];
    sensor5 = [-6163 -12402 -4600];
    sensor6 = [-6183 -4874 -4650];
    sensor7 = [-6129 9784 -4750];

    sensors = [ sensor1;
            sensor2;
            sensor3;
            sensor4;
            sensor5;
            sensor6;
            sensor7;
          ];
    
    distance = sqrt( sum((sensors(sensorA,:)-sensors(sensorB,:)).^2) );                      % (8 channel recording, 16 kHz sampling frequency)

d = distance;   % distance of the outmost two microphones

doa_aevd2(X1,X2,d,1512,6500,0.01,Fs);    % AEVD2 algorithm, PLEASE WAIT...
