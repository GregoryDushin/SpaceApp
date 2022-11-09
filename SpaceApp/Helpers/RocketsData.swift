//
//  rocketsData.swift
//  SpaceApp
//
//  Created by Григорий Душин on 02.11.2022.
//

import Foundation

enum ListItem: Hashable {
    case image(url: URL, rocketName: String)
    case verticalInfo(title: String, value: String, id: UUID)
    case horizontalInfo(title: String, value: String)
    case button
}

enum SectionType {
    case image
    case horizontal
    case vertical
    case button
}

struct Section: Hashable {
    let sectionType: SectionType
    let title: String?
    let items: [ListItem]
}
