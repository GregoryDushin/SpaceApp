//
//  RocketLoader.swift
//  SpaceX
//
//  Created by Григорий Душин on 06.10.2022.
//

import Foundation

// MARK: JSON ROCKET PARSING

class RocketLoader {
    func rocketDataLoad(completion: @escaping ([RocketModelElement]) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: Url.rocketUrl.rawValue) else {return}
        let task = session.dataTask(with: url) { (data, responce, error) in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let data = data {
                    let json = try decoder.decode([RocketModelElement].self, from: data)
                    completion(json)
                } } catch let error as NSError {
                    print(error.localizedDescription)
                }
        }
        task.resume()
    }
}
