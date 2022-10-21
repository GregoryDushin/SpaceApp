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
    
    func launchDataLoad(id: String, completion: @escaping ([LaunchModelElement]) -> Void) {
        // MARK: DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let session = URLSession.shared
        guard let url = URL(string: Url.launchUrl.rawValue) else {return}
        let task = session.dataTask(with: url) { (data, _, error) in
          do {
                self.decoder.dateDecodingStrategy = .formatted(dateFormatter)
                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let data = data {
                    let json = try self.decoder.decode([LaunchModelElement].self, from: data)
                    print(json[0].dateUtc)
                    let launches = json.filter { $0.rocket == id }
                    completion(launches)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
