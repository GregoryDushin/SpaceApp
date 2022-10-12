//
//  LaunchLoader.swift
//  SpaceX
//
//  Created by Григорий Душин on 07.10.2022.
//

import Foundation

//MARK: JSON LAUNCH PARSING

class LaunchLoader {
    
    func launchDataLoad(id: String , completition: @escaping ([LaunchModelElement]) -> Void){
        
        
        var launches : [LaunchModelElement] = []
        
        let session = URLSession.shared
        let url = URL(string: launchUrl)!
        let task = session.dataTask(with: url) { (data, responce, error) in
            
            DispatchQueue.main.async{
                
                guard error == nil else{
                    print("Error")
                    return
                }
                do {
                    let json = try JSONDecoder().decode([LaunchModelElement].self, from: data!)
                    
                    for el in json {
                        if el.rocket == id {
                            launches.append(el)
                        }
                    }
                    
                    completition(launches)
                    
                }catch{
                    
                    print("wrong url")
                }
            }
            
        }
        task.resume()
    }
}
