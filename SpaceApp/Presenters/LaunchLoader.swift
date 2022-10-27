//
//  LaunchLoader.swift
//  SpaceX
//
//  Created by Григорий Душин on 07.10.2022.
//

import Foundation

// MARK: JSON LAUNCH PARSING

class LaunchLoader {
    private let decoder = JSONDecoder()
    
    func launchDataLoad(id: String, completion: @escaping (Result<[LaunchModelElement], Error>) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let session = URLSession.shared
        guard let url = URL(string: Url.launchUrl.rawValue) else {return}
        let task = session.dataTask(with: url) { (data, _, error) in
            self.decoder.dateDecodingStrategy = .formatted(dateFormatter)
            self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let data = data {
                    do {
                        let json = try self.decoder.decode([LaunchModelElement].self, from: data)
                        let launches = json.filter { $0.rocket == id }
                        completion(.success(launches))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
