//
//  ViewController.swift
//  SpaceX
//
//  Created by Григорий Душин on 06.10.2022.
//

import UIKit

class RocketViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var images: [String] = ["0","1","2"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    
    //MARK: Arrays for recieving data from parsing loaders
    
    var rockets: [RocketModelElement] = []
    override func viewDidLoad() {
       
        super.viewDidLoad()

    //MARK: Recieving data from parsing loaders through escaping clousers
        
        RocketLoader().rocketDataLoad { rockets in
            DispatchQueue.main.async{
            self.rockets = rockets
            self.testLabel.text = rockets[0].name
            }
        }
        
        
        //MARK: - PageControll
        
        pageControll.numberOfPages = images.count
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - ScrollView method
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControll.currentPage = Int(pageNumber)
    }

}

