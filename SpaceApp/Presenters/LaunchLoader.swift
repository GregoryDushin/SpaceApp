//
//  LaunchLoader.swift
//  SpaceX
//
//  Created by Григорий Душин on 07.10.2022.
//

import Foundation

//MARK: JSON LAUNCH PARSING

class LaunchLoader {
    
    func launchDataLoad(id: String , completion: @escaping ([LaunchModelElement]) -> Void){
        
        var launches : [LaunchModelElement] = []
        
        let session = URLSession.shared
        
        guard let url = URL(string: Url.launchUrl.rawValue) else {return}
        
        let task = session.dataTask(with: url) { (data, responce, error) in
            
                do {
                    let decoder = JSONDecoder()
                   decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    if let data = data {
                        
                  let json = try decoder.decode([LaunchModelElement].self, from: data)
                    
                        launches = json.filter{$0.rocket == id}
         
                    completion(launches)
                    
                    }} catch let error as NSError{
                    
                    print(error.localizedDescription)
                }
            
        }
        task.resume()
    }
}
