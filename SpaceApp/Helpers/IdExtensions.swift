//
//  CollectionView.swift
//  SpaceApp
//
//  Created by Григорий Душин on 14.11.2022.
//

import UIKit

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}
extension ReuseIdentifying {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
extension UICollectionReusableView: ReuseIdentifying {}
extension UITableViewCell: ReuseIdentifying {}
