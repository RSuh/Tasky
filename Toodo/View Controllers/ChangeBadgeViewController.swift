//
//  ChangeBadgeViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-27.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class ChangeBadgeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var badgeImage: UICollectionView!
    
    var addButtonColor = ""
    
    var badge = 0
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayConstants.cellImagesUnselected.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("badgeImage", forIndexPath: indexPath) as!
            CategoryCollectionViewCell
        cell.chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        badge = indexPath.row
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCollectionViewCell
        
        // Makes the checkmark non-hidden when you click
        cell.checkmarkImage.hidden = false
        
        if (addButtonColor == "addPurple") {
            cell.checkmarkImage.image = UIImage(named: "checkmarkPurple")
        } else if (addButtonColor == "addRed") {
            cell.checkmarkImage.image = UIImage(named: "checkmarkRed")
        } else if (addButtonColor == "addTurquoise") {
            cell.checkmarkImage.image = UIImage(named: "checkmarkTurquoise")
        } else if (addButtonColor == "addBlue") {
            cell.checkmarkImage.image = UIImage(named: "checkmarkBlue")
        } else {
            cell.checkmarkImage.image = UIImage(named: "checkmarkDark")
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCollectionViewCell
        
//        cell.backgroundColor = UIColor.clearColor()
//        
//        (collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCollectionViewCell).chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
        
        // Hides the checkmark when the cell is deselected
        cell.checkmarkImage.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
