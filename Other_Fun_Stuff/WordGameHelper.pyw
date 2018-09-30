from tkinter import *
import subprocess

window = Tk()
window.title("Word Game Helper... you naughty cheater you")

def getrandos():
	resultbox.delete(1.0, END)
	randos = content.get()
	gamewordarray = []

	letters = randos.upper()
	gamewordarray.extend(letters)
	gamewordarraycount = len(gamewordarray) #original count

	searchfile = open(".\\dictionary.txt", "r")
	for dictword in searchfile:
		dictwordarray = []
		dictwordarray.extend(dictword)
		dictwordarray.pop(-1)
		dictwordarray = [x.upper() for x in dictwordarray]    
		dictwordarraycount = len(dictwordarray) #count of dict
		gamewordarraycopy = gamewordarray[:]
		#checks if game word is less than or equal to dictionary word 
		if dictwordarraycount <= gamewordarraycount :
			#searches dictionary words to see if game letters are contained
			for letter in dictwordarray:            
				if letter in gamewordarraycopy: #pops matching letters from both arrays
					gamewordarraycopy.remove(letter)
				newcount = len(gamewordarraycopy)
		if dictwordarraycount < 3:
			continue
		elif (gamewordarraycount - newcount == dictwordarraycount):
			resultbox.insert(END, dictword)

#allows <return> event to process on entry box	
def key(event):
    getrandos()

#top menu
menu=Menu(window)
window.config(menu=menu, bg="#0004ff")

#title
Title = Label(window, text="Word Game Helper!", font=("courier new", 60), fg="#00f929", bg="black", relief="raised", bd=10)
Title.grid(row=0, columnspan=2)

#label for letter entry
content = StringVar()
enterlabel = Label(window, text="Enter your letters here:", font=("courier new", 16), fg="black", bg="#a3fff2")
enterlabel.grid(row=1, column=0, sticky="E")

#Entry for random letters
entrybox = Entry(window, justify=LEFT, width=27, font=("courier new", 17), textvariable=content)
entrybox.bind("<Return>", key)
entrybox.grid(row=1, column=1, sticky="W")

#button to retrieve results
getresults = Button(window, text="Get Results!", font=("counrier new", 14), bd=6, padx=-10, command=getrandos)
getresults.grid(row=2, columnspan=2, pady=4)

#textbox to display results
resultbox = Text(window, bg="white", width=30, height=20, font=("courier new", 16))
resultbox.grid(row=3, columnspan=2)

scrollb = Scrollbar(window, command=resultbox.yview)
scrollb.grid(row=3, column=1, sticky='ns')
resultbox['yscrollcommand'] = scrollb.set

window.mainloop()
