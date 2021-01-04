import gen_model
import time


if __name__ == "__main__":
	port=2090
	for i in range(32053,32060):
		
		for j in range(1,3):
			gen_model.gen_script("Rain_"+str(i)+".txt","iter"+str(j),"iridis",port)
			time.sleep(0.5)
			port+=1
