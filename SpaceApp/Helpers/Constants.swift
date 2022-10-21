//
//  Constants.swift
//  SpaceX
//
//  Created by Григорий Душин on 07.10.2022.
//

import Foundation

 enum Url: String {
    case rocketUrl = "https://api.spacexdata.com/v4/rockets"
    case launchUrl = "https://api.spacexdata.com/v4/launches"
}
enum PersistanceKeys: String {
    case heightKey = "Persistance.heightKey"
    case diameterKey = "Persistance.diameterKey"
    case massKey = "Persistance.massKey"
    case capacityKey = "Persistance.capaciryKey"
}
