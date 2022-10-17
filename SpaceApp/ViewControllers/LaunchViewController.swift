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
    func launchLoader(id: String){
        LaunchLoader().launchDataLoad(id: id) { launches in
            DispatchQueue.main.async{
            self.launches = launches
            self.launchCollectionView.reloadData()
                print(launches[0].dateUtc)
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
        cell.configure(rocket: launches[indexPath.row])
                    
        return cell
    }
    
    
    
}




