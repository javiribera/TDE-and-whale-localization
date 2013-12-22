% INIT_RESULTS script creates a file results.m containing
% the delays for each dataset and combination of delays,
% using GCC-SCOT and PNR with percentile=90 and c=5
% Structure. One variable for each dataset:
% T1,T2...
% |__ event(1)


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
    T1.event(1).delay(3,2).seconds=-1.725;
    T1.event(1).delay(3,4).seconds=-1.575;
    T1.event(1).delay(3,5).seconds=-12.225;
    T1.event(1).delay(3,6).seconds=-9.525;
    T1.event(1).delay(3,7).seconds=-82125;

    T1.event(1).delay(4,1).seconds=-3.975;
    T1.event(1).delay(4,2).seconds=-0.15;
    T1.event(1).delay(4,3).seconds=1.575;
    T1.event(1).delay(4,5).seconds=-10.65;
    T1.event(1).delay(4,6).seconds=-7.95;
    T1.event(1).delay(4,7).seconds=-6.6375;

    T1.event(1).delay(5,1).seconds=6.675;
    T1.event(1).delay(5,2).seconds=10.5;
    T1.event(1).delay(5,3).seconds=12.225;
    T1.event(1).delay(5,4).seconds=10.65;
    T1.event(1).delay(5,6).seconds=2.7;
    T1.event(1).delay(5,7).seconds=4.0125;

    T1.event(1).delay(6,1).seconds=3.975;
    T1.event(1).delay(6,2).seconds=7.8;
    T1.event(1).delay(6,3).seconds=9.525;
    T1.event(1).delay(6,4).seconds=7.95;
    T1.event(1).delay(6,5).seconds=-2.7;
    T1.event(1).delay(6,7).seconds=1.3125;

    T1.event(1).delay(7,1).seconds=2.6625;
    T1.event(1).delay(7,2).seconds=6.4875;
    T1.event(1).delay(7,3).seconds=8.2125;
    T1.event(1).delay(7,4).seconds=6.6375;
    T1.event(1).delay(7,5).seconds=-4.0125;
    T1.event(1).delay(7,6).seconds=-1.3125;

% event 2 (from 8:40 to 9:00)
    T1.event(2).delay(1,2).seconds=3.9;
    T1.event(2).delay(1,3).seconds=5.775;
    T1.event(2).delay(1,4).seconds=4.2375;
    T1.event(2).delay(1,5).seconds=-6.5625;
    T1.event(2).delay(1,6).seconds=-3.7875;
    T1.event(2).delay(1,7).seconds=-2.3625;

    T1.event(2).delay(2,1).seconds=-3.9;
    T1.event(2).delay(2,3).seconds=1.875;
    T1.event(2).delay(2,4).seconds=0.3;
    T1.event(2).delay(2,5).seconds=-10.5;
    T1.event(2).delay(2,6).seconds=-7.725;
    T1.event(2).delay(2,7).seconds=-6.3;

for e=1:length(T1.event)
    for i=1:length(T1.event(e).delay(:,1))
        for j=1:length(T1.event(e).delay(1,:))
            T1.event(e).delay(i,j).samples = T1.event(e).delay(i,j).seconds*T1.Fs;
        end
    end
end

% save variables to 'results/results.m'
currentpath=pwd;
if(strcmp(currentpath(end-6:end),'results'))
    cd ..
end
save('results/results.mat','T1');

clear all;