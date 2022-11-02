//
//  rocketsData.swift
//  SpaceApp
//
//  Created by Григорий Душин on 02.11.2022.
//

import Foundation

enum ListItem: Hashable {
    case image(URL)
    case title(String)
    case verticalInfo(title: String, value: String)
    case horizontalInfo(title: String, value: String)
    case button
}

enum SectionType {
    case image
    case horizontal
    case vertical
}

struct Section: Hashable {
    let sectionType: SectionType
    let title: String?
    let items: [ListItem]
}
