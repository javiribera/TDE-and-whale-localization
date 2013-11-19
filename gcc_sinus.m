
load 'test_signals.mat';
DEBUG=1;


figure
    hold on
    figure(1)
    plot(seno1,'b'); plot(seno2,'r');
    figure(2)
    
    plot(chirp1,'b'); plot(chirp2,'r');


    %% TDE on sinus using gcc and the maximum peak

gcc_mode = 'cc'; 
M=length(seno1);
gcc_sinus = gcc_marques_nuevo(seno1,seno2,gcc_mode);
[val,ind]=max(gcc_sinus);
delay_gcorrsinus= ind-M

cc_sinus=xcorr(seno1,seno2);
[val,ind]=max(cc_sinus);
delay_xcorrsinus= ind-M

if DEBUG
    figure
    hold on
    subplot(1,2,1)
    plot(gcc_sinus); title('gcc between sinus');
    
    subplot(1,2,2)
    plot(cc_sinus); title('cc between sinus');
end

%% TDE on chirp using xcorr and the maximum peak
cc_chirp = xcorr(chirp1,chirp2);
M=length(chirp1);

[val,ind]=max(cc_chirp);
delay_ccchirp= ind-M

gcc_chirp = gcc_marques_nuevo(chirp1,chirp2,gcc_mode);
[val,ind]=max(gcc_chirp);
delay_gccorrchirp= ind-M

if DEBUG
    figure;
    subplot(1,1,1)
    plot(cc_chirp); title('xcorr between chirps');
    figure(2);
    plot(gcc_chirp); title('gcc between chirps');
end
%% DEBUG: no need of aux. variables
if ~DEBUG
    clear('DEBUG','peak*','xcorr*','gcc_mode')
end