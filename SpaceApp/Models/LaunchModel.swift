
import Foundation

// MARK: - CodableLaunchModel

struct LaunchModelElement: Decodable {
    let success: Bool?
    let name : String
    let dateUtc: String
    let dateLocal : String
    let rocket : String
    
    }

