//Distint Howie - how4685@pennwest.edu

import SwiftUI

struct StartTabView: View {
    @State private var username = "" // State property for username
    @State private var password = "" // State property for password
    @State private var wrongUsername: Float = 0 // State property for wrong username flag
    @State private var wrongPassword: Float  = 0 // State property for wrong password flag
    @EnvironmentObject var loginStatus: LoginStatus
    @EnvironmentObject var myEvents: EventStore // EnvironmentObject property for EventStore
    
    var body: some View {
        if loginStatus.isLoggedIn {
            TabView{
                //Tab labels with text and image
                LoginView()
                    .tabItem{
                        Label("User", systemImage: "gearshape")
                    }
                ServerView()
                    .tabItem{
                        Label("Schedule", systemImage: "book")
                    }
                EventsListView()
                    .tabItem {
                        Label("Events", systemImage: "list.triangle")
                    }
                EventsCalendarView()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
            }
        } else {
            LoginView()
        }
    }
}

struct StartTabView_Previews: PreviewProvider {
    static var previews: some View {
        StartTabView()
            .environmentObject(EventStore(preview: true)) // Preview of StartTabView with EventStore environment object
    }
}


