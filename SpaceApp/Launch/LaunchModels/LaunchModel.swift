import Foundation

struct LaunchModelElement: Decodable {
    let success: Bool?
    let name: String
    let dateUtc: Date
    let rocket: String
}
