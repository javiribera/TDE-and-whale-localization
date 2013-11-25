function output = time_gain( input )

    
     %% 3 TIME GAIN NORMALIZATION
        % 3. TIME GAIN NORMALIZATION
        alpha = 0.9;
        p = 2;
        r = 1; % output overall power level
        aver_level(1) = input(1);
        signal3(1) = input(1);
        for n=2:length(input)
            aver_level(n) = ( alpha.*((aver_level(n-1)).^p) + (1-alpha).*(abs(input(n)).^p) ).^(1/p);
            signal3(n) = r .* max((input(n) ./ aver_level(n-1)),eps);
        end
         output=signal3;
end