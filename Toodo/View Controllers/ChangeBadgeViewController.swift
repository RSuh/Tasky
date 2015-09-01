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
    
    var selectedRow: Int = 0
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //println(arrayConstants.cellImagesUnselected.count - 1)
        return arrayConstants.cellImagesUnselected.count - 1

    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("badgeImage", forIndexPath: indexPath) as!
            CategoryCollectionViewCell
        cell.chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
        
        if (indexPath.row == selectedRow) {
            cell.checkmarkImage.hidden = false
        } else {
            cell.checkmarkImage.hidden = true
        }
        
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
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        badge = indexPath.row
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCollectionViewCell
        
        self.selectedRow = indexPath.row
        
        //UIView.animateWithDuration(1, animations: UIViewAnimationOptions.CurveEaseIn)
        
        collectionView.reloadData()

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
