//Distint Howie - how4685@pennwest.edu

import SwiftUI
import WebKit

struct EventsCalendarView: View {
    @EnvironmentObject var eventStore: EventStore // EnvironmentObject for accessing event store data
    @State private var dateSelected: DateComponents? // State variable for selected date in the calendar
    @State private var displayEvents = false // State variable for displaying events list
    @State private var formType: EventFormType? // State variable for event form type
    @State private var showWebView = false // State variable for showing the web view

    var body: some View {
        NavigationStack { // Custom navigation stack view
            ScrollView { // Scroll view to wrap around the calendar view and image
                CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), // CalendarView with eventStore, dateSelected, and displayEvents as parameters
                             eventStore: eventStore,
                             dateSelected: $dateSelected,
                             displayEvents: $displayEvents)
                //Image that can be displayed in the calendar view
                /*Image("vp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .cornerRadius(10)*/
            }
            .toolbar { // Toolbar for buttons
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { // Button for adding new event
                        formType = .new
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.medium)
                    }
                }
                // Button for announcements and call the AnnouncementsView as a sheet
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Announcements") { // Button for displaying announcements
                        showWebView = true
                    }
                    .sheet(isPresented: $showWebView){ // Show AnnouncementsView as a sheet
                        AnnouncementsView()
                    }
                }
            }
            .sheet(item: $formType) { $0 } // Show event form based on formType
            .sheet(isPresented: $displayEvents) { // Show events list as a sheet
                DaysEventsListView(dateSelected: $dateSelected)
                    .presentationDetents([.medium, .large])
            }
            .navigationTitle("Calendar View") // Set navigation title
        }
    }
}

struct EventsCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        EventsCalendarView()
            .environmentObject(EventStore(preview: true)) // Preview with EventStore as environment object
    }
}

// View that creates and displays the announcements page
struct AnnouncementsView: View {
    @State private var showWebView = false // State variable for showing the web view
    private let urlString: String = "https://calu.edu/news/announcements/" // URL string for announcements webpage

    var body: some View {
        VStack(spacing: 40) {
            // Normal WebView to display the announcements webpage
            WebView(url: URL(string: urlString)!).frame(height: 600.0)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.3), radius: 20.0, x: 5, y: 5)

            Link(destination: URL(string: "https://calu.edu/news/announcements/")!){
                Text("Open In Browser")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            // Button to present WebView as a bottom sheet
            Button {
                showWebView.toggle()
            } label: {
                Text("FullScreen")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showWebView) { // Show WebView as a sheet
                WebView(url: URL(string: urlString)!)
            }
            Spacer()

        }.padding()
    }
}

// WebView Struct
struct WebView: UIViewRepresentable {
    
    var url: URL // URL of the web page to be displayed
    
    // Create and return a WKWebView instance as the UIViewRepresentable's UIView
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    // Update the WKWebView with the provided URL request
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}


