from selenium import webdriver
import csv

####Opens ITSM####
webpage = (r"https://itsm.providence.org") 
driver = webdriver.Ie()
driver.get(webpage)

###Retrieves info from eights doc###
eightsdoc = csv.reader(open('.\\Copy of Remaining_ITSM_Cody.csv', \
newline=''), delimiter=',')
row1 = next(eightsdoc)

###Runs operations on each line of eights doc###
for row in eightsdoc:  #Stores needed values into variables
	nextRow = next(eightsdoc)
	oldtc = nextRow[6]
	newtc = nextRow[4]
	mac = nextRow[8]
	floor = nextRow[1]
	physicalLocation = nextRow[0]
	room = nextRow[2]
	
	##Go to old TC page
	searchbox = driver.find_element_by_name("searchKey")
	searchbox.send_keys(oldtc)
	goButton = driver.find_element_by_link_text("<span><u>G</u>o</span>")
	goButton.click()
	
	##clicks edit
	editButton = driver.find_element_by_link_text("<span>Ed<u>i</u>t</span>")
	editButton.click()
	
	###Selects retired, sets lifecycle setting, and clicks accept
	selectRetired = Select(driver.find_element_by_id('df_4_1'))
	selectRetired.select_by_visible_text('Retired')
	lifecycle = driver.find_element_by_name("SET.asset_lifecycle_status")
	lifecycle.send_keys("disposed.field")
	accept = driver.find_element_by_link_text("<span><u>A</u>ccept</span>")
	accept.click()
	
	##clicks edit
	editButton = driver.find_element_by_link_text("<span>Ed<u>i</u>t</span>")
	editButton.click()
	
	##Selects Inactive
	selectInactive = Select(driver.find_element_by_id('df_0_3'))
	selectInactive.select_by_visible_text('Inactive')
	
	##Click accept
	accept = driver.find_element_by_link_text("<span><u>A</u>ccept</span>")
	accept.click()
	
	##Go to new TC page
	searchbox = driver.find_element_by_name("searchKey")
	searchbox.send_keys(newtc)
	goButton = driver.find_element_by_link_text("<span><u>G</u>o</span>")
	goButton.click()
	
	##Fills in Mac address, sets TC to active, and sets asset value to yes
	macBox = driver.find_element_by_id("df_1_3")
	searchbox.send_keys(mac)
	selectActive = Select(driver.find_element_by_id('df_4_1'))
	selectActive.select_by_visible_text('Active')
	selectAsset = Select(driver.find_element_by_id('df_0_4'))
	selectAsset.select_by_visible_text('YES')

	##Set lifecycle status to deployed
	lifecycle = driver.find_element_by_name("SET.asset_lifecycle_status")
	lifecycle.send_keys("deployed.field")
	
	##Fills in Location, Physical location, and room
	firstLocTab = driver.find_element_by_id("accrdnHyprlnk2")
	firstLocTab.click()
	secondLocTab = driver.find_element_by_id("tabHyprlnk2_2")
	secondLocTab.click()
	phyLoc = driver.find_element_by_id("df_19_0")
	phyLoc.send_keys(physicalLocation)
	floorLoc = driver.find_element_by_id("df_20_0")
	floorLoc.send_keys(floor)
	roomLoc = driver.find_element_by_id("df_20_1")
	roomLoc.send_keys(room)

	##Click accept
	accept = driver.find_element_by_link_text("<span><u>A</u>ccept</span>")
	accept.click()

##closes eightsdoc
eightsdoc.close()
