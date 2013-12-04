function estimated_delay_samples = delay_lms(input1, input2, max_expected, stepsize)
    % Estimates the delay between input1 and input2 using LMS adaptive method
    % using the stepsize provided and max_expected in samples.
%     clear; clc
%     init_test_signals()
%     load 'test_signals.mat';
%     input1=noise1; input2=noise2;
%     max_expected = ceil(1.5*real_delay_samples);
%     stepsize=0.01;
global h e L;
    h=0;e=0; L=0;
    N = length(input1);
    if(N ~= length(input2))
        disp('Both inputs must be the same length to use LMS TDE');
        return
    end
    
    % assure input vectors to be columns and
    % normalize max signal amplitudes to +1 and
    input1 = input1(:)/max(input1);
    input2 = input2(:)/max(input2);
    
    % length of the filter, must be higher than max possible delay
    L = 2*max_expected;
    %initial state of the filter
    h = zeros(L,1); h(max_expected+1)=0;
    
    % iterating for each time instant
    for n=L:N
        x2 = input2(n:-1:n-(L-1)); % the n-th L-length subvector of input2
        d = h'*x2; % desired to be a mimic of x1 at this instant
        
        e(n) = input1(n) - d; % error of the mimic at this instant
        
        h = h + 2*stepsize*e(n)*x2; % update the filter!
    end
    
    [maximum pos] = max(h);
    
    estimated_delay_samples = pos-1;