function output = clean_signal( input )
%CLEAN_SIGNAL Cleans the signal (preconditioning)
%   This is the function that will pre-process the signal so that detection
%   will be easier: frequency filter, noise-reduction...
    
    %% IN PROGRESS

    Fs=96e3; % 96 KHz
    
        % hydrophone signal is not zero mean :0
        signal1 = input - mean(input);

        % notch filter (banda eliminada)
        %  REQUIRES DSP system toolbox
        freq_interference = 20e3; % 20 KHz
        wo = freq_interference/(Fs/2);
        Q = 2; % quality factor
        bw = wo/Q;
        [num_notch,den_notch] = iirnotch(wo,bw);    
        signal2 = filter(num_notch, den_notch, signal1);

        % Low-pass filter
        %  REQUIRES Signal Processing toolbox
        Fc    = 500; % Hz
        fc = Fc / (Fs/2);
        N = 200;   % FIR filter order
        Hf = fdesign.lowpass('N,Fc',N,fc);
        Hd = design(Hf,'window','window',{@chebwin,50},'SystemObject',true);
        % hfvt = fvtool(Hd,'Color','White'); DEBUG: visualize filter
        signal3=filter(Hd.Numerator,1,signal2);
        
    output=signal3;


end

