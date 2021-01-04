import gen_model
import time


if __name__ == "__main__":
	port=2056
	
	gen_model.gen_script("Rain_32040.txt","iter1","iridis",port)
	time.sleep(0.5)
	port+=1

	gen_model.gen_script("Rain_32040.txt","iter2","iridis",port)
	time.sleep(0.5)
	port+=1

    gen_model.gen_script("Rain_32041.txt","iter2","iridis",port)
	time.sleep(0.5)
	port+=1

	gen_model.gen_script("Rain_32043.txt","iter2","iridis",port)
	time.sleep(0.5)
	port+=1

	gen_model.gen_script("Rain_32044.txt","iter2","iridis",port)
	time.sleep(0.5)
	port+=1

	gen_model.gen_script("Rain_32048.txt","iter1","iridis",port)
	time.sleep(0.5)
	port+=1

	gen_model.gen_script("Rain_32049.txt","iter1","iridis",port)
	time.sleep(0.5)
	port+=1
