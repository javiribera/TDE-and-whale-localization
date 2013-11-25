function estimated_delay_samples = delay_lms(input1, input2)
    % Estimates the delay between samples using LMS adaptive method
    
    step = 0.5; % step size
    
    % we want input vectors to be columns
    input1=input1(:)'';
    input2=input2(:)'';
    
    if(length(input1) ~= length(input2))
        disp('Both inputs must be the same length to use LMS TDE');
        return
    end
    
    % desired length of the input and filter
    M = min(3,length(input1));
    n_iterations = floor(length(input1)/M);
    %initial state of the filter
    w = [1 ; zeros(M-1,1)];
    
    % iterating for each time instant
    for n=M:length(input1)
        x1 = flipud(input1(n-(M-1) : n)); % the n-th M-length input1 vector
        x2 = flipud(input2(n-(M-1) : n)); % the n-th M-length input2 vector
        d = w'*x2; % desired to be a mimic of x1 at this instatnt
        
        e = x1(M) - d; % error of the mimic at this instant
        
        w = w - step*e*conj(x2); %update the filter!
    end
        