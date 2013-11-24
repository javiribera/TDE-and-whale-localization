function output = clean_signal( input )
%CLEAN_SIGNAL Cleans the signal (preconditioning)
%   This is the function that will pre-process the signal so that detection
%   will be easier: frequency filter, noise-reduction...
    
    %% IN PROGRESS

    Fs=96e3; % 96 KHz
    
        % 1. hydrophone signal is not zero mean :0
        signal1 = input - mean(input);
        % signal1= input;

        % 2. Just looking for minke whales
        % Band-pass filter
        % Generated by MATLAB(R) 8.1 and the DSP System Toolbox 8.4.
        % Generated on: 22-Nov-2013 14:26:55
        % Chebyshev Type I Bandpass filter designed using FDESIGN.BANDPASS.
        % All frequency values are in Hz.
        Fs = 96000;  % Sampling Frequency
        N      = 50;     % Order
        Fpass1 = 1e3;   % First Passband Frequency
        Fpass2 = 12e3;  % Second Passband Frequency
        Apass  = 1;      % Passband Ripple (dB)
        % Construct an FDESIGN object and call its CHEBY1 method.
        h  = fdesign.bandpass('N,Fp1,Fp2,Ap', N, Fpass1, Fpass2, Apass, Fs);
        Hd = design(h, 'cheby1');
        signal2 = sosfilt(Hd.sosMatrix,signal1);
        % DEBUG: visualize the frequency response of the filter
        % fvtool(Hd);
        % signal2=signal1;
        
        % 3. Time-domain gain normalization
        alpha = 0.9;
        p = 2;
        r = 1; % output overall power level
        aver_level(1) = signal2(1);
        signal3(1) = signal2(1);
        for n=2:length(signal2)
            aver_level(n) = ( alpha*(aver_level(n-1))^p + (1-alpha)*abs(signal2(n))^p )^(1/p);
            signal3(n) = r * signal2(n) / aver_level(n-1);
        end
        
        
        %% 4. Percentile noise substraction
        % NOT TESTED
%         for i=1:M
%             for k=1:7
%                 percentil=prctile(S(i,k),90);
%                 Sestimada(i,k)=max(0,S(i,k)-N);
%                 N2=prctile(S2(i,k),90);
%                 Sestimada2(i,k)=max(0,S2(i,k)-N);
%             end
%         end
        
    output=signal3;


end

