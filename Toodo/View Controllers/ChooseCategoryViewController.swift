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
    var badge = 0
    var newList: List?

    // Passing image to Home View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "saveToList") {
            let targetViewCell = segue.destinationViewController as! HomeViewController
            HomeViewController.load()
            targetViewCell.loadView()
            //targetViewCell = imageSelected
            // Changes the background color when pressing saveToList.
            //targetViewCell.listTableView.backgroundColor = UIColor.blackColor()
//            targetViewCell.listTableView.
            
        }
        
//        //        // Create a Task object
//        newTask = Task()
//        newTask!.taskTitle = "New Task"
//        
//        
        // Create a new List object
        newList = List()
        newList?.listTitle = "New List"
        newList?.taskCount = 1
        newList?.badge = self.badge
//        //newList?.taskArray.insert("hi", atIndex: 0)
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
        var imageSelected = arrayConstants.cellImagesUnselected[indexPath.row]
        
        println(imageSelected)

    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! badgeCollectionViewCell
        
        cell.backgroundColor = UIColor.clearColor()

        (collectionView.cellForItemAtIndexPath(indexPath) as! badgeCollectionViewCell).chooseBadgeImage.image = UIImage(named: arrayConstants.cellImagesUnselected[indexPath.row])
    }
    

    // Create a for loop which sets each image in the deselected state by looping through the array of images.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
