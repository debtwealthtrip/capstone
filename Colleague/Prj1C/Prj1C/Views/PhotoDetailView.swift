import SwiftUI
import Combine

// Define the PhotoDetailView structure, which conforms to the View protocol.
// This view displays detailed information about a specific photo.
struct PhotoDetailView: View {
  // A property to hold the photo data, passed when the view is created.
  let photo: Photo
  
  // A state variable to hold the downloaded image. It is initially nil and will be updated when the image is fetched.
  @State private var image: UIImage?
  
  // A state variable to hold the cancellable object for the Combine subscription.
  // This allows you to cancel the image download if needed.
  @State private var cancellable: AnyCancellable?
  
  // An environment object for managing favorite photos.
  // The environment object allows this view to access shared data and functionality related to favorites.
  @EnvironmentObject private var favoritesManager: FavoritesManager
  
  // Define the body of the PhotoDetailView, which describes the view's layout and behavior.
  var body: some View {
    VStack {  // Vertically stack the elements inside the view.
      // Display the image using AsyncImage, which loads the image from a URL.
      AsyncImage(url: URL(string: photo.src.large)) { image in
        image  // When the image is successfully loaded, it is displayed.
          .resizable()  // The image is made resizable.
          .scaledToFill()  // The image is scaled to fill the available space.
      } placeholder: {  // A placeholder view to display while the image is loading.
        ProgressView()  // A loading indicator.
      }
      
      // Display the alternative text for the photo.
      Text(photo.alt)
      
      // Display the name of the photographer.
      Text("Created By - \(photo.photographer)")
        .padding()  // Add some padding around the text.
      
      // Button to save or remove the photo from favorites.
      Button(action: {
        // Check if the photo is already a favorite.
        if favoritesManager.isFavorite(photo: photo) {
          // If it is a favorite, remove it from the favorites.
          favoritesManager.removePhoto(photo)
        } else {
          // If it is not a favorite, save it to the favorites.
          favoritesManager.savePhoto(photo)
        }
      }) {
        // Set the button label based on whether the photo is a favorite.
        Text(favoritesManager.isFavorite(photo: photo) ? "Remove from Favorites" : "Save to Favorites")
          .padding()  // Add padding to the button.
          .background(Color.blue)  // Set the background color of the button.
          .foregroundColor(.white)  // Set the text color to white.
          .cornerRadius(8)  // Round the corners of the button.
      }
    }
    .onAppear {  // When the view appears on screen, trigger the image fetching process.
      fetchImage()  // Call the fetchImage function to download the image.
    }
  }
  
  // Define a private function to fetch the image.
  // This function uses Combine to fetch the image from the provided URL.
  private func fetchImage() {
    cancellable = PhotoStore().fetchImage(url: photo.src.large)  // Start the image download.
      .sink(receiveCompletion: { _ in }, receiveValue: { image in  // Handle the result of the download.
        self.image = image  // Update the state variable with the downloaded image.
      })
  }
}

