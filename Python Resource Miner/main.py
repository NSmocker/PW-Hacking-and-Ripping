import pyautogui
import time
time_for_path = 10
path_refresh = 10
delta_time = 0.2
destination_point = 0

weypoints_array = [ "690 276","675 262","684 268","675 262","688 272" ]
weypoints_array_time = [15,15,15,15,15]

make_cross_check = True
def Start():
	global time_for_path
	global path_refresh
	global destination_point
	global delta_time
	print("alt_tab time out")
	timeout = 4
	while timeout>0:
		time.sleep(1)
		print("last..."+str(timeout))
		timeout-=1 

	ApplyCurrentWeyPoint()
	
def CrossCheck():
	if make_cross_check==True:
		print("Cross Checking!")
		pyautogui.keyDown("w")
		time.sleep(4)
		pyautogui.keyUp("w")
		CheckPlants()

		pyautogui.keyDown("s")
		time.sleep(4)
		pyautogui.keyUp("s")
		
		pyautogui.keyDown("d")
		time.sleep(4)
		pyautogui.keyUp("d")
		CheckPlants()
		
		pyautogui.keyDown("a")
		time.sleep(4)
		pyautogui.keyUp("a")



		pyautogui.keyDown("a")
		time.sleep(4)
		pyautogui.keyUp("a")
		CheckPlants()
		
		pyautogui.keyDown("d")
		time.sleep(4)
		pyautogui.keyUp("d")

		pyautogui.keyDown("s")
		time.sleep(4)
		pyautogui.keyUp("s")
		CheckPlants()
	
	pyautogui.keyDown("w")
	time.sleep(4)
	pyautogui.keyUp("w")
	
def SetNewWeyPointInGame(new_coords):


	#видаляэмо попередны точки
	print("Seting new point")
	coords = pyautogui.locateCenterOnScreen('img/delete_all_points.png',confidence=0.85,grayscale=True)#взнаэмо координати де писати точку ресурсів
	pyautogui.moveTo(coords)
	pyautogui.click()
	pyautogui.press("enter")

	coords = pyautogui.locateCenterOnScreen('img/coord_setter.png',confidence=0.85,grayscale=True)#взнаэмо координати де писати точку ресурсів
	x,y = coords
	x-=25 #рухаем мишку трохи лівіше
	coords_offsetted = x,y
	pyautogui.moveTo(coords_offsetted)
	pyautogui.click()
	pyautogui.keyDown("backspace")
	time.sleep(0.8)
	pyautogui.keyUp("backspace")
	pyautogui.write(new_coords)
	pyautogui.moveTo(coords)
	pyautogui.click()
	pyautogui.write("current_weypoint")
	pyautogui.press("enter")
	coords = pyautogui.locateCenterOnScreen('img/current_weypoint_img.png',confidence=0.85,grayscale=True)#взнаэмо координати де писати точку ресурсів
	pyautogui.moveTo(coords)
	pyautogui.doubleClick()
	print("Going to new point!")


	


def ApplyCurrentWeyPoint():
	global destination_point
	global time_for_path
	global path_refresh
	global weypoints_array
	global weypoints_array


	print("Path time refreshed")
	print("Goint to "+str(destination_point)+ " point")
	
	SetNewWeyPointInGame(weypoints_array[destination_point]);
	time_for_path = weypoints_array_time[destination_point];


'''
	if destination_point == 1:
		GoToFirstPoint()
		time_for_path = path_refresh
		print("Path time refreshed")
		print("Goint to first point")

	if destination_point == 2:
		GoToSecondPoint()
		time_for_path = path_refresh
		print("Goint to second point")
		print("Path time refreshed")
	if destination_point == 3:
		GoToThirdPoint()
		time_for_path = path_refresh
		print("Goint to second point")
		print("Path time refreshed")
	if destination_point == 4:
		GoToFourPoint()
		time_for_path = path_refresh
		print("Goint to second point")
		print("Path time refreshed")
'''





def GoToFirstPoint():
	coords = pyautogui.locateCenterOnScreen('img/first_point.png',confidence=0.85,grayscale=True)
	pyautogui.moveTo(coords)
	pyautogui.doubleClick()

def GoToSecondPoint():
	coords = pyautogui.locateCenterOnScreen('img/second_point.png',confidence=0.85,grayscale=True)
	pyautogui.moveTo(coords)
	pyautogui.doubleClick()
def GoToThirdPoint():
	coords = pyautogui.locateCenterOnScreen('img/third_point.png',confidence=0.85,grayscale=True)
	pyautogui.moveTo(coords)
	pyautogui.doubleClick()

def GoToFourPoint():
	coords = pyautogui.locateCenterOnScreen('img/four_point.png',confidence=0.85,grayscale=True)
	pyautogui.moveTo(coords)
	pyautogui.doubleClick()





def CheckPlants():
		coords = pyautogui.locateCenterOnScreen('img/plant_1.png',confidence=0.85,grayscale=True)
		if coords!=None:
			pyautogui.keyDown("s")
			time.sleep(0.1)
			pyautogui.keyUp("s")
			print("found plant, stoping...")
			
			Recheck_and_dig()
		coords = pyautogui.locateCenterOnScreen('img/plant_2.png',confidence=0.85,grayscale=True)
		if coords!=None:
			if coords!=None:
				pyautogui.keyDown("s")
				time.sleep(0.1)
				pyautogui.keyUp("s")
				print("found plant, stoping...")
				
				Recheck_and_dig()	
		coords = pyautogui.locateCenterOnScreen('img/plant_3.png',confidence=0.85,grayscale=True)
		if coords!=None:
			if coords!=None:
				pyautogui.keyDown("s")
				time.sleep(0.1)
				pyautogui.keyUp("s")
				print("found plant, stoping...")
				time.sleep(1)
				Recheck_and_dig()	
		coords = pyautogui.locateCenterOnScreen('img/plant_4.png',confidence=0.85,grayscale=True)
		if coords!=None:
			if coords!=None:
				pyautogui.keyDown("s")
				time.sleep(0.1)
				pyautogui.keyUp("s")
				print("found plant, stoping...")
				
				Recheck_and_dig()


def Recheck_and_dig():
	global time_for_path
	global path_refresh
	global destination_point
	global delta_time
	
	time.sleep(3)
	coords = pyautogui.locateCenterOnScreen('img/plant_1.png',confidence=0.85,grayscale=True)
	if coords!=None:
			x,y = coords
			y+=25
			pyautogui.moveTo(x,y)
			pyautogui.click()
			print("Diging 15s")
			time.sleep(15)
			#CrossCheck()
	coords = pyautogui.locateCenterOnScreen('img/plant_2.png',confidence=0.85,grayscale=True)
	if coords!=None:
			x,y = coords
			y+=25
			pyautogui.moveTo(x,y)
			pyautogui.click()
			print("Diging 15s")
			time.sleep(15)
			#CrossCheck()
	coords = pyautogui.locateCenterOnScreen('img/plant_3.png',confidence=0.85,grayscale=True)
	if coords!=None:
			x,y = coords
			y+=25
			pyautogui.moveTo(x,y)
			pyautogui.click()
			print("Diging 15s")
			time.sleep(15)
			#CrossCheck()
	coords = pyautogui.locateCenterOnScreen('img/plant_4.png',confidence=0.85,grayscale=True)
	if coords!=None:
			x,y = coords
			y+=25
			pyautogui.moveTo(x,y)
			pyautogui.click()
			print("Diging 15s")
			time.sleep(15)
			#CrossCheck()
	CrossCheck()
	ApplyCurrentWeyPoint()



def Update():
	global time_for_path
	global path_refresh
	global destination_point
	global weypoints_array
	
	
	global delta_time


	while(time_for_path>0):
		time.sleep(delta_time)
		time_for_path-=delta_time
		CheckPlants()
		print(time_for_path)
		if time_for_path<0.5:
			#upping point
			destination_point+=1
			#clamp point
			if destination_point>len(weypoints_array)-1:
				destination_point=0

			#GoToCurrent Point
			ApplyCurrentWeyPoint()
		

Start()
Update()

	


aa

