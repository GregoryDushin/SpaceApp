//
//  RocketLoader.swift
//  SpaceX
//
//  Created by Григорий Душин on 06.10.2022.
//

import Foundation

// MARK: JSON ROCKET PARSING

final class RocketLoader {
    private let decoder = JSONDecoder()
    private let session = URLSession.shared
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func rocketDataLoad(completion: @escaping (Result<[RocketModelElement], Error>) -> Void) {
        guard let url = URL(string: Url.rocketUrl) else {return}
        let task = session.dataTask(with: url) { (data, _, error) in
            guard let data = data else {return}
                do {
                    let json = try self.decoder.decode([RocketModelElement].self, from: data)
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                }
        }
        task.resume()
    }
}
