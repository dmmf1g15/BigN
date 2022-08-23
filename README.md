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

	if using iridis use an interactive session to sign into comsol server
	
5. Put in your university username and password

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
	
Note: this will take a day or two to run. It will generate store_iterate1.mat and store_iterate2.mat, which are data for the uptake for given fertilisation dates

9. See plot_store.m in the repo as an example how to process this data. It can also be processed using python function scipy.io.loadmat
    
10. gen_2050.py is an example of how to run multiple years in one script on iridis4


  
