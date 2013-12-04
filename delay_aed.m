function delay = delay_aed(x1,x2,mu)
%function phi = doa_aevd2(x1,x2,dx,N,M,mu,Fs)
%
% direction estimation (azimuth phi) for 1 dim. microphone arrays
% using adaptive eigenvalue decomposition
% version with re-initialization every M samples (to ensure tracking)
% and fast block LMS algorithm
%
% x1,x2   microphone signals
% dx      microphone distance in meters
% N       eigenfilter length (FIR filter)
% M       re-initialization period in samples (must be a multiple of N)  
% mu      step size of adaptive algorithm
% Fs      sampling frquency in Hz (16000, if omitted)
% phi     azimuth in degrees
%
%   Copyright 2006 Gerhard Doblinger, Vienna University of Technology
%   g.doblinger@tuwien.ac.at
%   http://www.nt.tuwien.ac.at/about-us/staff/gerhard-doblinger/
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 2 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program; if not, write to the Free Software
%   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

% ref.: J.Benesty, "Adaptive eigenvalue decomposition algorithm for passive
%       acoustic source localization", J.Acoust.Soc.Am. 107, Jan. 2000,
%       pp. 384-391.






x1 = x1(:);
x2 = x2(:);
Nx = min(length(x1),length(x2));

% set M to a multiple of filter lenght N (required by block processing)

N=96000*25;
Nf = 2*N;                 % FFT length   

% init. eigenvector u

Nh = floor(N/2)+1;
u0_1 = zeros(N,1);
u0_1(Nh) = 1;
U0_1 = fft(u0_1,Nf);
U0_2 = zeros(Nf,1);
U1 = U0_1;
U2 = U0_2;
Nb = ceil((Nx-N));



Sx1 = zeros(Nf,1);        % spectral power used with step size mu
Sx2 = zeros(Nf,1);
alpha = 0.2;              % forgetting factor of spectral power averaging  
alpha1 = 1-alpha;
delay = zeros(Nb,1);
delay_old = 0;
% loop to compute eigenvector u corresponging to zero eigenvalue

k = 0;
mb = 0;
for n = 1:N:Nx-Nf
   mb = mb+1;
   m = n:n+Nf-1;
   X1 = fft(x1(m));
   X2 = fft(x2(m));
   e = real(ifft(U1.*X1+U2.*X2));
   E = fft([zeros(N,1) ; e(N+1:Nf)]);
   Sx1 = alpha*Sx1 + alpha1*abs(X1).^2;
   Sx2 = alpha*Sx2 + alpha1*abs(X2).^2;
   U1 = U1 - (mu ./ (Sx1+eps)) .* conj(X1) .* E;
   U2 = U2 - (mu ./ (Sx2+eps)) .* conj(X2) .* E;
   if mod(mb,1) == 0           % find delay, and restart adaptive filter
      u2 = real(ifft(U2));      % eigenvector to be used to find delay
      u2 = u2(Nh-96000*5:Nh+96000*5-1);
      k = k+1;
      
      [umin,dmin] = min(u2);
      del = dmin-Ndo;
      if umin > doa_threshold   % signal to weak (e.g. speech pauses)
         delay(k) = delay_old;
      else
         delay(k) = del;
         delay_old = del;
      end
      U1 = U0_1;
      U2 = U0_2;
   end
end

delay = delay(1:k);


end
% plot results (phi, final eigenvector)




