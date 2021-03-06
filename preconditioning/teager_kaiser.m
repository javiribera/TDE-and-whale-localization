function y = teager_kaiser(x)

% y = teager_kaiser(x) applies the Teager-Kaiser energy operator to
% input signal x.

% Source from Thierry Dutoit, Ferran Marquès, 
%   "Applied Signal Processing-A MATLAB-Based Proof of Concept"
%   Springer:New-York, 2009

x=x(:); % Setting x as a column vector

L = length(x);

y = x(2:L-1).^2-x(1:L-2).*x(3:L);
y = [y(1); y; y(L-2)]; % so that lenght(y)=length(x)


% TK should'nt be applied as it is only convenient for impulsive signals, and
% minke whales are not, so TK removes them. Not useful in our case.