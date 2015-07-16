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
    
    var newTask: Task?
    var newList: List?
    var cellImages: [String] = ["The file names of the images."]
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("badgeImage", forIndexPath: indexPath) as! badgeCollectionViewCell
        cell.badgeImage.image = UIImage(named: cellImages[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("You have pressed cell \(indexPath.row)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        // Create a Task object
        newTask = Task()
        newTask!.taskTitle = "New Task"
        
        
        // Create a new List object
        newList = List()
        newList?.listTitle = "New List"
        newList?.taskCount = 1
        //newList?.taskArray.insert("hi", atIndex: 0)
    }
}
