function [TDE] = TDOA_AED(x1, x2, max_adaptative, mu)

% |[tdoa, peak] = TDOA_LMS(x1, x2, max_tdoa, mu)| is an implementatin of 
% (Benesty 2000) for source localization. It returns the time difference of
% arrival, in samples, between signals |x1| and |x2|, as a function of
% time, together with the value of the peak found in the estimate of the
% main propagation path for signal 1. This value can be used as a
% confidence value for the TDOA. |max_tdoa| is the maximum TDOA value
% returned and |mu| is the step weight.
%
% See J. Benesty, JASA, Jan. 2000, 107(1),


% make sure we work with column vectors
x1 =x1(:);
x2 =x2(:);
N = length(x1);
% LMS initialization
x1=x1(1:N);
x2=x2(1:N);
g1=zeros(N,1);
g2=zeros(N,1);

T=floor(N/2);
g2(T)=1;
g1(T+N)=1;

g1=g1(:);
g2=g2(:);
u=[g2;-g1];
x=[x1;x2];



% LMS loop
 % preallocated, for speed
for n=1:max_adaptative
    e(n) = u.*x';
    u = u-mu*e(n)*x;
    u = u/norm(u); %forcing ||u|| to 1
end

[H1max,ind1]=max(u(1:N));
[H2min,ind2]=min(u(N+1:2*N));

TDE=ind2-ind1;
    
    
    
end