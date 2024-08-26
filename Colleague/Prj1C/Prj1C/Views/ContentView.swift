import SwiftUI

// Define the ContentView structure, which conforms to the View protocol
struct ContentView: View {
  @StateObject private var store = PhotoStore() // Manages the state of photos
  @StateObject private var favoritesManager = FavoritesManager() // Manages the state of favorite photos
  @State private var query = "" // Holds the user's search query
  
  private let gridItems = [GridItem(.adaptive(minimum: 100))] // Defines the layout for the photo grid
  
  var body: some View {
    NavigationStack { // Provides navigation capabilities
      VStack { // Arranges child views vertically
        HStack { // Arranges child views horizontally
          TextField("Search photos", text: $query, onCommit: { // Text field for entering search queries
            Task {
              await store.searchPhotos(query: query) // Perform search when the user hits return
            }
          })
          .textFieldStyle(RoundedBorderTextFieldStyle()) // Styles the text field with rounded corners
          .padding() // Adds padding around the text field
          
          Button(action: { // Button to trigger photo search
            Task {
              await store.searchPhotos(query: query) // Perform search when the button is tapped
            }
          }) {
            Image(systemName: "magnifyingglass") // Magnifying glass icon for the search button
              .foregroundColor(.white) // Color of the icon
              .padding() // Adds padding around the icon
          }
          .background(Color.orange) // Background color for the button
          .clipShape(Circle()) // Makes the button circular
          .shadow(radius: 5) // Adds shadow to the button for better visibility
        }
        
        if store.photos.isEmpty { // Shows placeholder view when no photos are available
          CUnavailableView(content: {
            AnimatedNoPhotosView() // Custom view for when no photos are found
          }, errorMessage: store.errorMessage) // Displays an error message if available
        } else { // Shows photos if they are available
          ScrollView { // Enables scrolling for the content
            LazyVGrid(columns: gridItems, spacing: 10) { // Lays out photos in a grid
              ForEach(store.photos) { photo in // Iterates over each photo
                NavigationLink(destination: PhotoDetailView(photo: photo).environmentObject(favoritesManager)) {
                  PhotoGridItem(photo: photo) // Displays photo grid items
                }
              }
            }
            .padding() // Adds padding around the grid
          }
        }
        
        // Only show the "View Favorites" button if there are favorite photos
        if !favoritesManager.favoritePhotos.isEmpty {
          NavigationLink(destination: FavoritesView().environmentObject(favoritesManager)) {
            Text("View Favorites") // Button text
              .padding() // Adds padding around the button
              .background(Color.blue) // Background color for the button
              .foregroundColor(.white) // Text color for the button
              .cornerRadius(8) // Rounds the corners of the button
          }
          .padding() // Adds padding around the button
        }
      }
      .navigationTitle("Stock Photos") // Sets the navigation bar title
    }
    .environmentObject(favoritesManager) // Provides the favorites manager to child views
  }
}

// Define a view for displaying an individual photo in the grid
struct PhotoGridItem: View {
  let photo: Photo // The photo to be displayed
  
  var body: some View {
    CachedAsyncImage(url: photo.src.small) { // Loads the photo asynchronously
      ProgressView() // Shows a progress indicator while loading
    }
    .aspectRatio(contentMode: .fill) // Maintains aspect ratio while filling the container
    .clipShape(RoundedRectangle(cornerRadius: 10)) // Clips the image to a rounded rectangle
    .frame(height: 150) // Sets the height of the image
    .padding(4) // Adds padding around the image
  }
}

// Define an animated view to show when there are no photos
struct AnimatedNoPhotosView: View {
  @State private var scale: CGFloat = 0.8 // State variable for scaling animation
  
  var body: some View {
    VStack { // Arranges text and image vertically
      Text("Type Words for Perfect Shots") // Instructional text
        .font(.title) // Title font size
        .foregroundColor(.blue) // Color of the text
        .scaleEffect(scale) // Applies scaling effect
        .onAppear {
          withAnimation(
            Animation.easeInOut(duration: 1.0) // Animation settings
              .repeatForever(autoreverses: true) // Repeats the animation with autoreverses
          ) {
            scale = 1.2 // Increases the scale for pulsing effect
          }
        }
      
      Image(systemName: "camera") // Camera icon
        .resizable() // Makes the image resizable
        .scaledToFit() // Scales the image to fit within its frame
        .frame(width: 100, height: 100) // Sets the size of the image
        .foregroundColor(.gray) // Color of the image
      
      // Added instructional text below the camera image
      VStack(alignment: .center, spacing: 10) { // Arranges text vertically with spacing
        Text("To find a gold image, simply type “Gold” in the search bar and press Search.")
          .font(.subheadline) // Smaller font size
          .foregroundColor(.green) // Color 2
          .padding()
        
        Text("Motto: “Have Fun, Get It Done!”") // Larger font size
          .font(.title2) // Title 2 font size
          .foregroundColor(.purple) // Color 1
          .padding()
        
        Text("Click on any image to view it in a larger size, along with the title and creator information.") // Medium font size
          .font(.body) // Body font size
          .foregroundColor(.orange) // Color 3
          .padding()
        
        Text("You can easily add images to your favorites or remove them whenever you change your mind.") // Medium font size
          .font(.body) // Body font size
          .foregroundColor(.blue) // Color 4
      }
      .multilineTextAlignment(.center) // Center-aligns multiline text
      .padding() // Adds padding around the text
    }
  }
}

// Set up a preview for the ContentView
#Preview {
  ContentView() // Previews the ContentView
    .environmentObject(FavoritesManager()) // Provides the favorites manager to the preview
}

