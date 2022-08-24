function [] = iterate_opt2(rain_name,computer,port)
%to iterate through the 2nd set of fertilisation times
% rain_name is location of rain text file e.g. Rain_31.txt
% computer name is string either 'local' 'duncan' 'roose' or 'iridis'
%port is an int and is the port  number comsol server is using e.g 2036

if strcmp(computer,'local')
    disp('running on local machine...adding comsol mli paths');
elseif strcmp(computer,'duncan')
    disp('running on DuncanCastle...adding comsol mli paths');
    addpath('/usr/local/comsol55install/multiphysics/mli/');
elseif strcmp(computer,'roose')
    disp('running on RooseCastle... adding comsol mli paths');
    addpath('/usr/local/comsol54/multiphysics/mli');
elseif strcmp(computer,'iridis')
     disp('running on Iridis... adding comsol mli paths');
     addpath('/local/software/comsol/5.3a/mli');
elseif strcmp(computer,'iridis5')
     disp('running on Iridis5... adding comsol mli paths');
     addpath('/local/software/comsol/5.5/multiphysics/mli');
else
    error('computer name not valid');
end
mphstart(port)

try
    load('store_iterate2.mat');
    disp('appending uptake saves to previous version of store_iterate2');
catch
    disp('store_iterate2 not saved, saving empty version');
    store_iterate2={};
    save('store_iterate2.mat','store_iterate2');
    
end

opts={};
fvals={};
% 
% t1s=linspace(0,86400*14*3 ,50);
% t2s= linspace(86400*14*4, 86400*14*5, 50);


t1s=linspace(0,86400*14*5 ,30);
t2s= linspace(0, 86400*14*5, 30);

t1snew=linspace(t1s(2)/2,t1s(end)+t1s(2)/2,30);
t2snew=linspace(t2s(2)/2,t2s(end)+(t2s(2))/2,30);

counter=1;
for t1=t1snew
    for t2=t2snew
        if t2<t1
            continue
        end
        load('store_iterate2.mat');
        l = length(store_iterate2);
        
        [uppy,gas] =cost_fun(t1,t2,rain_name);
        fvals{counter}=uppy;
        store_iterate2{l+1}=[t1,t2,uppy,gas];
        save('store_iterate2.mat','store_iterate2');
        counter=counter+1;
    end
end
exit();
