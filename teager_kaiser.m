% Source from Thierry Dutoit, Ferran Marquès, 
%   "Applied Signal Processing-A MATLAB-Based Proof of Concept"
%   Springer:New-York, 2009

function y = teager_kaiser(x)

% y = teager_kaiser(x) applies the Teager-Kaiser energy operator to
%   input signal x.
% Useful to clean impulsive signals (such as clicks)
%   from noise and interference

x=x(:); % Setting x as a column vector

L = length(x);

y = x(2:L-1).^2-x(1:L-2).*x(3:L);
y = [y(1); y; y(L-2)]; % so that lenght(y)=length(x)

