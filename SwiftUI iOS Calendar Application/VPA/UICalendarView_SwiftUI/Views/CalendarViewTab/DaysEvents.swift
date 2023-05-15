//Distint Howie - how4685@pennwest.edu

import SwiftUI

struct DaysEventsListView: View {
    @EnvironmentObject var eventStore: EventStore // Observable object for storing events
    @Binding var dateSelected: DateComponents? // Binding for selected date
    @State private var formType: EventFormType? // State variable for managing form type
    
    var body: some View {
        NavigationStack { // Custom navigation stack view
            Group {
                if let dateSelected { // Checking if a date is selected
                    let foundEvents = eventStore.events // Filtering events based on selected date
                        .filter {$0.startDate.startOfDay == dateSelected.date!.startOfDay}//changed date to startDate here
                        //.filter { $0.endDate > Date() } // Filter out events that have already ended
                    /*if !foundEvents.isEmpty { // Check if foundEvents is not empty
                            foundEvents.forEach { event in // Delete each event in the filtered list
                                eventStore.delete(event)
                            }
                        }*/
                    List { // List view for displaying events
                        ForEach(foundEvents) { event in
                            ListViewRow(event: event, formType: $formType) // Custom row view for displaying event details
                                .swipeActions { // Swipe actions for deleting events
                                    Button(role: .destructive) {
                                        eventStore.delete(event) // Delete event on swipe action
                                    } label: {
                                        Image(systemName: "trash") // Trash icon for delete action
                                    }
                                }
                                .sheet(item: $formType) { $0 } // Presenting form view for adding/editing events
                        }
                    }
                }
            }
            .navigationTitle(dateSelected?.date?.formatted(date: .long, time: .omitted) ?? "") // Setting navigation title with selected date
        }
    }
}

struct DaysEventsListView_Previews: PreviewProvider {
    static var dateComponents: DateComponents {
        var dateComponents = Calendar.current.dateComponents(
            [.month,
             .day,
             .year,
             .hour,
             .minute],
            from: Date()) // Creating date components for preview
        dateComponents.timeZone = TimeZone.current
        dateComponents.calendar = Calendar(identifier: .gregorian)
        return dateComponents
    }
    
    static var previews: some View {
        DaysEventsListView(dateSelected: .constant(dateComponents)) // Creating a preview of DaysEventsListView with a constant selected date
            .environmentObject(EventStore(preview: true)) // Injecting preview event store as environment object
    }
}
