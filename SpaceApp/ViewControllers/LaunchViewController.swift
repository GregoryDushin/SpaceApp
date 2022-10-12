//
//  LaunchViewController.swift
//  SpaceX
//
//  Created by Григорий Душин on 09.10.2022.
//

import UIKit

class LaunchViewController: UIViewController {
    
    @IBOutlet weak var LaunchCollectionView: UICollectionView!
    
    var launches: [LaunchModelElement] = []
    
    var id = "5e9d0d95eda69955f709d1eb"   //just for testing (Falcon 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Falcon 1"
        
        LaunchLoader().launchDataLoad(id: id) { launches in
            self.launches = launches
            self.LaunchCollectionView.reloadData()
        }
        
    }
    
    //MARK: Date formatter from UTC to Local
    
    func dateFormatter (utcDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let result = dateFormatter.date(from: utcDate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: result!)
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
       

        
         
        
        // TODO упростить в одну строчку
        
        if launches[indexPath.row].success == true {
            
         //   cell.isSucsessImage.image = UIImage(named: true ? "true" : "false")
            
            cell.isSucsessImage.image = UIImage(named: "true")

        } else {

            cell.isSucsessImage.image = UIImage(named: "false")
            
        }
        
        return cell
    }
    
    
    
}




