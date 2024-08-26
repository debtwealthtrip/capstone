// Import the Foundation framework for basic data handling and networking
import Foundation

// MARK: - Welcome
// Define the PhotoDataModel struct which conforms to the Codable protocol
struct PhotoDataModel: Codable {
  // Define properties with their corresponding types
  let totalResults, page, perPage: Int // Holds the total number of results, current page, and results per page
  let photos: [Photo] // An array of Photo objects
  let nextPage: String // The URL for the next page of results
  
  // Enum to map JSON keys to struct properties
  enum CodingKeys: String, CodingKey {
    case totalResults = "total_results" // Map "total_results" JSON key to totalResults property
    case page // Map "page" JSON key to page property
    case perPage = "per_page" // Map "per_page" JSON key to perPage property
    case photos // Map "photos" JSON key to photos property
    case nextPage = "next_page" // Map "next_page" JSON key to nextPage property
  }
}

// MARK: - Photo
// Define the Photo struct which conforms to the Codable and Identifiable protocols
struct Photo: Codable, Identifiable {
  // Define properties with their corresponding types
  let id, width, height: Int // Holds the photo's ID, width, and height
  let url: String // URL of the photo
  let photographer: String // Name of the photographer
  let photographerURL: String // URL of the photographer's profile
  let photographerID: Int // ID of the photographer
  let avgColor: String // Average color of the photo
  let src: Src // Nested Src struct containing URLs for different sizes of the photo
  let liked: Bool // Whether the photo is liked by the user
  let alt: String // Alternative text for the photo
  
  // Enum to map JSON keys to struct properties
  enum CodingKeys: String, CodingKey {
    case id, width, height, url, photographer // Map corresponding JSON keys to properties
    case photographerURL = "photographer_url" // Map "photographer_url" JSON key to photographerURL property
    case photographerID = "photographer_id" // Map "photographer_id" JSON key to photographerID property
    case avgColor = "avg_color" // Map "avg_color" JSON key to avgColor property
    case src, liked, alt // Map corresponding JSON keys to properties
  }
}

// MARK: - Src
// Define the Src struct which conforms to the Codable protocol
struct Src: Codable {
  // Define properties with their corresponding types
  let original, large2X, large, medium: String // URLs for different sizes of the photo
  let small, portrait, landscape, tiny: String // URLs for different sizes of the photo
  
  // Enum to map JSON keys to struct properties
  enum CodingKeys: String, CodingKey {
    case original // Map "original" JSON key to original property
    case large2X = "large2x" // Map "large2x" JSON key to large2X property
    case large, medium, small, portrait, landscape, tiny // Map corresponding JSON keys to properties
  }
}

