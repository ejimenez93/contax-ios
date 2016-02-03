//
//  ViewController.swift
//  Contax
//
//  Created by Edison Jimenez on 1/30/16.
//
//

import UIKit
import Firebase

class ContactViewController: UIViewController {
    
    var contactLoaded:Person?
    
    var firebaseRef:Firebase?
    
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var dateOfBirthField: UITextField!
    @IBOutlet var zipcodeField: UITextField!
    
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var contactLabel: UILabel!
    
    // Use a DatePicker keyboard for the "Date of Birth" field
    @IBAction func dateOfBirthEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    // Show the DatePicker keyboard upon editing
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        dateOfBirthField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    // Close this View Controller and go back to the main screen
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    // Validate input then save to Firebase
    @IBAction func saveContactPressed(sender: AnyObject) {
        
        var popupTitle:String?
        var popupMessage:String?
        var validForm = false
        
        // Validate Input Fields
        if (firstNameField.text?.isEmpty == true || lastNameField.text?.isEmpty == true) {
            popupTitle = "Missing Fields"
            popupMessage = "First Name and Last Name fields are requried"
        }
        else {
            validForm = true
        }
        
        if (validForm == false) {
            let alertController = UIAlertController(title: popupTitle, message: popupMessage, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in })
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            contactLoaded = Person(id: firebaseRef!.key, firstName: firstNameField.text!, lastName: lastNameField.text!, dateOfBirth: dateOfBirthField.text!, zipcode: zipcodeField.text!)
            
            firebaseRef!.setValue(contactLoaded!.toDictionary(), withCompletionBlock: { (error, ref) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        
        
        
    }
    
    // Show a confirmation to the user before deleting a contact
    // Proceed with Contact(Person) deletion if confirmed
    @IBAction func deleteContactPressed(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Delete Contact", message: "Are you sure you want to delete this contact?", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "No", style: .Default) { (action:UIAlertAction!) in })
            alertController.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (UIAlertAction) -> Void in
                
                self.firebaseRef!.removeValueWithCompletionBlock({ (error, ref) -> Void in
                    if (error != nil) {
                        print("An error has occurred")
                    }
                    else {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                })
            }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // If we are UPDATING an entry, load the existing ID
        if (contactLoaded != nil) {
           firebaseRef = AppDelegate.sharedFirebaseInstance.childByAppendingPath("\(contactLoaded!.getID())")
        }
        // If we are creating a NEW entry, load up an auto-generated entry ID for our Contact(Person)
        else {
            firebaseRef = AppDelegate.sharedFirebaseInstance.childByAutoId()
        }
        
        if (contactLoaded == nil) {
            // Disable the 'Delete Contact' button if creating a NEW entry
            deleteButton.enabled = false
            // Hide the Contact's Label if creating a NEW entry
            contactLabel.hidden = true
        }
        else {
            //print(firebaseRef!.valueForKeyPath("firstName"))
            contactLabel.text = contactLoaded!.getFullName()
            
            firstNameField.text = contactLoaded!.getFirstName()
            lastNameField.text = contactLoaded!.getLastName()
            dateOfBirthField.text = contactLoaded!.getDateOfBirth()
            zipcodeField.text = contactLoaded!.getZipcode()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Text Field and Input Functions to:
    // 1 - Allow user to tap outside the keyboard to close it
    // 2 - Allow a flow between textfields so that user can press "Next" to navigate to the next available item
    // 3 - Set a character limit on any specified fields
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        if (nextResponder != nil) {
            nextResponder?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool
    {
        // Limit zipcode field to a max of 5 characters
        if (textField.isEqual(zipcodeField)) {
            let maxLength = 5
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= maxLength
        }
        
        return true
        
    }

}

