// Import the SwiftUI framework for building the user interface
import SwiftUI
// Import the Combine framework for handling asynchronous events
import Combine

// Define a generic struct CachedAsyncImage that conforms to the View protocol
struct CachedAsyncImage<Placeholder: View>: View {
  // Define a StateObject to manage the view model's lifecycle
  @StateObject private var viewModel: CachedAsyncImageViewModel
  // Define a placeholder view to be shown while the image is loading
  private let placeholder: Placeholder
  
  // Initialize the CachedAsyncImage with a URL and a placeholder view
  init(url: String, @ViewBuilder placeholder: () -> Placeholder) {
    // Initialize the view model with the given URL
    _viewModel = StateObject(wrappedValue: CachedAsyncImageViewModel(url: url))
    // Initialize the placeholder view
    self.placeholder = placeholder()
  }
  
  // Define the body property of the view
  var body: some View {
    // Use a Group to conditionally display either the loaded image or the placeholder
    Group {
      // Check if the image is available in the view model
      if let image = viewModel.image {
        // Display the loaded image
        Image(uiImage: image)
          .resizable() // Make the image resizable
      } else {
        // Display the placeholder view
        placeholder
      }
    }
    // Load the image when the view appears
    .onAppear {
      viewModel.loadImage()
    }
  }
}

// Define a class CachedAsyncImageViewModel that conforms to the ObservableObject protocol
class CachedAsyncImageViewModel: ObservableObject {
  // Define a published property to hold the loaded image
  @Published var image: UIImage?
  // Define a property to hold the URL of the image
  private let url: String
  // Define a cancellable object to handle the Combine subscription
  private var cancellable: AnyCancellable?
  
  // Initialize the view model with a URL
  init(url: String) {
    self.url = url
  }
  
  // Define a method to load the image
  func loadImage() {
    // Use the PhotoStore to fetch the image from the URL
    cancellable = PhotoStore().fetchImage(url: url)
    // Handle the completion and receive events from the publisher
      .sink { [weak self] image in
        // Update the image property with the fetched image
        self?.image = image
      }
  }
}

