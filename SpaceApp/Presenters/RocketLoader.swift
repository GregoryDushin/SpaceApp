//
//  RocketLoader.swift
//  SpaceX
//
//  Created by Григорий Душин on 06.10.2022.
//

import Foundation

// MARK: JSON ROCKET PARSING

class RocketLoader {
    private let decoder = JSONDecoder()
    
    func rocketDataLoad(completion: @escaping (Result<[RocketModelElement], Error>) -> Void) {
        let session = URLSession.shared
        guard let url = URL(string: Url.rocketUrl.rawValue) else {return}
        let task = session.dataTask(with: url) { (data, _, error) in
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let data = data {
                do {
                    let json = try self.decoder.decode([RocketModelElement].self, from: data)
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
