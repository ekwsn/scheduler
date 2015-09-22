//
//  MasterTableViewController.swift
//  Scheduler
//
//  Created by Lok on 01/09/2015.
//  Copyright (c) 2015 Lok. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    var eventObjects: NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() == nil){
            
            var logInViewController = PFLogInViewController()
            
            logInViewController.delegate = self
            
            var signUpViewController = PFSignUpViewController()
            
            signUpViewController.delegate = self
            
            logInViewController.signUpController = signUpViewController
            
            self.presentViewController(logInViewController, animated: true, completion: nil)
            
        } else {
            
            self.fetchAllObjectsFromLocalDatastore()
            self.fetchAllObjects()
            
            
        }
    }
    
    func fetchAllObjectsFromLocalDatastore(){
        
        var query: PFQuery = PFQuery(className: "Event")
        query.fromLocalDatastore()
        query.whereKey("Host", equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if (error == nil){
                
                var temp: NSArray = objects! as NSArray
                self.eventObjects = temp.mutableCopy() as! NSMutableArray
                self.tableView.reloadData()
                
            } else {
                
                println(error!.userInfo)
            }
            
        }
        
    }
    
    func fetchAllObjects(){
        
        //PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        
        var query: PFQuery = PFQuery(className: "Event")
        query.whereKey("Host", equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if (error == nil){
                
                PFObject.pinAllInBackground(objects, block: nil)
                self.fetchAllObjectsFromLocalDatastore()
                
            }else {
                
                println(error!.userInfo)
                
            }
            
        }
        
        
    }
    
    //MARK: Login VC
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty) {
            
            return true
            
        } else {
            
            return false
        
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        
        println("Failed to log in")
    }
    
    //MARK: Sign up VC
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        
        if let password = info ["password"] as? String {
            
            return count(password.utf16) >= 8
            
        }else {
            
            return false
        
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        
        println("Failed to sign up")
        
    }
    
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
        println("User dismissed Sign up")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.eventObjects.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MasterTableViewCell

        var object: PFObject = self.eventObjects.objectAtIndex(indexPath.row) as! PFObject
        
        var day: String = formatADate((object["Day"] as? NSDate!)!)
        
        cell.titleLabel?.text = object ["EventTitle"] as? String
        cell.dayLabel?.text = day
        //cell.startTimeLabel?.text = object["StartTime"] as? String
        //cell.endTimeLabel?.text = object["EndTime"] as? String
        cell.descriptionLabel?.text = object["Description"] as? String
        cell.hostLabel?.text = object["Host"] as? String
        
        
        return cell
    }
    

    //format date
    
    func formatADate(date:NSDate) -> String{
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let d = date
        let s:String = dateFormatter.stringFromDate(d)
        
        return s
    }

   
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
