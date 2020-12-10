import gen_model
import time


if __name__ == "__main__":
	port=2082
	for i in range(32041,32050):
		
		for j in range(1,3):
			gen_model.gen_script("Rain_G_"+str(i)+".txt","iter"+str(j),"iridis",port)
			time.sleep(0.5)
			port+=1
