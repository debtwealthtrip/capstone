import SwiftUI
import Foundation
import Combine
import UIKit

// Define a struct PhotoResponse that conforms to the Codable protocol
// This struct is used to parse the JSON response from the Pexels API
struct PhotoResponse: Codable {
  // Array of Photo objects extracted from the API response
  let photos: [Photo]
}

// Define a class PhotoStore that conforms to the ObservableObject protocol
// This class will manage the state and provide methods for fetching photos and images
class PhotoStore: ObservableObject {
  // A published property to hold an array of photos
  @Published var photos: [Photo] = []
  // A published property to hold error messages, if any
  @Published var errorMessage: String? = nil
  
  // The API key for accessing the Pexels API
  private let apiKey: String = PLAPI.apiKey
  // A cache to store downloaded images for quick access
  private let imageCache = NSCache<NSString, UIImage>()
  
  // Define an async function to search for photos based on a query string
  func searchPhotos(query: String) async {
    // Construct the URL for the API request with the query parameter and pagination
    guard let url = URL(string: "https://api.pexels.com/v1/search?query=\(query)&per_page=30") else {
      DispatchQueue.main.async {
        // Update the error message if the URL is invalid
        self.errorMessage = "Invalid URL"
      }
      return
    }
    
    var request = URLRequest(url: url)
    // Set the API key in the request header for authentication
    request.setValue(apiKey, forHTTPHeaderField: "Authorization")
    
    do {
      // Perform the API request and get the data and response
      let (data, response) = try await URLSession.shared.data(for: request)
      if let httpResponse = response as? HTTPURLResponse {
        DispatchQueue.main.async {
          // Handle different HTTP status codes
          switch httpResponse.statusCode {
          case 200:
            do {
              // Decode the JSON data into a PhotoResponse object
              let photoResponse = try JSONDecoder().decode(PhotoResponse.self, from: data)
              // Update the photos array and clear any existing error message
              self.photos = photoResponse.photos
              self.errorMessage = nil
            } catch {
              // Set an error message if JSON decoding fails
              self.errorMessage = "Failed to decode response"
            }
          case 403:
            // Handle forbidden access errors
            self.errorMessage = "Failed with status code 403 (Forbidden)"
          case 500:
            // Handle server errors
            self.errorMessage = "Failed with status code 500 (Server Error)"
          default:
            // Handle other HTTP status codes
            self.errorMessage = "Failed with status code \(httpResponse.statusCode)"
          }
        }
      }
    } catch {
      // Set an error message if the network request fails
      DispatchQueue.main.async {
        self.errorMessage = "Error: \(error.localizedDescription)"
      }
    }
  }
  
  // Define a function to fetch an image from a URL
  func fetchImage(url: String) -> AnyPublisher<UIImage?, Never> {
    // Check if the image is already cached
    if let cachedImage = imageCache.object(forKey: url as NSString) {
      return Just(cachedImage).eraseToAnyPublisher()
    }
    
    // Ensure the URL is valid
    guard let url = URL(string: url) else {
      return Just(nil).eraseToAnyPublisher()
    }
    
    // Create a publisher for the data task
    return URLSession.shared.dataTaskPublisher(for: url)
      .map { UIImage(data: $0.data) } // Map the data to UIImage
      .replaceError(with: nil) // Replace errors with nil
      .handleEvents(receiveOutput: { [weak self] image in
        // Cache the image if it was successfully downloaded
        if let image = image {
          self?.imageCache.setObject(image, forKey: url.absoluteString as NSString)
        }
      })
      .receive(on: DispatchQueue.main) // Ensure UI updates happen on the main thread
      .eraseToAnyPublisher() // Convert to a generic publisher type
  }
}

