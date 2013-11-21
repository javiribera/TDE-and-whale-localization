function output = clean_signal( input )
%CLEAN_SIGNAL Cleans the signal (preconditioning)
%   This is the function that will pre-process the signal so that detection
%   will be easier: frequency filter, noise-reduction...
    
    %% IN PROGRESS

    Fs=96e3; % 96 KHz

    % notch filter (banda eliminada)
    %  REQUIRES DSP system toolbox
    freq_interference = 20e3; % 20 KHz
    wo = freq_interference/(Fs/2);
    Q = 35; % quality factor
    bw = wo/Q;
    [num_notch,den_notch] = iirnotch(wo,bw);
    
    output = filter(num_notch, den_notch, input);

end

