//
//  HomeViewController.swift
//  Toodo
//
//  Created by Reginald Suh on 2015-07-14.
//  Copyright (c) 2015 ReginaldSuh. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    // Reloads the lists everytime the page loads.
    var lists: Results<List>! {
        didSet {
            listTableView?.reloadData()
        }
    }
    
    // A var of type List which indicates the selectedList
    var selectedList: List?
    
    @IBAction func backtoList(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            let realm = Realm()
            switch identifier {
            case "exitToList":
                println("exit from Choose to Home")
                
            case "saveToList":
                println("save from Choose to Home")
                
            default:
                println("failed")
                
                // NOTE: sort by number of tasks
                
                //        lists = realm.objects(List).sorted("listModificationDate", ascending: false)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let realm = Realm()
        //
        //        // Sets up the lists cells by the modificationDate
        //        lists = realm.objects(List).sorted("listModificationDate", ascending: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //        let realm = Realm()
        //        lists = realm.objects(List).sorted("listModificationDate", ascending: false)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Changes Nav bar color to green theme
        var navigation = self.navigationController?.navigationBar
        navigation?.barTintColor = UIColor(red: 48/255, green: 220/255, blue: 107/255, alpha: 80)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    //        if segue.identifier == "listToTask" {
    //            let targetVC = segue.destinationViewController as! EditTaskViewController
    //           targetVC.editedTask = selectedTask
    //        }
    //    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Initialize cell
        let cell = listTableView.dequeueReusableCellWithIdentifier("listCell", forIndexPath: indexPath) as! ListTableViewCell
        
        // Set up cell
        //        let row = indexPath.row
        //        let list = lists[row] as List
        //        cell.list = list
        
        cell.listTitle.text = "Testing"
        
        return cell
    }
    
    // How many rows are in the tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}