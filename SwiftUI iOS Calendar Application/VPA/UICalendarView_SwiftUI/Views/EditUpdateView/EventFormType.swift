//Distint Howie - how4685@pennwest.edu

import SwiftUI

// Define an enum called `EventFormType` that conforms to `Identifiable` and `View`
enum EventFormType: Identifiable, View {
    // Define cases for new event and update event
    case new
    case update(Event)
    
    // Implement the `id` computed property required by `Identifiable`
    var id: String {
        switch self {
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }

    // Implement the `body` computed property required by `View`
    var body: some View {
        // Use a switch statement to return a `EventFormView` with appropriate `EventFormViewModel`
        switch self {
        case .new:
            return EventFormView(viewModel: EventFormViewModel())
        case .update(let event):
            return EventFormView(viewModel: EventFormViewModel(event))
        }
    }
}

