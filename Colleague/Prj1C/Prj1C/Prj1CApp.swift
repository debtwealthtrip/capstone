import SwiftUI

// The main entry point for the SwiftUI application
@main
struct Prj1CApp: App {  // 'Prj1CApp' is the name of the main application struct. It conforms to the 'App' protocol.
    
    var body: some Scene { // The 'body' property returns a 'Scene' which is the main container for the app's UI content.
        
        WindowGroup { // 'WindowGroup' is a scene type that manages a group of windows in your app. In iOS, it usually represents the app's main window.
            MainView() // The root view of the app is 'MainView'. When the app launches, this view is displayed.
        }
    }
}



