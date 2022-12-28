//
//  LaunchLoader.swift
//  SpaceX
//
//  Created by Григорий Душин on 07.10.2022.
//

import Foundation

// MARK: - JSON LAUNCH PARSING

protocol LaunchLoaderProtocol {
    func launchDataLoad(id: String, completion: @escaping (Result<[LaunchModelElement], Error>) -> Void)
}

final class LaunchLoader: LaunchLoaderProtocol {
    private let decoder = JSONDecoder()
    var session: URLSession

    init(urlSession: URLSession = .shared) {
        let dateFormatter = DateFormatter()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self.session = urlSession
    }

    func launchDataLoad(id: String, completion: @escaping (Result<[LaunchModelElement], Error>) -> Void) {
        guard let url = URL(string: Url.launchUrl) else {return}
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            do {
                let json = try self.decoder.decode([LaunchModelElement].self, from: data)
                let launches = json.filter { $0.rocket == id }
                completion(.success(launches))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
