function y = teager_kaiser(x)

% y = teager_kaiser(x) applies the Teager-Kaiser energy operator to
% input signal x.

x=x(:); % Setting x as a column vector

L = length(x);

y = x(2:L-1).^2-x(1:L-2).*x(3:L);
y = [y(1); y; y(L-2)]; % so that lenght(y)=length(x)

