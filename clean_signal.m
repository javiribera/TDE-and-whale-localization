function output = clean_signal( input,...
                                preprocessing_methods,...
                                percentile_params,...
                                spectrum_substraction_params,...
                                time_gain_params)
%CLEAN_SIGNAL Cleans the signal (preconditioning)
%   It applies the selected preconditioning methods in folder 'preconditioning'
%   so detection will be then easier.Filters must be passed as strings inside
%   'preprocessing_methods' cell array. Available options are:
%   {remove_mean, banda_pass, time_gain, spectral_substraction,
%   percentile,tk}

    addpath('preconditioning')
    
    output = input;
    
    for i=1:length(preprocessing_methods)
        if (strcmp(preprocessing_methods{i},'remove_mean'))
            output = output - mean(output);
            break
        end
    end
    
    for i=1:length(preprocessing_methods)
        if (strcmp(preprocessing_methods{i},'band_pass'))
            output = filter_passband(output);
            break
        end
    end
    
    for i=1:length(preprocessing_methods)
        if (strcmp(preprocessing_methods{i},'time_gain'))
            output = time_gain(output, time_gain_params);
            break
        end
    end
    
    for i=1:length(preprocessing_methods)
        if (strcmp(preprocessing_methods{i},'spectral_substraction'))
            output = spectralsubstraction(output, spectrum_substraction_params);
            break
        end
    end
    
    for i=1:length(preprocessing_methods)
        if (strcmp(preprocessing_methods{i},'percentile'))
            output = percentile(output, percentile_params);
            break
        end
    end
    
    % TK should'nt be applied as it is only convenient for impulsive signals, and
    % minke whales are not, so TK removes them. Not useful in our case.
    for i=1:length(preprocessing_methods)
        if (strcmp(preprocessing_methods{i},'tk'))
            output = teager_kaiser(output);
        end
    end    
    

end

