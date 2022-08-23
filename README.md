This folder is for running the Big N model on roosecastle, duncancastle, iridis4 or local windows machines
Requires COMSOL MATLAB and Python to run. Make sure in gen_model.py the correct version of Comsol server is being started and the corret comsol mlis
are being added to the path in matlab. Edit this after you pull it to make sure your machine has this version of comsol

How to run guide:
1) clone this repositry: >>git clone https://github.com/dmmf1g15/BigN.git
2) Add your Rainfall data to the Rainfall folder as a txt file. col1: day in second. col2 daily rainfall in mm. Look in rainfall folder for examples
3) run the gen_model.py function to generate the model and run the model on comsol via matlab. >>python gen_model.py Rain_32.txt all roose 2036 
  This will: 
  -copy the relevant matlab functions into a new folder ../Rain_G_32/ (use the name of your Rainfall txt file)
  -the 'all' refers to which days to try fertilising on. 'all' will try every possible day pair with 1.2 day resolution <70days
  -'roose' refers which computer you are on. The options are 'roose' 'duncan' 'local' and 'iridis' (iridis4 only just now!). The 'local' option will make a     folder but not run the model. You can go in and run the 'iterate_all.m' file in your local matlab after connecting to a comsol server.
  -2036 is the port to run the comsol server on. If running multiple instances on one machine use different ports.
  -This will take a day or two to run. It will generate store_iterate1.mat and store_iterate2.mat
  
4) See plot_store.m in the repo as an example how to process this data. It can also be processed using python function scipy.io.loadmat
  
  
