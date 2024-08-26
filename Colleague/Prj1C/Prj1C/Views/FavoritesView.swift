import SwiftUI

// Define a view to display the list of favorite photos.
struct FavoritesView: View {
  // Use the environment object for the favorites manager, which provides access to the list of favorite photos.
  @EnvironmentObject private var favoritesManager: FavoritesManager
  
  // Define the body of the view, which describes the view's layout and behavior.
  var body: some View {
    // A NavigationView wraps the List, providing navigation capabilities.
    NavigationView {
      // Display a list of favorite photos. The photos are provided by the `favoritesManager`.
      List(favoritesManager.favoritePhotos) { photo in
        // Each photo in the list is wrapped in a NavigationLink. This allows the user to tap on a photo to see its details.
        NavigationLink(destination: PhotoDetailView(photo: photo)) {
          // Define a horizontal stack (HStack) to lay out the photo's thumbnail image and its description text side by side.
          HStack {
            // Use AsyncImage to load and display the photo's thumbnail image from a URL.
            AsyncImage(url: URL(string: photo.src.small)) { image in
              // When the image is successfully loaded, make it resizable, scale it to fit within a specified frame, and set the frame size.
              image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            } placeholder: {
              // If the image is still loading, display a ProgressView as a placeholder.
              ProgressView()
            }
            // Display the photo's alternative text, which describes the photo. Limit the text to one line.
            Text(photo.alt)
              .lineLimit(1)
          }
        }
      }
      // Set the title of the navigation bar to "Favorites".
      .navigationTitle("Favorites")
    }
  }
}

// Provides a live preview of the FavoritesView in Xcode
#Preview {
  FavoritesView()
    .environmentObject(FavoritesManager()) // Injects the FavoritesManager into the preview.
}
