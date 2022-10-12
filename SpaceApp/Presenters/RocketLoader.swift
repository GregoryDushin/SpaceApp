//
//  RocketLoader.swift
//  SpaceX
//
//  Created by Григорий Душин on 06.10.2022.
//

import Foundation

//MARK: JSON ROCKET PARSING

class RocketLoader{
    
    func rocketDataLoad(completition: @escaping ([RocketModelElement]) -> Void){
        
        var rockets : [RocketModelElement] = []
        
        let session = URLSession.shared
        let url = URL(string: rocketUrl)!
        let task = session.dataTask(with: url) { (data, responce, error) in
            
            DispatchQueue.main.async{
                
                guard error == nil else{
                    print("Error")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let json = try! decoder.decode([RocketModelElement].self, from: data!)
                    
                    rockets = json
   
                    completition(rockets)
                    
                }catch{
                    
                    print("wrong url")
                }
            }
            
        }
        task.resume()
    }
}
