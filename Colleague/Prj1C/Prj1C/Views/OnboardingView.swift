import SwiftUI
import Foundation
import Combine
import UIKit

// Data structure representing a single onboarding screen.
struct OnboardingScreenData {
  let title: String          // Title of the onboarding screen.
  let description: String    // Description text for the onboarding screen.
  let imageName: String      // Name of the image to display on the onboarding screen.
}

// ViewModel class to manage the state and logic for the onboarding screens.
class OnboardingManager: ObservableObject {
  @Published var currentIndex: Int = 0  // Tracks the current screen index. Published so views can react to changes.
  
  // Array of screens to display in the onboarding flow.
  let screens: [OnboardingScreenData] = [
    OnboardingScreenData(title: "Welcome", description: "Discover amazing photos with ease.", imageName: "photo1"),
    OnboardingScreenData(title: "Search", description: "Search for photos by your favorite topics.", imageName: "photo2"),
    OnboardingScreenData(title: "Save", description: "Save and view your favorite photos anytime.", imageName: "photo3")
  ]
}

// The main onboarding view that handles displaying and interacting with multiple onboarding screens.
struct OnboardingView: View {
  @StateObject private var viewModel = OnboardingManager() // Instantiate the OnboardingManager to manage state.
  @Binding var showOnboarding: Bool  // Binding to control the visibility of the onboarding view.
  @State private var offset: CGFloat = 0  // Tracks the offset for horizontal scrolling of screens.
  
  private let screenWidth = UIScreen.main.bounds.width  // Screen width for calculating offsets.
  private let screenHeight = UIScreen.main.bounds.height  // Screen height (not used in the layout but calculated here).

  var body: some View {
    ZStack {  // Stacks views on top of each other.
      VStack {  // Vertically stacks elements inside the ZStack.
        GeometryReader { geometry in  // A container view that provides size and position info about its child views.
          HStack(spacing: 0) {  // Horizontally stacks onboarding screens with no spacing.
            ForEach(viewModel.screens.indices, id: \.self) { index in  // Loops through each screen.
              OnboardingScreenView(screenData: viewModel.screens[index])  // Displays the current screen's data.
                .frame(width: geometry.size.width, height: geometry.size.height)  // Ensures each screen fits the available space.
            }
          }
          .offset(x: -self.offset)  // Moves the HStack horizontally based on the current offset.
          .animation(.easeInOut, value: offset)  // Adds an ease-in-out animation when the offset changes.
          .gesture(
            DragGesture().onEnded { value in  // Handles drag gestures to change screens.
              let dragThreshold: CGFloat = 50  // Minimum drag distance to switch screens.
              if value.translation.width < -dragThreshold {  // Swipe left.
                viewModel.currentIndex = min(viewModel.currentIndex + 1, viewModel.screens.count - 1)
              } else if value.translation.width > dragThreshold {  // Swipe right.
                viewModel.currentIndex = max(viewModel.currentIndex - 1, 0)
              }
              self.offset = CGFloat(viewModel.currentIndex) * screenWidth  // Update offset based on new index.
            }
          )
        }
        
        Spacer()  // Adds space between the screens and the button.
        
        Button(action: {  // Button to move to the next screen or finish onboarding.
          if viewModel.currentIndex == viewModel.screens.count - 1 {  // If on the last screen...
            showOnboarding = false  // Hide onboarding.
          } else {  // Otherwise...
            viewModel.currentIndex += 1  // Move to the next screen.
            self.offset = CGFloat(viewModel.currentIndex) * screenWidth  // Update the offset to move the view.
          }
        }) {
          Text(viewModel.currentIndex == viewModel.screens.count - 1 ? "Get Started" : "Next")  // Button label changes on the last screen.
            .fontWeight(.bold)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
      }
    }
    .onChange(of: viewModel.currentIndex) { _, newIndex in  // Monitors changes to currentIndex and updates offset.
      self.offset = CGFloat(newIndex) * screenWidth
    }
  }
}

// View representing a single onboarding screen.
struct OnboardingScreenView: View {
  let screenData: OnboardingScreenData  // Holds the data for the current screen.
  
  var body: some View {
    VStack {
      Spacer()  // Pushes the content upwards.
      
      Image(screenData.imageName)  // Displays the image for the current screen.
        .resizable()
        .aspectRatio(contentMode: .fit)  // Keeps the image's aspect ratio and fits it within the view.
        .padding()
      
      Text(screenData.title)  // Displays the screen title.
        .font(.largeTitle)
        .fontWeight(.bold)
        .padding(.bottom, 20)  // Space between title and description.
      
      Text(screenData.description)  // Displays the screen description.
        .font(.body)
        .multilineTextAlignment(.center)  // Centers the text horizontally.
        .padding(.horizontal, 20)
      
      Spacer()  // Pushes the content downwards.
    }
  }
}

// A preview provider to show the OnboardingView in Xcode's canvas.
struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    // Mock the showOnboarding binding for preview purposes.
    OnboardingView(showOnboarding: .constant(true))
      .previewDevice("iPhone 15 Pro")  // Optional: Set a specific device for the preview.
  }
}

