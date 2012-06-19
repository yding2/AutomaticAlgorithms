function [y yprime ydubprime ratio]=peakyfunction(x0,filename,functionName)
%This function takes a vector x0 of x values and loads specific x values from
%a file. This is used most easily in the script for fooling function.
p=2;
load(filename)
sortedX=[sortedX((diff(sortedX))~=0); max(sortedX)];%This makes it chebfun compatible
n=length(sortedX)-1;
x=x0(:);
m=length(x);
xx=repmat(x,1,n);
sortedXX=repmat(sortedX',m,1);
yy=1/(size(sortedXX,2)-1)*functionName(xx)+((1-((2*xx-(sortedXX(:,1:n)+sortedXX(:,2:n+1)))./ ...
    (sortedXX(:,2:n+1)-sortedXX(:,1:n))).^2).^p) ...
    .*((xx>=sortedXX(:,1:n))&(xx<=sortedXX(:,2:n+1)));

%%
%------------------First Derivative---------------------
yyprime=(-4*p*(2*xx-(sortedXX(:,1:n)+sortedXX(:,2:n+1))).*(1-(2*xx-(sortedXX(:,1:n)...
    +sortedXX(:,2:n+1))).^2./((-sortedXX(:,1:n)+sortedXX(:,2:n+1))).^2).^(-1+p)...
    ./(-sortedXX(:,1:n)+sortedXX(:,2:n+1)).^2).*((xx>=sortedXX(:,1:n))&(xx<=sortedXX(:,2:n+1)));
primeNorm=norm(yyprime,inf);

%%
%------------------Second Derivative------------------
yydubprime=(16*p*(-1+p)*p*(2*xx-(sortedXX(:,1:n)+sortedXX(:,2:n+1))).^2.*...
    (1-(2*xx-(sortedXX(:,1:n)+sortedXX(:,2:n+1))).^2./(-sortedXX(:,1:n)+sortedXX(:,2:n+1)).^2)...
    .^(-2+p)./(-sortedXX(:,1:n)+sortedXX(:,2:n+1)).^4-8*p*(1-(2*xx-(sortedXX(:,1:n)...
    +sortedXX(:,2:n+1))).^2./(-sortedXX(:,1:n)+sortedXX(:,2:n+1)).^2).^(-1+p)./...
    (-sortedXX(:,1:n)+sortedXX(:,2:n+1)).^2).*((xx>=sortedXX(:,1:n))&(xx<=sortedXX(:,2:n+1)));
dubNorm=norm(yydubprime,inf);

%%
%------------------Output--------------------
ratio=dubNorm/primeNorm;
yprime=sum(yyprime,2);
yprime=reshape(yprime,size(x0));
ydubprime=sum(yydubprime,2);
ydubprime=reshape(ydubprime,size(x0));
y=sum(yy,2);
y=reshape(y,size(x0));
