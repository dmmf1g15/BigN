clear all
close all
load('store_iterate1.mat');
load('store_iterate2.mat');
%load('store_iterate3.mat');
%load('store_iterate4.mat');
store_iterate = {store_iterate1{:},store_iterate2{:}};
%store_iterate = {store_iterate3{:},store_iterate4{:}};

l = length(store_iterate);
x=zeros(1,l);
y=zeros(1,l);
z=zeros(1,l);
g=zeros(1,l);



for i=1:l
    if (store_iterate{i}(3)<=1005 && store_iterate{i}(3)>=995) || (store_iterate{i}(3)<0)
        x(i)=store_iterate{i}(1);
        y(i)=store_iterate{i}(2);
        z(i)=nan;
        g(i)=nan;
        
    else
        x(i)=store_iterate{i}(1);
        y(i)=store_iterate{i}(2);
        z(i)=store_iterate{i}(3);
        g(i)=store_iterate{i}(4);
    end
end



%z(z>20)=nan; %%TO sort out the really big ones

x=x(~isnan(z));
y=y(~isnan(z));
z=z(~isnan(z));
g=g(~isnan(z));
z=smooth(z,1); 
    



figure()
[X,Y] = meshgrid(linspace(min(x),max(x),length(unique(x))), linspace(min(y),max(y),length(unique(y))));

%create contour plot
figure()
colormap jet
surf(X,Y,griddata(x,y,z,X,Y))
shading interp
%mark original data points
%hold on;scatter(x,y,'o');hold off
figure()

contourf(linspace(min(x)/60/60/24,max(x)/60/60/24,length(unique(x))),linspace(min(y)/60/60/24,max(y)/60/60/24,length(unique(y))),griddata(x,y,z,X,Y,'linear'),15)
colormap jet
colorbar

figure()
contourf(linspace(min(x)/60/60/24,max(x)/60/60/24,length(unique(x))),linspace(min(y)/60/60/24,max(y)/60/60/24,length(unique(y))),griddata(x,y,g,X,Y,'linear'),15)
colormap jet
colorbar

%colormap jet
%imagesc(linspace(min(x),max(x),length(unique(x))),linspace(min(y),max(y),length(unique(y))),griddata(x,y,z,X,Y))