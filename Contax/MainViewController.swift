//
//  MainViewController.swift
//  Contax
//
//  Created by Edison Jimenez on 1/30/16.
//

import UIKit
import Firebase

class MainViewController: UITableViewController {
    
    
    @IBAction func addNewPerson(sender: AnyObject) {
        self.navigationController!.performSegueWithIdentifier("showNewContactViewController", sender: self)
    }
    
    var firebaseRef = AppDelegate.sharedFirebaseInstance
    var dataSource: FirebaseTableViewDataSource!
    var personsArray:FirebaseArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the list of contacts alphabetically ordered by last name
        self.dataSource = FirebaseTableViewDataSource(query: self.firebaseRef.queryOrderedByChild("lastName"), cellReuseIdentifier: "personCell", view: self.tableView)
        
        
        // Populate each cell in the TableView with the Contact(Person)'s full name
        self.dataSource.populateCellWithBlock { (cell: UITableViewCell, obj: NSObject) -> Void in
            let snap = obj as! FDataSnapshot
            cell.textLabel?.text = snap.value.valueForKey("fullName") as? String
        }
        
        self.tableView.dataSource = self.dataSource
        personsArray = self.dataSource.array
        
        
        // Show/Hide "No Data" text on TableView depending on results
        firebaseRef.observeEventType(.Value, withBlock: {
            snapshot in
                self.toggleNoDataText(snapshot)
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let indexSelected = UInt(indexPath.row)
        
        let snap = personsArray!.objectAtIndex(indexSelected) as! FDataSnapshot
        
        let personSelected = Person(id: snap.value.valueForKey("id") as! String, firstName: snap.value.valueForKey("firstName") as! String, lastName: snap.value.valueForKey("lastName") as! String, dateOfBirth: snap.value.valueForKey("dateOfBirth") as! String, zipcode: snap.value.valueForKey("zipcode") as! String)
        
        self.navigationController?.performSegueWithIdentifier("showEditContactViewController", sender: personSelected)
        return;
    }
    
    // Function to show/hide the TableView's backgroundView depending on the results
    func toggleNoDataText(snapshot: FDataSnapshot) {
        if (!snapshot.exists()) {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            
            noDataLabel.text = "No contacts available. Tap on the + icon above to add a new contact."
            noDataLabel.textAlignment = NSTextAlignment.Center
            noDataLabel.numberOfLines = 0
            
            noDataLabel.sizeToFit()
        
            self.tableView.backgroundView = noDataLabel
        }
        else {
            self.tableView.backgroundView = nil
        }
    }
}
