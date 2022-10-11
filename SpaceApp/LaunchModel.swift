
import Foundation

// MARK: - CodableLaunchModel

class LaunchModelElement: Codable {
    
    let success: Bool?
    let name : String
    let date_utc: String
    let date_local : String
    let rocket : String
    
    }
