//Distint Howie - how4685@pennwest.edu

import SwiftUI
import UserNotifications
import Firebase

struct EventFormView: View {
    @EnvironmentObject var eventStore: EventStore // Accesses the shared EventStore object from the environment
    @StateObject var viewModel: EventFormViewModel // Creates a StateObject to hold the view model
    @Environment(\.dismiss) var dismiss // Allows dismissing the view
    @FocusState private var focus: Bool? // Tracks the focus state of the TextField
    @EnvironmentObject var lnManager: LocalNotificationManager // Accesses the shared LocalNotificationManager object from the environment
    @Environment(\.scenePhase) var scenePhase // Tracks the phase of the scene (e.g., active, background, inactive)
    @State private var notiDate = Date() // Creates a state property to hold the notification date
    
    var body: some View {
        
        NavigationStack { // Wraps the view content in a NavigationStack
            VStack {
                Form { // Creates a form view
                    VStack {
                        Text("Start Date and Time")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .bold()
                    
                    // Displays a date picker for selecting the start date
                    DatePicker(selection: $viewModel.startDate, in: Date()...){
                        
                    }
                    .datePickerStyle(.graphical)
                    
                    
                    VStack {
                        Text("End Date and Time (Optional)")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .bold()
                    
                    DatePicker(selection: $viewModel.endDate, in: Date()...){} // Displays a date picker for selecting the end date
                    
                    TextField("Note", text: $viewModel.note, axis: .vertical)
                        .focused($focus, equals: true) // Displays a text field for entering a note, and focuses on it when the view appears
                    Picker("Event Type", selection: $viewModel.eventType) { // Displays a picker for selecting an event type
                        ForEach(Event.EventType.allCases) {eventType in // Iterates over all cases of the Event.EventType enum
                            Text(eventType.icon + " " + eventType.rawValue.capitalized) // Displays a text label for each event type
                                .tag(eventType) // Tags each event type with its corresponding enum value
                        }
                    }
                    Section(footer:
                                HStack { // Adds a HStack as the footer of the section
                        Spacer() // Adds a spacer to push the button to the right
                        Button {
                            if viewModel.updating { // Checks if the view model is in update mode
                                // update this event
                                let event = Event(id: viewModel.id!,
                                                  eventType: viewModel.eventType,
                                                  startDate: viewModel.startDate,
                                                  endDate: viewModel.endDate,
                                                  note: viewModel.note) // Creates an Event object with the updated data
                                eventStore.update(event) // Updates the event in the event store
                            } else {
                                // create new event
                                let newEvent = Event(eventType: viewModel.eventType,
                                                     startDate: viewModel.startDate,
                                                     endDate: viewModel.endDate,
                                                     note: viewModel.note) // Creates a new Event object with the entered data
                                eventStore.add(newEvent) // Adds the new event to the event store
                                Task{ // Performs a Task (async operation)
                                    let notiDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: viewModel.startDate) // Extracts date components from the notification date
                                    let localNotification = LocalNotification(identifier: newEvent.id,
                                                                              title: "It is time for your event.",
                                                                              body: viewModel.note,
                                                                              dateComponents: notiDateComponents,
                                                                              repeats: false) // Creates a local notification with the extracted date components
                                    await lnManager.schedule(localNotification: localNotification) // Schedules the local notification using the LocalNotificationManager
                                }
                            }
                            dismiss() // Dismisses the view
                        } label: {
                            Text(viewModel.updating ? "Update Event" : "Add Event") // Displays a button label based on whether the view model is in update mode or not
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.incomplete)
                        .disabled(viewModel.comparisonResult) // Disable button if endDate is earlier than startDate
                        Spacer()
                    }
                    ) {
                        EmptyView()
                    }
                }
            }
            .navigationTitle(viewModel.updating ? "Update" : "New Event")
            .onAppear {
                focus = true // Setting focus to true when view appears
            }
            .navigationViewStyle(.stack)
            .task {
                try? await lnManager.requestAuthorization()
            }
            .onChange(of: scenePhase) { newValue in
                if newValue == .active {
                    Task {
                        await lnManager.getCurrentSettings()
                        await lnManager.getPendingRequests()
                    }
                }
            }
        }
    }
}

struct EventFormView_Previews: PreviewProvider {
    static var previews: some View {
        EventFormView(viewModel: EventFormViewModel())
            .environmentObject(EventStore()) // Providing EventStore as an environment object for preview
    }
}
