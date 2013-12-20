function estimated_delay = delay_xcorr( input1, input2 )
    % DELAY_XCORR Estimates the delay between 2 signals
    % using built-in MATLAB function xcorr and taking the maximum
    
    if length(input2) ~= length(input1)
        error('- ¡Both inputs must be the same length to correlate them!');
    end
    cc = xcorr(input1,input2);
    [value, peak_positions] = max(cc);
    peak_position = max(peak_positions);
    estimated_delay = peak_position - length(input1);
end

% Instead of detecting the maximum of the cross correlation, we could have
% also find the minimum of the average-magnitude-difference funtion (AMDF),
% which is equivalent statisticaly. But this is likely to not detect very
% well, as neither does the xcorr.
