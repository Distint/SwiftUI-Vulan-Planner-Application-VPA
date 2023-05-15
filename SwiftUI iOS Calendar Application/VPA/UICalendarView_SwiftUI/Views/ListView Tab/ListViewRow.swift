//Distint Howie - how4685@pennwest.edu

import SwiftUI

struct ListViewRow: View {
    @EnvironmentObject var lnManager: LocalNotificationManager //EnvironmentObject property for LocalNotificationManager
    @Environment(\.scenePhase) var scenePhase // Environment property for scene phase
    let event: Event // Event object passed as a parameter
    @Binding var formType: EventFormType? // Binding for form type
    var body: some View {
        HStack { // Horizontal stack view
            VStack(alignment: .leading) { // Vertical stack view with leading alignment
                
                HStack { // Horizontal stack view
                    Text(event.eventType.icon) // Text view displaying event type icon
                        .font(.system(size: 40)) // Font size for event type icon
                    Text(event.note) // Text view displaying event note
                }
                
                // Check if startDate and endDate have the same date and time
                if Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: event.startDate) == Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: event.endDate) {
                    Text(
                        event.startDate.formatted(date: .abbreviated, time: .shortened) // Text view displaying formatted startDate with abbreviated date and shortened time
                    )
                }
                
                // Check if startDate and endDate have the same day but different times
                else if Calendar.current.dateComponents([.year, .month, .day], from: event.startDate) == Calendar.current.dateComponents([.year, .month, .day], from: event.endDate){
                    Text(
                        event.startDate.formatted(date: .abbreviated, time: .shortened)
                    )
                    Text("To: ")
                        .bold() // Bold text view displaying "To:"
                    Text(event.endDate.formatted(date: .omitted, time: .shortened))
                }
                
                else {
                    // Check if startDate and endDate are on different days
                    Text(
                        event.startDate.formatted(date: .abbreviated, time: .shortened)
                    )
                    Text("To: ")
                        .bold() // Bold text view displaying "To:"
                    Text(event.endDate.formatted(date: .abbreviated, time: .shortened))
                }

            }
            Spacer() // Spacer to push buttons to the trailing edge
            Button {
                formType = .update(event) // Button for updating event with form type as parameter
            } label: {
                Text("Edit") // Text view displaying "Edit"
            }
            .buttonStyle(.bordered) // Bordered button style
        }
    }
}

 /*struct ListViewRow_Previews: PreviewProvider {
     static let event = Event(eventType: .social, date: Date(), note: "Let's party")
    static var previews: some View {
        ListViewRow(event: event, formType: .constant(.new))
    }
 }*/

