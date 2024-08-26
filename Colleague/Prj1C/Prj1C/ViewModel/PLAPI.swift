import Foundation // Import the Foundation framework for basic data handling

// Define the PLAPI structure
struct PLAPI {
  // Define a static computed property to retrieve the API key
  static var apiKey: String {
    // Attempt to get the file path for 'PLInfo.plist' in the main bundle
    guard let filePath = Bundle.main.path(forResource: "PLInfo", ofType: "plist"),
          // Load the contents of the plist file into an NSDictionary
          let plist = NSDictionary(contentsOfFile: filePath),
          // Extract the value associated with the 'API_KEY' key and cast it as a String
          let key = plist["API_KEY"] as? String else {
      // If any of the above steps fail, terminate the application with a fatal error
      fatalError("Couldn't find key 'API_KEY' in 'PLInfo.plist'.")
    }
    // Return the extracted API key
    return key
  }
}

