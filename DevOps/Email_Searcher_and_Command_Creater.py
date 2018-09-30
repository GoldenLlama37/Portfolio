######################################################################################
#Before running this, be sure to do the following:
#1.) Your "Builds Expected to Start..." email is in your main inbox and not another subfolder
#2.) Verify the "Variables to change" below the imported modules just below reflect your paths
#3.) Right now there must be 3 SPOrel forks (New, Old, Retired) or else this script will not work
###################################################################################### 

import win32com.client
import re
import time
import datetime

#########Retrieve's week's date for email subject header and log's output path
today = datetime.date.today()
idx = (today.weekday() + 1) % 7
sun = today - datetime.timedelta(idx)
currentWeek = '{:%m/%d/%Y}'.format(sun)

################################Variables to change, VERIFY ME######################################
logOutputPath = "C:\\Users\\v-coyou\\Desktop\\SPOrel builds started\\" + str(today) + " SPOrel start commands.txt"
#########################################################################################


outlook = win32com.client.Dispatch("Outlook.Application").GetNamespace("MAPI")
inbox = outlook.GetDefaultFolder(6) 
messages = inbox.Items

body_content = []

print("Searching email...")

for message in messages:
	regExSubject = re.match(r'Builds Expected to Start - Week of ' + str(currentWeek), message.Subject, re.I)
	regExSubject2 = re.match(r'Re: Builds Expected to Start - Week of ' + str(currentWeek), message.Subject, re.I)
	if regExSubject != None:
		body_content.append(message.body)
	elif regExSubject2 != None:
		body_content.append(message.body)
body_content = str(body_content)

buildRegex = re.findall('16\.0\.\d{4}\.12\d{2}', body_content)
filteredList = list(set(buildRegex))

print("Search finished")

for item in filteredList:
	removeRegex = re.match(r'16\.0\.\d{4}\.1200', item)#16.0.7701.1200
	lastFour = int(item[-4:])
	if removeRegex != None:
		filteredList.remove(item)
	elif (lastFour == 1200):
		filteredList.remove(item)

for item in filteredList:
	removeRegex = re.match(r'16\.0\.\d{4}\.1200', item)#16.0.7701.1200
	lastFour = int(item[-4:])
	if removeRegex != None:
		filteredList.remove(item)
	elif (lastFour == 1200):
		filteredList.remove(item)


thirdSets = []

for item in filteredList:
	thirdSet = item[5:9]
	if thirdSet not in thirdSets:
		thirdSets.append(thirdSet)

thirdSets = sorted(thirdSets)
thirdSets = thirdSets[-3:]

firstOctet = thirdSets[-3] #lowest number
secondOctet = thirdSets[-2]
thirdOctet = thirdSets[-1] #highest number

firstList = []
secondList = []
thirdList = []

####Gets Prod-retired
for item in filteredList:
	if item[5:9] == firstOctet:
		firstList.append(item)
firstList = sorted(firstList)
prodRetired = firstList[-1]

####Gets Prod-old
for item in filteredList:
	if item[5:9] == secondOctet:
		secondList.append(item)
secondList = sorted(secondList)
prodOld = secondList[-1]

####Gets Prod-New
for item in filteredList:
	if item[5:9] == thirdOctet:
		thirdList.append(item)
thirdList = sorted(thirdList)
prodNew = thirdList[-1]
###Todays starting builds:
###Prod-Retired = prodRetired
###Prod-Old = prodOld
###Prod-New = prodNew
#print(body_content)
#16.0.7611.1215)\r\n\r\nScheduled on O16PipePool34 
retiredPipePoolRegexPattern = re.escape(str(prodRetired[-9:])) + r'\)\\r\\n\\r\\nScheduled on O16PipePool[0-3][0-6]' 
string = str(re.search(retiredPipePoolRegexPattern, body_content))
retirePipePoolmoreRegexPat = r'O16PipePool[0-3][0-6]'
retiredsPipePool = re.search(retirePipePoolmoreRegexPat, string).group()#####Pipe pool for Retired

oldPipePoolRegexPattern = re.escape(str(prodOld[-9:])) + r'\)\\r\\n\\r\\nScheduled on O16PipePool[0-3][0-6]' 
string = str(re.search(oldPipePoolRegexPattern, body_content))
oldPipePoolmoreRegexPat = r'O16PipePool[0-3][0-6]'
oldsPipePool = re.search(oldPipePoolmoreRegexPat, string).group()####Pipe pool for old

newPipePoolRegexPattern = re.escape(str(prodNew[-9:])) + r'\)\\r\\n\\r\\nScheduled on O16PipePool[0-3][0-6]' 
print(newPipePoolRegexPattern)
string = str(re.search(newPipePoolRegexPattern, body_content))
print(string)
newPipePoolmoreRegexPat = r'O16PipePool[0-3][0-6]'
print(newPipePoolmoreRegexPat)
newsPipePool = re.search(newPipePoolmoreRegexPat, string).group()####Pipe pool for new
print(newsPipePool)
###########GETS INTEGRATORS AND BRANCHES######################
NewInt = ""
NewBranch = ""
if newsPipePool == "O16PipePool06":
	NewInt = "OBLDINT106"
	NewBranch = "devmainlab06override_sporel"
elif newsPipePool == "O16PipePool02":
	NewInt = "OBLDINT102"
	NewBranch = "devmainlab02override_sporel"
elif newsPipePool == "O16PipePool34":
	NewInt = "OBLDINT304"
	NewBranch = "devmainlab34override_sporel"

OldInt = ""
OldBranch = ""
if oldsPipePool == "O16PipePool06":
	oldInt = "OBLDINT106"
	oldBranch = "devmainlab06override_sporel"
elif oldsPipePool == "O16PipePool02":
	oldInt = "OBLDINT102"
	oldBranch = "devmainlab02override_sporel"
elif oldsPipePool == "O16PipePool34":
	oldInt = "OBLDINT304"
	oldBranch = "devmainlab34override_sporel"

retiredInt = ""
retiredBranch = ""
if retiredsPipePool == "O16PipePool06":
	retiredInt = "OBLDINT106"
	retiredBranch = "devmainlab06override_sporel"
elif retiredsPipePool == "O16PipePool02":
	retiredInt = "OBLDINT102"
	retiredBranch = "devmainlab02override_sporel"
elif retiredsPipePool == "O16PipePool34":
	retiredInt = "OBLDINT304"
	retiredBranch = "devmainlab34override_sporel"

#################CONSOLE OUTPUT######################
print("\n")
print("Prod-New = " + str(prodNew))
print(newsPipePool)
print(NewInt)
print(NewBranch)
print("\n")
print("Prod-Old = " + str(prodOld))
print(oldsPipePool)
print(oldInt)
print(oldBranch)
print("\n")
print("Prod-Retired = " + str(prodRetired))
print(retiredsPipePool)
print(retiredInt)
print(retiredBranch)
print("\n")

###################LOGGING###################
outputLog = open(logOutputPath, 'w')
############ProdNew Output
outputLog.write("Build " + str(prodNew) + "\n\n")
outputLog.write("Run on: " + str(NewInt)+ "\n")
outputLog.write("Branch: " + str(NewBranch)+ "\n")
outputLog.write("Pipe Pool: " + str(newsPipePool) + "\n\n")
outputLog.write("Integrator commands:\n")
outputLog.write("set PROMPT=[(v-coyou)$D:$T:$P]"+ "\n")
outputLog.write("\\\\obuildlab\\shares\\Published\\ApplyFix\\Live\\ApplyFixWrapper\\RunApplyFix.bat -mode summarize -build " + str(prodNew)+ "\n")
outputLog.write("sd.exe opened ..."+ "\n")
outputLog.write("sd.exe sync //depot/" + str(NewBranch) + "/sporel/..."+ "\n")
outputLog.write("sd.exe opened ..."+ "\n")
outputLog.write("qtstore.exe -tb\n\n")
outputLog.write("Applyfix commands:\n")
outputLog.write("On OA-ApplyFix-03 server, in the command prompt, navigate to the folder C:\OfficeAF\dev\otools\lab\\bin."+ "\n")
outputLog.write("ApplyFix.exe -mode apply -bt ps -branch " + str(NewBranch) + "/sporel -minimalclient\n\n")
outputLog.write("5:00 Check\n\n\n")
outputLog.write("7:00 Check\n\n\n")
outputLog.write("************************************************************************")
############ProdOld Output
outputLog.write("\nBuild " + str(prodOld) + "\n\n")
outputLog.write("Run on: " + str(oldInt)+ "\n")
outputLog.write("Branch: " + str(oldBranch)+ "\n")
outputLog.write("Pipe Pool: " + str(oldsPipePool) + "\n\n")
outputLog.write("Integrator commands:\n")
outputLog.write("set PROMPT=[(v-coyou)$D:$T:$P]"+ "\n")
outputLog.write("\\\\obuildlab\shares\\Published\\ApplyFix\\Live\\ApplyFixWrapper\\RunApplyFix.bat -mode summarize -build " + str(prodOld)+ "\n")
outputLog.write("sd.exe opened ..."+ "\n")
outputLog.write("sd.exe sync //depot/" + str(oldBranch) + "/sporel/..."+ "\n")
outputLog.write("sd.exe opened ..."+ "\n")
outputLog.write("qtstore.exe -tb\n\n")
outputLog.write("Applyfix commands:\n")
outputLog.write("On OA-ApplyFix-03 server, in the command prompt, navigate to the folder C:\OfficeAF\dev\otools\lab\\bin."+ "\n")
outputLog.write("ApplyFix.exe -mode apply -bt ps -branch " + str(oldBranch) + "/sporel -minimalclient\n\n")
outputLog.write("5:00 Check\n\n\n")
outputLog.write("7:00 Check\n\n\n")
outputLog.write("************************************************************************\n")
#################ProdRetired Output
outputLog.write("Build " + str(prodRetired) + "\n\n")
outputLog.write("Run on: " + str(retiredInt)+ "\n")
outputLog.write("Branch: " + str(retiredBranch)+ "\n")
outputLog.write("Pipe Pool: " + str(retiredsPipePool) + "\n\n")
outputLog.write("Integrator commands:\n")
outputLog.write("set PROMPT=[(v-coyou)$D:$T:$P]"+ "\n")
outputLog.write("\\\\obuildlab\shares\\Published\\ApplyFix\\Live\\ApplyFixWrapper\\RunApplyFix.bat -mode summarize -build " + str(prodRetired)+ "\n")
outputLog.write("sd.exe opened ..."+ "\n")
outputLog.write("sd.exe sync //depot/" + str(retiredBranch) + "/sporel/..."+ "\n")
outputLog.write("sd.exe opened ..."+ "\n")
outputLog.write("qtstore.exe -tb\n\n")
outputLog.write("Applyfix commands:\n")
outputLog.write("On OA-ApplyFix-03 server, in the command prompt, navigate to the folder C:\OfficeAF\dev\otools\lab\\bin."+ "\n")
outputLog.write("ApplyFix.exe -mode apply -bt ps -branch " + str(retiredBranch) + "/sporel -minimalclient\n\n")
outputLog.write("5:00 Check\n\n\n")
outputLog.write("7:00 Check\n\n\n")
outputLog.write("************************************************************************\n")

outputLog.close()

##################Terminate program

input("\nClose window to finish")
