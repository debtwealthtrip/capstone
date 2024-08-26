import SwiftUI
import Combine

// Define a class to manage the user's favorite photos
class FavoritesManager: ObservableObject {
  // A published property to hold the list of favorite photos
  @Published var favoritePhotos: [Photo] = []
  
  // Save a photo to favorites
  func savePhoto(_ photo: Photo) {
    // Check if the photo is not already in the favorites list
    if !favoritePhotos.contains(where: { $0.id == photo.id }) {
      // Add the photo to the favorites list
      favoritePhotos.append(photo)
    }
  }
  
  // Remove a photo from favorites
  func removePhoto(_ photo: Photo) {
    // Remove the photo from the favorites list if it exists
    favoritePhotos.removeAll(where: { $0.id == photo.id })
  }
  
  // Check if a photo is already in favorites
  func isFavorite(photo: Photo) -> Bool {
    // Return true if the photo is in the favorites list, false otherwise
    favoritePhotos.contains(where: { $0.id == photo.id })
  }
}

