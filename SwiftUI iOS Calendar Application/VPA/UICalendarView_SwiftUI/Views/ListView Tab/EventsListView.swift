//Distint Howie - how4685@pennwest.edu

import SwiftUI

struct EventsListView: View {
    @EnvironmentObject var myEvents: EventStore // EnvironmentObject property for EventStore
    @State private var formType: EventFormType? // State property for form type
    @State private var showSettingsView = false // State variable for showing the web view
    @EnvironmentObject var lnManager: LocalNotificationManager // Accesses the shared LocalNotificationManager object from the environment
    
    
    func deleteEvent(_ event: Event) {
        deleteNotifications(for: event) // Delete notifications associated with the event
        myEvents.delete(event) // Delete the event
    }
    
    func deleteNotifications(for event: Event) {
        // Get the notification requests associated with the event
        let requests = lnManager.pendingRequests.filter { request in
            request.content.userInfo["event_id"] as? String == event.id
        }
        // Remove the notification requests
        requests.forEach { request in
            lnManager.removeRequest(withIdentifier: request.identifier)
        }
    }
    
    var body: some View {
        NavigationStack { // NavigationStack container view
            List { // List view
                
                // ForEach loop iterating through events, sorted by startDate
                ForEach(myEvents.events
                    .filter { $0.endDate > Date() } // Filter out events that have already ended
                    .sorted { $0.startDate < $1.startDate }) { event in // Sort events by start date
                        ListViewRow(event: event, formType: $formType)
                            .swipeActions {
                                Button(role: .destructive) {
                                    myEvents.delete(event)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                    }
                
            }
            .navigationTitle("Calendar Events") // Navigation title
            .sheet(item: $formType) { $0 } // Sheet presentation with form type as the item
            .toolbar { // Toolbar for navigation bar
                ToolbarItem(placement: .navigationBarTrailing) { // Toolbar item at the trailing edge
                    Button {
                        formType = .new // Button for creating a new event with new form type
                    } label: {
                        Image(systemName: "plus.circle.fill") // Plus circle icon as the label
                            .imageScale(.medium)
                    }
                    
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Notifications") { // Button for displaying announcements
                        showSettingsView = true
                    }
                    .sheet(isPresented: $showSettingsView){ // Show AnnouncementsView as a sheet
                        if lnManager.isGranted {
                            Text("Pending Notifications")
                                .font(.system(size: 35))
                                .fontWeight(.bold)
                            List {
                                ForEach(lnManager.pendingRequests, id: \.identifier) { request in
                                    VStack(alignment: .leading) {
                                        Text(request.content.body)
                                        HStack {
                                            //Text(request.identifier)
                                            //  .font(.caption)
                                            // .foregroundColor(.secondary)
                                        }
                                    }
                                    .swipeActions {
                                        Button("Delete", role: .destructive) {
                                            lnManager.removeRequest(withIdentifier: request.identifier)
                                        }
                                    }
                                }
                            }
                        } else {//if notification not enables prompt user to enable them
                            Text("To see pending notifications, enable them in iOS settings.")
                                .font(.system(size: 35))
                                .fontWeight(.bold)
                            Button("Enable Notifications") {
                                lnManager.openSettings()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
        }
    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView()
            .environmentObject(EventStore(preview: true)) // Preview of EventsListView with EventStore environment object
    }
}

