//Distint Howie - how4685@pennwest.edu

import SwiftUI

struct CalendarView: UIViewRepresentable {
    let interval: DateInterval // Date interval to display in the calendar
    @ObservedObject var eventStore: EventStore // ObservedObject for managing events
    @Binding var dateSelected: DateComponents? // Binding for the selected date
    @Binding var displayEvents: Bool // Binding for toggling event display
    
    // Create the UIView for the calendar
    func makeUIView(context: Context) -> some UICalendarView {
        let view = UICalendarView()
        view.delegate = context.coordinator
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = dateSelection
        return view
    }
    
    // Create the coordinator for the calendar
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, eventStore: _eventStore)
    }
    
    // Update the UIView for the calendar
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let changedEvent = eventStore.changedEvent {
            uiView.reloadDecorations(forDateComponents: [changedEvent.dateComponents], animated: true)
            eventStore.changedEvent = nil
        }
        
        if let movedEvent = eventStore.movedEvent {
            uiView.reloadDecorations(forDateComponents: [movedEvent.dateComponents], animated: true)
            eventStore.movedEvent = nil
        }
    }
    
    // Coordinator class for managing calendar delegate methods
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarView
        @ObservedObject var eventStore: EventStore
        
        // Initialize the coordinator with parent and eventStore
        init(parent: CalendarView, eventStore: ObservedObject<EventStore>) {
            self.parent = parent
            self._eventStore = eventStore
        }
        
        // Delegate method for providing decorations for calendar dates
        @MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let foundEvents = eventStore.events
                .filter {$0.startDate.startOfDay == dateComponents.date?.startOfDay}//changed date to startdate here
            if foundEvents.isEmpty { return nil }
            
            if foundEvents.count > 1 {
                return .image(UIImage(systemName: "doc.on.doc.fill"), color: .red, size: .large)
            }
            let singleEvent = foundEvents.first!
            return .customView {
                let icon = UILabel()
                icon.text = singleEvent.eventType.icon
                return icon
            }
        }
        
        // Delegate method for handling date selection in the calendar
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            parent.dateSelected = dateComponents
            guard let dateComponents else { return }
            let foundEvents = eventStore.events
                .filter {$0.startDate.startOfDay == dateComponents.date?.startOfDay}//changed date to startdate here
            if !foundEvents.isEmpty {
                parent.displayEvents.toggle()
            }
        }
        
        // Delegate method for determining if a date can be selected in the calendar
        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }
    }
}
