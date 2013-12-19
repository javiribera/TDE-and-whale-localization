function delay = pruebadelay(x1,x2,mu,iteration)



x1=x1/max(x1);
x2=x2/max(x2);

x1 = x1(:);
x2 = x2(:);
Nx = length(x1);


 
    %initial state of the filter
    u = zeros(2*Nx,1); 
    M=floor(Nx/2);
    u(M+1)=1;
    u(Nx+M+1)=-1;
  x=[x1;x2];
   for m=1:iteration
      
       e=dot(x,u);  %scalar product
       
    u = u-mu*e*x;
    u=u/(norm(u));
       
    end
    
    [maximum,pos] = max(u(1:Nx));
    [maximum2,pos2] = min(u);
    delay = pos2-pos;
    
    
end

