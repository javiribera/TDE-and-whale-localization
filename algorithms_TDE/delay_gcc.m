function estimated_delay = delay_gcc( input1, input2, method )
    % DELAY_GCC Estimates the delay of 2 signals using the function GCC.m,
    % the weighting filter METHOD and taking the maximum
    
    if length(input1) ~= length(input2)
        error('- ¡Both inputs must be the same length to correlate them!');
    end
    cc = gcc(input1,input2, method);
    [value, peak_positions] = max(cc);
    peak_position = max(peak_positions);
    estimated_delay = peak_position - length(input1);
end