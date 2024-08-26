import SwiftUI

// A generic SwiftUI view that displays content when it's unavailable.
struct CUnavailableView<Content: View>: View { // This struct defines a reusable view that can display a message or custom content.
  
  let content: () -> Content // A closure that returns the content to be displayed when there is no error message.
  let errorMessage: String? // An optional string that contains an error message if something goes wrong.
  
  var body: some View { // The body of the view defines its UI layout.
    VStack { // Arranges its children vertically.
      if let message = errorMessage { // Checks if there is an error message.
        Text(message) // Displays the error message if it exists.
          .font(.headline) // Sets the font style to headline, making it bold and prominent.
          .padding() // Adds padding around the text for better spacing.
          .foregroundColor(.red) // Colors the error message text in red to indicate an error.
      } else { // If there is no error message...
        content() // Displays the content provided by the closure.
          .font(.headline) // Ensures the content text is styled as a headline.
          .padding() // Adds padding around the content.
      }
      Spacer() // Adds a spacer below the content to push it to the top of the view, creating more space below.
    }
  }
}

