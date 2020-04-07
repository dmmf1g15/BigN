function [uppy,gas] = cost_fun(t1,t2,rain_name)


if nargin<2
    t2 = 86400*14*4; % Fertilizer application time 2
    if nargin<1
        t1 = 86400*14; % Fertilizer application time 1
        
    end
end
            

%load('store_iterate.mat');

%l = length(store_iterate);



try
%     [leachy,uppy] = Superblob2_fun(t1, t2);
%     [leachy,uppy] = SuperblobRLD_fun(t1, t2);
    [leachy,uppy,gas] = Superblob3_RLD_Rain_1(t1, t2,rain_name);
    
   % store_iterate{l+1} =[t1,t2,ob]; 
    %save('store_iterate.mat','store_iterate');
catch e
     uppy = 1000;
     gas=nan;
     fprintf(1,'There was an error! The message was:\n%s',e.message);
 end



% ob = leachy/uppy;
% ob = 10-uppy*10+leachy;

% ob = (leachy-2.983)*1000;


end

