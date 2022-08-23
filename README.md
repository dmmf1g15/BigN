This folder is for running the Big N model on roosecastle, duncancastle, iridis4 or local windows machines
Requires COMSOL MATLAB and Python to run. Make sure in gen_model.py the correct version of Comsol server is being started and the corret comsol mlis
are being added to the path in matlab. Edit this after you pull it to make sure your machine has this version of comsol

How to run guide:
1. make a directory to put the files named BigN 
	
	mkdir BigN

2. move into the directory
	
	cd BigN

3. Clone the git repository into the directory
	
	git clone https://github.com/dmmf1g15/BigN.git

4. If you haven't done so already, run the COMSOL server associated with the macine you're using
	
	if you're using duncancastle, run the following:
	
		comsol-5.5.0 server
	if you're using roosecstle, run the following:
	
		comsol-5.4.0 server

	if you're using iridis.... I don't know
	
5. Put in your university username and password and it will provide the port number (usually 2036)

6. ctrl c to get back to the main command line

7. cd BigN

8. To run the simulations for a given rainfall event enter: python gen_model.py Rain_XX.txt YY ZZ AAA, where:

	XX is the rainfall pattern number, 
	YY is iter1/iter2/all
	ZZ is the machine roosecastle/duncancastle/iridis
	AAAA is the server port number usually 2036

For example, if you're on roose castle and you want to run the Rain_32, you would enter:

	python gen_model.py Rain_32.txt all roose 2036

After running this, the program will copy the relevant matlab functions into a new folder ../Rain_G_32/ (use the name of your Rainfall txt file)
	
Note: this iwill take a day or two to run. It will generate store_iterate1.mat and store_iterate2.mat, which are data for the uptake for given fertilisation dates

9. See plot_store.m in the repo as an example how to process this data. It can also be processed using python function scipy.io.loadmat
    
10. gen_2050.py is an example of how to run multiple years in one script on iridis4


___________________original text___________________________________
1) clone this repositry: >>git clone https://github.com/dmmf1g15/BigN.git
2) Add your Rainfall data to the Rainfall folder as a txt file. col1: day in second. col2 daily rainfall in mm. Look in rainfall folder for examples
3) run the gen_model.py function to generate the model and run the model on comsol via matlab. >>python gen_model.py Rain_32.txt all roose 2036. (Before running make sure you have logged into the comsol server in the past. >>comsol-VERSION server. Give Username and password)
  This will:
  
  -copy the relevant matlab functions into a new folder ../Rain_G_32/ (use the name of your Rainfall txt file)
  
  -the 'all' refers to which days to try fertilising on. 'all' will try every possible day pair with 1.2 day resolution <70days
  
  -'roose' refers which computer you are on. The options are 'roose' 'duncan' 'local' and 'iridis' (iridis4 only just now!). The 'local' option will make a     folder but not run the model. You can go in and run the 'iterate_all.m' file in your local matlab after connecting to a comsol server.
  
  -2036 is the port to run the comsol server on. If running multiple instances on one machine use different ports.
  
  -This will take a day or two to run. It will generate store_iterate1.mat and store_iterate2.mat
  
4) See plot_store.m in the repo as an example how to process this data. It can also be processed using python function scipy.io.loadmat
5) gen_2050.py is an example of how to run multiple years in one script on iridis4
  
  
