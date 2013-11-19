function estimated_delay = delay_xcorr( input1, input2 )
    % Estima el delay de 2 señales usando la función
    % xcorr de MATLAB y el máximo
    % ¿qué hacemos si hay más de un máximo?
    %  (poco probable en señales reales) de momento he cogido el último
    
    if length(input2) ~= length(input1)
        error('- ¡Both inputs must be the same length to correlate them!');
    end
    cc = xcorr(input1,input2);
    [value, peak_positions] = max(cc);
    peak_position = max(peak_positions);
    estimated_delay = peak_position - length(input1);
    cosa a�adida
end

