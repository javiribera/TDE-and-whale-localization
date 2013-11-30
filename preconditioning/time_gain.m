function output = time_gain( input )

    % TIME GAIN NORMALIZATION
    alpha = 0.9;
    p = 2;
    r = 1; % output overall power level
    aver_level(1) = input(1);
    output(1) = input(1);
    for n=2:length(input)
        aver_level(n) = ( alpha.*((aver_level(n-1)).^p) + (1-alpha).*(abs(input(n)).^p) ).^(1/p);
        output(n) = r .* max((input(n) ./ output(n-1)),eps);
    end
end