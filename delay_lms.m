function [estimated_delay_samples,h,e] = delay_lms(input1, input2, max_expected, length_signal, beta, handles)
    % Estimates the delay between input1 and input2 using LMS adaptive method
    % using the smoothing parameter provided and max_expected in samples.
    % It also returns the estimate of the filter h that relates both inputs

    global DEBUG
    if ~isempty(DEBUG) && DEBUG
        global h e L stepsize d;  clear h e L stepsize d
    end
    
    N = length(input1);
    if(N ~= length(input2))
        disp('Both inputs must be the same length to use LMS TDE');
        return
    end
    if(~(beta>0 && beta < 1))
        disp('Smoothin parameter (5th one) must be between 0 and 1');
        return
    end
    
    % assure input vectors to be columns and
    % normalize max signal amplitudes to +1
    input1 = input1(:)/max(input1);
    input2 = input2(:)/max(input2);
    
    max_expected = abs(max_expected);
        
    % length of the filter, must be higher than max possible delay
    L = floor(1.5*(max_expected+length_signal));
    %initial state of the filter
    h = zeros(L,1); %h(max_expected+1)=1;
    
    % iterating for each time instant
    est_power = mean(input2(1:L).^2); %initially
    for n = L:N
        x2 = input2(n:-1:n-(L-1)); % the n-th L-length subvector of input2
        
        % adaptively choose stepsize depending on power signal
        est_power = beta*est_power + (1-beta)*input2(n)^2;
        stepsize(n) = (1-beta)/(est_power);
        
        d = h'*x2; % to be a mimic of x1 at this instant
        
        e(n) = input1(n-max_expected) - d; % error of the mimic at this instant
                                           % we delay input1 to be
                                           % able to estimate both
                                           % directions of delay *
        
        h = h + 2*stepsize(n)*e(n)*x2; % update the filter!
        h = h/norm(h); % to avoid numerical instability
        
        % show progress
        if ~isempty(DEBUG) && DEBUG && rem(n,1000) == 0
            disp(['step ', num2str(n) ,' of ', num2str(N),...
                  '  stepsize: ', num2str(stepsize(n))])
            plot(handles.axes_tdoa, h); drawnow
        end
    end
    
    [~,pos] = max(h);
    
    estimated_delay_samples = pos-1-max_expected; % *