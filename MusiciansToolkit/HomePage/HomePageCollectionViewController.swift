//
//  HomePageCollectionViewController.swift
//  MusiciansToolkit
//
//  Created by Mark Pizzutillo on 11/5/18.
//  Copyright © 2018 Mark Pizzutillo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "homePageCell"

class HomePageCollectionViewController: UICollectionViewController {
    
    let model = Model.sharedInstance
    
    let shadowOffset:Int = 5
    let cornerRadius:CGFloat = 5.0
    let selectedBorderWidth:CGFloat = 3.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set navigation bar appearance
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: model.backgroundImages[1])!.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        self.collectionView?.allowsSelection = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Remove border from cells
        for cell in (collectionView?.visibleCells)! {
            cell.layer.borderWidth = 0
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7501070205)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return model.toolNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let homeCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomePageCell
        
        if let image = UIImage(named: model.imageNames[indexPath.row]) {
            
            homeCell.imageView.image = image
            homeCell.imageView.contentMode = .scaleAspectFit
        }
        
        homeCell.nameLabel.text = model.toolNames[indexPath.row]
        
        homeCell.layer.shadowOffset = CGSize(width: shadowOffset, height: shadowOffset)
        
        homeCell.layer.cornerRadius = 5.0
        homeCell.layer.masksToBounds = true;
        
        homeCell.layer.borderColor = UIColor.gray.cgColor
        
        homeCell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7501070205)
        return homeCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.backgroundColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        cell?.layer.borderWidth = selectedBorderWidth
        
        performSegue(withIdentifier: model.segueNames[indexPath.row], sender: self)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
