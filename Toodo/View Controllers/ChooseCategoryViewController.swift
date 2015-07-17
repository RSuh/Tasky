//
//  NewTaskViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-10.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class ChooseCategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var listTitle: UITextField!
    
    var newTask: Task?
    var newList: List?
    var badge = 0

    // Passing image to Home View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "saveToList") {
            let targetViewCell = segue.destinationViewController as! HomeViewController
            HomeViewController.load()
            targetViewCell.loadView()
        
            // Create a new List object
            newList = List()
            newList?.listTitle = "New List"
            //newList?.taskCount = 1
            newList?.badge = self.badge
        } else if (segue.identifier == "editList") {
            let targetViewCell = segue.destinationViewController as! HomeViewController
            HomeViewController.load()
            targetViewCell.loadView()
            
            // Create a new edited List Object
            newList?.badge = self.badge
            
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayConstants.cellImagesUnselected.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("badgeImage", forIndexPath: indexPath) as! badgeCollectionViewCell
        cell.chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("You have selected cell \(indexPath.row)")
        badge = indexPath.row
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! badgeCollectionViewCell
        cell.chooseBadgeImage.image = UIImage(named: "badgeFinance")


    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! badgeCollectionViewCell
        
        cell.backgroundColor = UIColor.clearColor()

        (collectionView.cellForItemAtIndexPath(indexPath) as! badgeCollectionViewCell).chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
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
