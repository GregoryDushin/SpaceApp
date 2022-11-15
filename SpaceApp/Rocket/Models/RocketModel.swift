import Foundation

// MARK: - CodableRocketModel

struct RocketModelElement: Decodable {
    let height: Diameter
    let diameter: Diameter
    let mass: Mass
    let firstStage: FirstStage
    let secondStage: SecondStage
    let payloadWeights: [PayloadWeight]
    let flickrImages: [String]
    let name: String
    let stages: Int
    let costPerLaunch: Int
    let successRatePct: Int
    let firstFlight: String
    let id: String
}

// MARK: - Diameter

extension RocketModelElement {
    struct Diameter: Decodable {
        let meters: Double?
        let feet: Double?
    }

    // MARK: - FirstStage

    struct FirstStage: Decodable {
        let engines: Int
        let fuelAmountTons: Double
        let burnTimeSec: Int?
    }

    // MARK: - Mass

    struct Mass: Decodable {
        let kg: Int
        let lb: Int
    }

    // MARK: - PayloadWeight

    struct PayloadWeight: Decodable {
        let id: String
        let name: String
        let kg: Int
        let lb: Int
    }

    // MARK: - SecondStage

    struct SecondStage: Decodable {
        let engines: Int
        let fuelAmountTons: Double
        let burnTimeSec: Int?
    }
}
