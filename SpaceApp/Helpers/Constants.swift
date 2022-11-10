//
//  Constants.swift
//  SpaceX
//
//  Created by Григорий Душин on 07.10.2022.
//

import Foundation

enum Url {
    static let rocketUrl = "https://api.spacexdata.com/v4/rockets"
    static let launchUrl = "https://api.spacexdata.com/v4/launches"
}
enum PersistanceKeys {
    static let heightKey = "Persistance.heightKey"
    static let diameterKey = "Persistance.diameterKey"
    static let massKey = "Persistance.massKey"
    static let capacityKey = "Persistance.capaciryKey"
}
enum LaunchImages {
    static let success = "true"
    static let unsucsess = "false"
}
