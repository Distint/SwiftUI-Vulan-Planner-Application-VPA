//SwiftUI-Vulan-Planner-Application (VPA)
Vulcan Planner gives users the ability to create, edit, and delete events, that can be categorized with a variety of different event types, ensuring seamless organization and efficiency in managing busy schedules. What sets the app apart is the unique integration with student course schedules and university announcements, making it a must-have tool for university students. Once logged in, the app automatically loads the user’s course schedule, eliminating the need for manual input and saving time. The announcements are made available for viewing by a button that creates a web-view that can be seen inside the app. Therefore, users can stay up to date with important updates, news, and events happening on campus. To enhance the user experience, when users are away from their iOS devices, a Raspberry Pi acts as a notification hub, providing reminders for upcoming events. Users can log in to the Raspberry Pi to view their events and announcements. With our iOS calendar application and Raspberry Pi notification hub, we believe it can help improve student efficiency and productivity.


//Mobile app can not be compiled on windows machine because xcode is not avaible on windows
//Solutions - Use virtual machine or remote desktop to a mac machine
To run the mobile application:

1. Download Xcode latest version from MacOS store
2. unzip VPA.zip and put files into a new xcode project

*The firebase library is going to need to be downloaded through terminal by cocoapods*

3. Run this command in terminal:
	$ sudo gem install cocoapods
	press return and enter password
	now run the command pod init
	
*This will add a file called "Podfile" to the project space*

4. inside of that file, highlight everything and replace with this:
		# Uncomment the next line to define a global platform for your project
		# platform :ios, '9.0'

	target 'UICalendarView_SwiftUI' do
  		# Comment the next line if you don't want to use dynamic frameworks
  		use_frameworks!
  		#use_modular_headers!

 		# Pods for UICalendarView_SwiftUI
      	pod 'Firebase/Auth'
      	#pod 'Firebase/Analytics', :modular_headers => false
      	#pod 'Firebase/Firestore', :modular_headers => false
      	pod 'Firebase/Analytics'
      	pod 'Firebase/Firestore'

	end

5. Run 'pod install' in terminal to download the firebase lib

*A new project file will now be in the project folder called 'UICalendarView_SwiftUI.xcworkspace'
it will be white instead of blue*

6. Open that file, run and compile the project

7. For python program run in any python interpreter
