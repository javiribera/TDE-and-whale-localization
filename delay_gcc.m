function estimated_delay = delay_gcc( input1, input2, method )
    % Estima el delay de 2 señales usando la función
    % gcc de Dutroit y el máximo
    % ¿qué hacemos si hay más de un máximo?
    %  (poco probable en señales reales) de momento he cogido el último
    
    if length(input1) ~= length(input2)
        error('- ¡Both inputs must be the same length to correlate them!');
    end
    cc = gcc(input1,input2, method);
    [value, peak_positions] = max(cc);
    peak_position = max(peak_positions);
    estimated_delay = peak_position - length(input1);
end