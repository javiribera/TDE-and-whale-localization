% INIT_RESULTS script creates a file results.m containing
% the delays for each dataset and combination of delays,
% using GCC-SCOT and PNR with percentile=90 and c=5

T1 = struct();

T1.Fs = 96e3; %sampling frequency

for i=1:7
    T1.event(1).delay(i,i).seconds=0; T1.event(1).delay(i,i).samples=0;
end

% event 1 (from 2:20 to 2:45)
    T1.event(1).delay(1,2).seconds=3.825;
    T1.event(1).delay(1,3).seconds=5.55;
    T1.event(1).delay(1,4).seconds=3.975;
    T1.event(1).delay(1,5).seconds=-6.675;
    T1.event(1).delay(1,6).seconds=-3.975;
    T1.event(1).delay(1,7).seconds=-2.6625;

    T1.event(1).delay(2,1).seconds=-3.825;
    T1.event(1).delay(2,3).seconds=1.725;
    T1.event(1).delay(2,4).seconds=0.15;
    T1.event(1).delay(2,5).seconds=-10.5;
    T1.event(1).delay(2,6).seconds=-7.8;
    T1.event(1).delay(2,7).seconds=-6.4875;

    T1.event(1).delay(3,1).seconds=-5.55;
    T1.event(1).delay(3,3).seconds=-1.725;
    T1.event(1).delay(3,4).seconds=-1.575;
    T1.event(1).delay(3,5).seconds=-12.225;
    T1.event(1).delay(3,6).seconds=-9.525;
    T1.event(1).delay(3,7).seconds=-82125;

% T1.delay(:,:).samples = T1.delay(:,:).seconds*T1.Fs;

% save variables to 'results/results.m'
currentpath=pwd;
if(strcmp(currentpath(end-6:end),'results'))
    cd ..
end
save('results/results.mat','T1');

clear all;