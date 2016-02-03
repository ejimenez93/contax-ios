//
//  ContactListNavigationViewController.swift
//  Contax
//
//  Created by Edison Jimenez on 2/1/16.
//
//

import UIKit

class ContactListNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewNavController = segue.destinationViewController as! ContactDetailNavigationViewController
        let viewController = viewNavController.topViewController as! ContactViewController
        
        if (segue.identifier! == "showEditContactViewController") {
            viewNavController.topViewController?.title = "Edit Contact"
            viewController.contactLoaded = sender! as! Person
        }
        else if (segue.identifier! == "showNewContactViewController"){
            viewNavController.topViewController?.title = "New Contact"
        }
    }

}
