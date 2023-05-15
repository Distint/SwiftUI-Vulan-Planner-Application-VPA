#Distint Howie
#Noelle Nieves

#libraries
from guizero import App, PushButton, Text, TextBox, Box, Picture, ListBox, Window
from gpiozero import LED, Buzzer
from signal import pause
from time import sleep
import sys
import requests
import re
from datetime import datetime, date
import pytz
import pyrebase
import webbrowser

#global variables
global loginSuccess
global eventDict
global eventList
global master
global eventsToday

#colors
white = '#ffffff'
red = '#ff0000'
blue = '#add8e6'
pink = '#fddddb'


#ALARM------------------------------------------------
#GPIO outputs
led = LED(4)
buzzer = Buzzer(2)

#Name: dismiss_alarm
#details: turn off led and Buzzer
#Inputs: none
#outputs: none
def dismiss_alarm():
    led.off()                           #Turn off LED
    buzzer.off()                        #Turn off Buzzer
    print("Alarm dissmissed.")

#Name: snooze_alarm
#details: turn off led and Buzzer, wait, turn on LED and Buzzer
#Inputs: none
#outputs: none
def snooze_alarm():
    led.off()                           #Turn off LED
    buzzer.off()                        #Turn off Buzzer
    sleep(5)                            #wait
    led.blink(0.5, 0.5)                 #Blink LED
    buzzer.beep(0.5, 0.5)               #beep buzzer

#Name: alarm
#details: turn on LED and Buzzer in intervals
#Inputs: none
#outputs: none
def alarm():
    led.blink(0.5, 0.5)                 #Blink LED
    buzzer.beep(0.5, 0.5)               #beep buzzer

#Button Commands-------------------------------------------------------
    
#Name: announcementsPage
#details: open url in new tab of default browser
#Inputs: App
#outputs: none
def announcementsPage(app):
    url = "https://calu.edu/news/announcements/"    #url for Pennwest announcements
    webbrowser.open(url, new=0, autoraise=True)     #open url
    return

#Name: popup
#details: open window with event data
#Inputs: value/event from ListBox
#outputs: none
def popup(value):
    #create Window
    popWindow = Window(master, title = value, bg = white, width = 200, height = 200)

    #Loop through event dictionary
    i = 0
    for i in eventDict:
        #format dictionary value to format given by value
        match = eventDict[i][5] + " ("+ eventDict[i][1] + ")"

        #if current event name == value
        if eventDict[i][5] == value:
            index = i                       #store event index

    #format event data for message
    info = "Event Start: " + eventDict[i][1] + " " + eventDict[i][2]  + "\n Event End: " + eventDict[i][3]  + " " + eventDict[i][4] + "\n Event Type: " + eventDict[i][0] 
    #create and display message to window
    message = Text(popWindow, text = info)
    
#Name: eventsPage
#details: open event page with lit of events
#Inputs: App
#outputs: none
def eventsPage(app):
    #destroy current/given App
    app.destroy()

    #create event App
    eventWindow = App(title = "Events", bg = pink)

    #set master to eventWindow to be used in popup()
    global master
    master = eventWindow

    #output message to App for listBox title
    message = Text(eventWindow, text = "Event List:", size = 15)

    #format list for listBox
    i = 0
    tempList = []
    #loop through eventList
    for i in range(len(eventList)):
        #loops through eventDict
        for key in eventDict:
            #if current eventDict name == name if eventList
            if eventDict[key][5] == eventList[i]:
                #append name and date to tempList
                tempList.append(eventList[i] + " (" + eventDict[key][1] + ")")
        
    #create and display listBox to event page
    listbox = ListBox(
        eventWindow,
        tempList,
        command = popup,
        scrollbar = True)
    listbox.bg = white
    listbox.text_size = 15
    
    #create home button
    home = PushButton(eventWindow, align = "bottom", command = eventWindow.destroy, text = "Home", width = 10, height = 3)
    home.bg = white

    #display events page
    eventWindow.display()

#Name: homeWindow_init
#details: create home page
#Inputs: none
#outputs: none
def homeWindow_init():
    #create home page App
    homeWindow = App(title = "Home", bg = white)

    #set master App to home app for refreshData() to use
    global master
    master = homeWindow

    #refresh data
    refreshData()
    #call refreshData every 60 seconds
    homeWindow.repeat(60000, refreshData,) 

    #create right hand box group
    rightBox = Box(homeWindow, height = "fill", align = "right", border = True)

    #create top box group
    topBox = Box(homeWindow, width = "fill", align = "top", border = True)

    #display number of events today message
    message = Text(topBox, size = 20, text = ("\n You have " + str(eventsToday) + " event(s) today.\n"), font = "Times New Roman", color = "red")

    #create close planner button
    close = PushButton(rightBox, align = "top", command = close_gui,args = [homeWindow], text = "Close Planner", width = 10, height = 3 )
    close.bg = red

    #add sapcing with new lines
    message = Text(rightBox, size = 15, text = "\n\n\n", font = "Times New Roman")
    #display caption for alarm buttons
    message = Text(rightBox, size = 15, text = "Alarm\nButtons", font = "Times New Roman")
    #create dismiss button
    dismiss = PushButton(rightBox, command = dismiss_alarm, text = "Dismiss", width = 10, height = 3)
    #create snooze button
    snooze = PushButton(rightBox, command = snooze_alarm, text = "Snooze", width = 10, height = 3)

    #create announcements button
    announcements = PushButton(rightBox, align = "bottom", command = announcementsPage, args = [homeWindow], text = "Announcements", width = 10, height = 3)
    announcements.text_color = blue

    #create main box group
    MainBox = Box(homeWindow, width = "fill", height = 120, border = True)
    #create events button
    events = PushButton(MainBox,command = eventsPage, args = [homeWindow], text = "Click Here to View Events", width = "fill", height = "fill")

    #add CalU logo picture to MainBox
    Logo = Picture(homeWindow, width = 400, height = 200,  image = "calu-logo.png")

    #display homepage
    homeWindow.display()


#LOGIN---------------------------------------------------------------

#Name: login
#details: send credentials to FireBase for confirmation
#Inputs: App, email, password
#outputs: none
def login(app, email, password):
    #initilize Firebase 
    auth = FirebaseConfig()
 
    try:
        # Sign in with email and password
        signin = auth.sign_in_with_email_and_password(email.value, password.value)
        message = Text(app, "Username and password correct.")

        #update login loop condition
        global loginSuccess
        loginSuccess = True

        #destroy login page/App
        app.destroy()

    except:
        #output failure message
       message = Text(app,"Invalid email or password")
    return

#Name: loginWindow_init
#details: create login page/App
#Inputs: none
#outputs: none
def loginWindow_init():
    #create login page
    loginWindow = App(title = "Login Window", width = 900, bg = white)

    #add Vulcan image to login page
    Vulcan = Picture(loginWindow, image = "vulcan", align = "top", height = 200)

    #display welcome message
    message = Text(loginWindow, text = "Welcome to Vulcan Planner Assitant", size = 40, font = "Times New Roman", color = "red")

    #create username/email textBox with title message
    user_message = Text(loginWindow, text = "email:")
    username = TextBox(loginWindow, width = 20)

    #create password textBox with title message
    password_message = Text(loginWindow, text = "password:")
    password = TextBox(loginWindow, width = 20)

    #create login button
    LOGIN = PushButton(loginWindow, command = login, args = [loginWindow, username, password], text = "Login", width = 10, height = 3)

    #display login page/App
    loginWindow.display()

#Name: FirebaseConfig
#details: configure Firebase
#Inputs: none
#outputs: none
def FirebaseConfig():
    # Firebase configuration object containing API keys and other settings
    firebaseConfig = {
      'apiKey': "AIzaSyDiM6vJ558fj8MW2Vm2o3afVi6dHxK6ddE",
      'authDomain': "login-c3e15.firebaseapp.com",
      'projectId': "login-c3e15",
      'storageBucket': "login-c3e15.appspot.com",
      'messagingSenderId': "722990764136",
      'appId': "1:722990764136:web:80028938c2065a791f6bdd",
      'measurementId': "G-BZ59ZD64ZP",
      'databaseURL': "https://login-c3e15.firebaseio.com"  # Firebase Realtime Database URL
    }
    
    # Initialize the Firebase app with the configuration
    firebase = pyrebase.initialize_app(firebaseConfig)
    auth = firebase.auth()  # Create an instance of Firebase authentication

    #return instance of Firebase authentication
    return auth


#DataBase Access Methods------------------------------------

#Name: readEventData
#details: retrieve and sort event data from url
#Inputs: none
#outputs: none
def readEventData():

    #set url and query
    url = 'http://10.2.84.46/php_files/event.php'
    query = {'site': 'test'}

    #get data via request
    res = requests.get(url, query)
    eventData = str(res.content)

    #sort data in qotes and store in list
    eventArray = re.findall('"([^"]*)"', eventData)

    data = []                               #individual event data
    events = []                             #list of events
    mydict = {}                             #dictionary of events and their data
    i = 0
    count = 0

    #loops though data collected in event list
    while i < len(eventArray):
        #recognize start of new event
        if eventArray[i] == "eventType":
            #store event data in temp list
            data.append(eventArray[i+1])
            data.append(eventArray[i+3][:5])
            data.append(eventArray[i+3][6:])
            data.append(eventArray[i+5][:5])
            data.append(eventArray[i+5][6:])
            events.append(eventArray[i+7])
            data.append(eventArray[i+7])
            #add event data to dictionary with unique key
            mydict[count]=data
            #reset temp list
            data = []
        count += 1
        #increment to next event
        i += 10

    #sort dictionary by date
    sortDict = sorted(mydict.items(), key = lambda e: e[1][1])
    finalDict = dict(sortDict)

    #update global variables
    global eventDict
    eventDict = mydict
    global eventList
    eventList = events

#Other Methods---------------------------------------------------------------

#Name: close_gui
#details: end program
#Inputs: App
#outputs: none
def close_gui(app):
    app.destroy()                       #destroy current page
    sys.exit()                          #stop program
    led.off()                           #turn off LED

#Name: dateAndTime
#details: get current date and time
#Inputs: none
#outputs: date, time
def dateAndTime():
    #get todat's date
    today = date.today()
    today = str(date.today())
    t = today[5:]
    
    # Get the timezone object for New York
    tz_NY = pytz.timezone('America/New_York') 

    # Get the current time in New York
    datetime_NY = datetime.now(tz_NY)

    # Format the time as a string
    time = datetime_NY.strftime("%H:%M")

    return t, time

#Name: refreshData
#details: check for new events and alarm triggers
#Inputs: none
#outputs: none
def refreshData():
    print("Refresh")
    #read event data to check for new events
    readEventData()

    #get current date and time
    date, time = dateAndTime()                         

    #seperate current time into hour and minute
    hour = time[:2]
    minute = time[3:]

    #initialoze counters to 0
    i = 0
    global eventsToday
    eventsToday = 0

    #loop through events
    for i in range(len(eventList)):
        #if start date at current dict key == current date
        if eventDict[i][1] == date:
            #increment today's events count
            eventsToday += 1

            #seperate current event's start time into minute and hour
            startTime = eventDict[i][2]
            eventHour = startTime[:2]
            eventMin = startTime[3:]

            #set alarm value for 15 minutes before event
            MinTest = int(eventMin) - 15
            HourTest = eventHour
            if MinTest < 0:
                HourTest = str(int(eventHour)-1)
                MinTest += 60
                
            #if current time == 15 before event
            if (int(hour) == int(HourTest)) and (int(minute) == int(MinTest)) :
                popWindow = Window(master, title = eventDict[i][5], bg = white, width = 200, height = 200)
                info = "Event Start: " + eventDict[i][1] + " " + eventDict[i][2]  + "\n Event End: " + eventDict[i][3]  + " " + eventDict[i][4] + "\n Event Type: " + eventDict[i][0] 
                message = Text(popWindow, text = info)
                alarm()
                break
            #if current time == time of event
            elif (int(hour) == int(eventHour)) and (int(minute) == int(eventMin)):
                popWindow = Window(master, title = eventDict[i][5], bg = white, width = 200, height = 200)
        
                info = "Event Start: " + eventDict[i][1] + " " + eventDict[i][2]  + "\n Event End: " + eventDict[i][3]  + " " + eventDict[i][4] + "\n Event Type: " + eventDict[i][0] 
                message = Text(popWindow, text = info)
                alarm()
                break

#Main--------------------------------------------------------------------------------------------
#Name: main
#details: begin program
#Inputs: none
#outputs: none
def main():
    #read event data
    readEventData()

    #initialize global values
    global loginSuccess
    loginSuccess = False
    global eventsToday
    eventsToday = 0

    #open login page
    loginWindow_init()

    #while login success
    while(loginSuccess):
        homeWindow_init()
    pause()

#start program: call main
main()


