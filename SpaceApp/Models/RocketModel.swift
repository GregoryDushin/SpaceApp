

import Foundation

// MARK: - CodableRocketModel

class RocketModelElement: Codable {
    let height, diameter: Diameter
    let mass: Mass
    let firstStage: FirstStage
    let secondStage: SecondStage
    let engines: Engines
    let landingLegs: LandingLegs
    let payloadWeights: [PayloadWeight]
    let flickrImages: [String]
    let name, type: String
    let active: Bool
    let stages, boosters, costPerLaunch, successRatePct: Int
    let firstFlight, country, company: String
    let wikipedia: String
    let rocketModelDescription, id: String

    enum CodingKeys: String, CodingKey {
        case height, diameter, mass
        case firstStage = "first_stage"
        case secondStage = "second_stage"
        case engines
        case landingLegs = "landing_legs"
        case payloadWeights = "payload_weights"
        case flickrImages = "flickr_images"
        case name, type, active, stages, boosters
        case costPerLaunch = "cost_per_launch"
        case successRatePct = "success_rate_pct"
        case firstFlight = "first_flight"
        case country, company, wikipedia
        case rocketModelDescription = "description"
        case id
    }

    init(height: Diameter, diameter: Diameter, mass: Mass, firstStage: FirstStage, secondStage: SecondStage, engines: Engines, landingLegs: LandingLegs, payloadWeights: [PayloadWeight], flickrImages: [String], name: String, type: String, active: Bool, stages: Int, boosters: Int, costPerLaunch: Int, successRatePct: Int, firstFlight: String, country: String, company: String, wikipedia: String, rocketModelDescription: String, id: String) {
        self.height = height
        self.diameter = diameter
        self.mass = mass
        self.firstStage = firstStage
        self.secondStage = secondStage
        self.engines = engines
        self.landingLegs = landingLegs
        self.payloadWeights = payloadWeights
        self.flickrImages = flickrImages
        self.name = name
        self.type = type
        self.active = active
        self.stages = stages
        self.boosters = boosters
        self.costPerLaunch = costPerLaunch
        self.successRatePct = successRatePct
        self.firstFlight = firstFlight
        self.country = country
        self.company = company
        self.wikipedia = wikipedia
        self.rocketModelDescription = rocketModelDescription
        self.id = id
    }
}


// MARK: - Diameter
class Diameter: Codable {
    let meters, feet: Double?

    init(meters: Double?, feet: Double?) {
        self.meters = meters
        self.feet = feet
    }
}


// Engines
class Engines: Codable {
    let isp: ISP
    let thrustSeaLevel, thrustVacuum: Thrust
    let number: Int
    let type, version: String
    let layout: String?
    let engineLossMax: Int?
    let propellant1, propellant2: String
    let thrustToWeight: Double

    enum CodingKeys: String, CodingKey {
        case isp
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
        case number, type, version, layout
        case engineLossMax = "engine_loss_max"
        case propellant1 = "propellant_1"
        case propellant2 = "propellant_2"
        case thrustToWeight = "thrust_to_weight"
    }

    init(isp: ISP, thrustSeaLevel: Thrust, thrustVacuum: Thrust, number: Int, type: String, version: String, layout: String?, engineLossMax: Int?, propellant1: String, propellant2: String, thrustToWeight: Double) {
        self.isp = isp
        self.thrustSeaLevel = thrustSeaLevel
        self.thrustVacuum = thrustVacuum
        self.number = number
        self.type = type
        self.version = version
        self.layout = layout
        self.engineLossMax = engineLossMax
        self.propellant1 = propellant1
        self.propellant2 = propellant2
        self.thrustToWeight = thrustToWeight
    }
}

// MARK: - ISP
class ISP: Codable {
    let seaLevel, vacuum: Int

    enum CodingKeys: String, CodingKey {
        case seaLevel = "sea_level"
        case vacuum
    }

    init(seaLevel: Int, vacuum: Int) {
        self.seaLevel = seaLevel
        self.vacuum = vacuum
    }
}

// MARK: - Thrust
class Thrust: Codable {
    let kN, lbf: Int

    init(kN: Int, lbf: Int) {
        self.kN = kN
        self.lbf = lbf
    }
}

// MARK: - FirstStage
class FirstStage: Codable {
    let thrustSeaLevel, thrustVacuum: Thrust
    let reusable: Bool
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSEC: Int?

    enum CodingKeys: String, CodingKey {
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
        case reusable, engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSEC = "burn_time_sec"
    }

    init(thrustSeaLevel: Thrust, thrustVacuum: Thrust, reusable: Bool, engines: Int, fuelAmountTons: Double, burnTimeSEC: Int?) {
        self.thrustSeaLevel = thrustSeaLevel
        self.thrustVacuum = thrustVacuum
        self.reusable = reusable
        self.engines = engines
        self.fuelAmountTons = fuelAmountTons
        self.burnTimeSEC = burnTimeSEC
    }
}

// MARK: - LandingLegs
class LandingLegs: Codable {
    let number: Int
    let material: String?

    init(number: Int, material: String?) {
        self.number = number
        self.material = material
    }
}


// MARK: - Mass
class Mass: Codable {
    let kg, lb: Int

    init(kg: Int, lb: Int) {
        self.kg = kg
        self.lb = lb
    }
}


// MARK: - PayloadWeight
class PayloadWeight: Codable {
    let id, name: String
    let kg, lb: Int

    init(id: String, name: String, kg: Int, lb: Int) {
        self.id = id
        self.name = name
        self.kg = kg
        self.lb = lb
    }
}



// MARK: - SecondStage
class SecondStage: Codable {
    let thrust: Thrust
    let payloads: Payloads
    let reusable: Bool
    let engines: Int
    let fuelAmountTons: Double
    let burnTimeSEC: Int?

    enum CodingKeys: String, CodingKey {
        case thrust, payloads, reusable, engines
        case fuelAmountTons = "fuel_amount_tons"
        case burnTimeSEC = "burn_time_sec"
    }

    init(thrust: Thrust, payloads: Payloads, reusable: Bool, engines: Int, fuelAmountTons: Double, burnTimeSEC: Int?) {
        self.thrust = thrust
        self.payloads = payloads
        self.reusable = reusable
        self.engines = engines
        self.fuelAmountTons = fuelAmountTons
        self.burnTimeSEC = burnTimeSEC
    }
}



// MARK: - Payloads
class Payloads: Codable {
    let compositeFairing: CompositeFairing
    let option1: String

    enum CodingKeys: String, CodingKey {
        case compositeFairing = "composite_fairing"
        case option1 = "option_1"
    }

    init(compositeFairing: CompositeFairing, option1: String) {
        self.compositeFairing = compositeFairing
        self.option1 = option1
    }
}



// MARK: - CompositeFairing
class CompositeFairing: Codable {
    let height, diameter: Diameter

    init(height: Diameter, diameter: Diameter) {
        self.height = height
        self.diameter = diameter
    }
}




