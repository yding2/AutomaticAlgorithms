%This script will use the beginfool() function to find points called for by
%the function of your choosing (quad, quadgk, chebfun, etc.)
%It then fits peaks in between the points it collects
%Just change this script, and you will get a test of beginfool AND peakyfunction

clear all
format long
FILENAME='scriptValues.mat'; %This file name will be passed throughout the script
xsample=[];
save(FILENAME,'xsample')

%%
%---------------Function and Bounds----------
%Pick the function you want to put peaks into.
RegFunc=@(x) 3*ones(size(x)); %cos(10*x)+1
lower=0;
upper=1;

%%
tic
y=@(x) beginfool(x,FILENAME,RegFunc);

%The follwing functions should be the one you want to fool
Original=quad(y,lower,upper)

%%
%-------------Sorting--------------
load(FILENAME);
sortedX=sort(xsample);
save(FILENAME,'sortedX');

%%
%----------------Making the peaky function and plotting-------
x=lower:.005:upper; %The domain of the peaky function
[yplot primeplot dubplot ratio]=peakyfunction(x,FILENAME,RegFunc);

% plot(x,yplot,'r-',x,RegFunc(x),'bo') %Here the peaks are plotted over the original function
subplot(2,3,1), plot(x,yplot,'b-',x,RegFunc(x),'ro'),title('Peaky Function Overlaid'),...
    legend('Peaky Function','Original','Location','EastOutside')

%plots of Derivatives
subplot(2,3,3), plot(x,primeplot),title('First Derivative') %<<<NOTE: Discontinuous
subplot(2,3,5), plot(x,dubplot),title('Second Derivative')  %<<<NOTE: Discontinuous

%%
ratio
%The following function needs to be the one you are tricking
innaccurate=quad(@(x) peakyfunction(x,FILENAME,RegFunc),lower,upper)
%if 'inaccurate' = 'Original' then peakyfunction successfully broke quad, or
%quadgk, etc.
toc




