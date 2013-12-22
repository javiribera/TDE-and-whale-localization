function output = filter_passband( input )
    %% FILTER PASS-BAND

    filter = build_filter();
    
    output = sosfilt(filter.sosMatrix,input);
    
end