//Distint Howie

import SwiftUI
import Firebase

// Define the main entry point of the SwiftUI app
@main
struct AppEntry: App {
    @StateObject var myEvents = EventStore(preview: true) // Create an instance of `EventStore` as an observed object with `preview` set to `true`
    @StateObject var lnManager = LocalNotificationManager() // Create an instance of `LocalNotificationManager` as an observed object
    @StateObject private var loginStatus = LoginStatus()
    
    // Initialize Firebase in the AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // Define the main window group scene
        WindowGroup {
            StartTabView() // Use `StartTabView` as the root view of the window
                .environmentObject(myEvents) // Inject the `myEvents` observed object as an environment object to be accessible by child views
                .environmentObject(lnManager) // Inject the `lnManager` observed object as an environment object to be accessible by child views
                .environmentObject(loginStatus) // Inject the `loginStatus` observed object as an environment object to be accessible by child views
        }
    }
    
    class AppDelegate: UIResponder, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.
            FirebaseApp.configure()
            return true
        }
        
        // MARK: UISceneSession Lifecycle
        
        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            // Called when a new scene session is being created.
            // Use this method to select a configuration to create the new scene with.
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        }
        
        func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
            // Called when the user discards a scene session.
            // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        }
    }
}

