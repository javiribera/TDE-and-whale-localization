function [tdoa, peak] =AED(x1, x2, max_tdoa)

% |[tdoa, peak] = TDOA_LMS(x1, x2, max_tdoa, mu)| is an implementatin of 
% (Benesty 2000) for source localization. It returns the time difference of
% arrival, in samples, between signals |x1| and |x2|, as a function of
% time, together with the value of the peak found in the estimate of the
% main propagation path for signal 1. This value can be used as a
% confidence value for the TDOA. |max_tdoa| is the maximum TDOA value
% returned and |mu| is the step weight.
%
% See J. Benesty, JASA, Jan. 2000, 107(1),

% Normalizing max signal amplitudes to +1
x1=x1/max(x1);
x2=x2/max(x2);

% make sure we work with column vectors
x1 =x1(:);
x2 =x2(:);

% LMS initialization
x1c = zeros(max_tdoa,1);
x2c = zeros(max_tdoa,1);
u = zeros(2*max_tdoa,1);
u(max_tdoa/2) = 1;
N = length(x1);
e = zeros(1,N);
tdoa = zeros(1,N);
peak = zeros(1,N);

% LMS loop
tdoa=zeros(1,N); % preallocated, for speed
for n=1:N
    
    x1c = [x1(n);x1c(1:end-1)];
    x2c = [x2(n);x2c(1:end-1)];
    R=cov(x1c,x2c);
    EIG=eig(R);
    lambda1=max(EIG);
    lambda2=min(EIG);
    mu=2/(lambda1+lambda2);
    x = [x1c;x2c];
    
    e(n) = u'*x;
    
    u = u-mu*e(n)*x;
    u(max_tdoa/2) = 1; %forcing g2 to an impulse response at max_tdoa/2
    u = u/norm(u); %forcing ||u|| to 1
    
    [peak(n),ind] = min(u(max_tdoa+1:end));
    peak(n)=-peak(n); % find the value of the (positive) impulse
    tdoa(n) = ind-max_tdoa/2;
    
    % Screen output
    if rem(n, 10000) == 0
       fprintf('TDOA_LMS: processing sample %3d/%3d\n', n,N)
    end
end
end
