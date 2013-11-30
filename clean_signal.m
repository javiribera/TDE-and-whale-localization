function output = clean_signal( input,...
                                preprocessing_methods,...
                                percentile_params,...
                                spectrum_substraction_params)
%CLEAN_SIGNAL Cleans the signal (preconditioning)
%   It applies the selected preconditioning methods in this folder so detection
%   will be easier: passband filtering, percentile, spectral substraction
%   and time gain.

    addpath('preconditioning')
    
    output = input;
    
    for i=1:length(preprocessing_methods)
        if (strcmp(preprocessing_methods{i},'band_pass'))
            output = filter_passband(output);
        end
    end
    
    for i=1:length(preprocessing_methods)
        if (strcmp(preprocessing_methods{i},'time_gain'))
            output = time_gain(output);
        end
    end
    
    for i=1:length(preprocessing_methods)
        if (strcmp(preprocessing_methods{i},'spectral_substraction'))
            output = spectralsubstraction(output, spectrum_substraction_params);
        end
    end
    
    for i=1:length(preprocessing_methods)
        if (strcmp(preprocessing_methods{i},'percentile'))
            output = percentile(output, percentile_params);
        end
    end
    
    
    % TK should'nt be applied as it is only convenient for impulsive signals, and
    % minke whales are not, so TK removes them (not useful in our case)
    for i=1:length(preprocessing_methods)
        if (strcmp(preprocessing_methods{i},'tk'))
            output = teager_kaiser(output);
        end
    end    
    

end

