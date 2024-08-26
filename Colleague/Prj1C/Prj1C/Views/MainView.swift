import SwiftUI

// The MainView struct is the main entry point for the app's UI, controlling the display of different views.
struct MainView: View {
  
  // State variables to control the display of splash and onboarding screens.
  @State private var showSplash = true // `showSplash` determines whether the splash screen is shown. Defaults to `true`.
  @State private var showOnboarding = true // `showOnboarding` determines whether the onboarding screen is shown. Defaults to `true`.
  
  // The body property defines the UI structure.
  var body: some View {
    if showSplash { // If `showSplash` is true...
      SplashSView(showSplash: $showSplash) // Show the splash screen. The `$showSplash` binding allows the SplashSView to control when it should disappear.
    } else if showOnboarding { // If `showSplash` is false and `showOnboarding` is true...
      OnboardingView(showOnboarding: $showOnboarding) // Show the onboarding screen. The `$showOnboarding` binding allows the OnboardingView to control when it should disappear.
    } else { // If both `showSplash` and `showOnboarding` are false...
      ContentView() // Show the main content of the app.
    }
  }
}

// Set up a preview for the MainView in Xcode's canvas.
#Preview {
  MainView() // Displays the MainView for visual testing.
}

