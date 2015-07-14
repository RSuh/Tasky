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
            listTableView.reloadData()
        }
    }
    
    @IBAction func backtoList(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            let realm = Realm()
            switch {
            case:
            }
            
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
