function output = clean_signal( input )
%CLEAN_SIGNAL Cleans the signal (preconditioning)
%   It applies all the preconditioning methods in this folder so detection
%   will be easier: passband filtering, percentile, spectral substraction
%   and time gain.

    output = percentile(...                 % 4. Percentile noise removal
        spectralsubstraction(...            % 3. Spectral substraction
            time_gain(...                   % 2. Time Gain normalization
                filter_passband(input))));  % 1. Pass band filtering
            
    % We don't apply TK as it is only convenient for impulsive signals, and
    % minke whales are not, so TK removes them (not useful in our case)

end

