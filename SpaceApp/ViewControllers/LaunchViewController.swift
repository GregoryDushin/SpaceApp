//
//  LaunchViewController.swift
//  SpaceX
//
//  Created by Григорий Душин on 09.10.2022.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var launchCollectionView: UICollectionView!
    
    var launches: [LaunchModelElement] = []
    
    var id = "5e9d0d95eda69955f709d1eb"   //just for testing (Falcon 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Falcon 1"
      launchLoader(id: id)
        
    }
    
    //MARK: Date formatter from UTC to Local
    // TODO пусть функция возвращает DateFormatter, сделай его свойством
    // private lazy var dateFormatter = makeDateFormatter()
    // dateFormatter.date(from: ...) ?? ""
    func dateFormatter (utcDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let result = dateFormatter.date(from: utcDate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: result!)
    }
    
    func launchLoader(id: String){
        LaunchLoader().launchDataLoad(id: id) { launches in
            DispatchQueue.main.async{
            self.launches = launches
            self.launchCollectionView.reloadData()
        }
        }
}
}
    //MARK:  - Collection View Data Source & CollectionViewDelegateFlowLayout

extension LaunchViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCell = UIScreen.main.bounds.width - 40
        
        return CGSize(width: widthCell, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return launches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        
        //MARK: Make rounded corners on the cell
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 12
        cell.rocketNameLable.text = launches[indexPath.row].name
        cell.dateOfLaunchLable.text  = dateFormatter(utcDate: launches[indexPath.row].dateUtc)
        cell.isSucsessImage.image = UIImage(named: launches[indexPath.row].success! ? "true" : "false")
            
        
        return cell
    }
    
    
    
}




