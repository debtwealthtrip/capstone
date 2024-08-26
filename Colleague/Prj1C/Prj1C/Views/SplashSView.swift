import SwiftUI

// Define a view for the splash screen
struct SplashSView: View {
  // A binding variable to control the visibility of the splash screen from a parent view.
  @Binding var showSplash: Bool
  // A state variable to control the animation of the splash screen elements.
  @State private var animate = false
  
  var body: some View {
    // The main content of the splash screen, organized in a vertical stack (VStack).
    VStack {
      // Display the splash screen title text.
      Text("One Picture, Infinite Words!")
        .font(.largeTitle) // Set the font size to large title.
        .fontWeight(.bold) // Make the text bold.
        .foregroundColor(.blue) // Set the text color to blue.
        .opacity(animate ? 1 : 0) // Control the opacity: fully visible if `animate` is true, otherwise invisible.
        .scaleEffect(animate ? 1 : 0.8) // Control the scale: normal size if `animate` is true, otherwise slightly smaller.
        .animation(.easeInOut(duration: 1.0), value: animate) // Apply a smooth animation with ease in and out transition over 1 second.
    }
    .onAppear {
      // Trigger the animation when the splash screen appears.
      animate = true
      
      // Schedule a task to hide the splash screen after 2 seconds.
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        self.showSplash = false
      }
    }
  }
}

// Wrapper view for preview
struct SplashSView_Previews: PreviewProvider {
  static var previews: some View {
    // Use `StatefulPreviewWrapper` to provide a preview of `SplashSView` with a binding.
    StatefulPreviewWrapper(true) { SplashSView(showSplash: $0) }
  }
}

// Helper struct to provide stateful preview
struct StatefulPreviewWrapper<Content: View>: View {
  // State to manage the value passed to the previewed view.
  @State private var value: Bool
  // Content closure that accepts a binding to the state value and returns a view.
  let content: (Binding<Bool>) -> Content
  
  // Initializer that sets up the state value and content closure.
  init(_ initialValue: Bool, @ViewBuilder content: @escaping (Binding<Bool>) -> Content) {
    _value = State(initialValue: initialValue)
    self.content = content
  }
  
  var body: some View {
    // Provide the binding of the state value to the content view.
    content($value)
  }
}

