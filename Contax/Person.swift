//
//  Person.swift
//  Contax
//
//  Created by Edison Jimenez on 1/30/16.
//
//

import Foundation

class Person {
    
    // Properties of a Person (Contact)
    var id:String
    var firstName:String
    var lastName:String
    var fullName:String
    var dateOfBirth:String
    var zipcode:String
    
    // Constructors

    init(id: String, firstName: String, lastName: String, dateOfBirth: String, zipcode: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = firstName + " " + lastName
        self.dateOfBirth = dateOfBirth
        self.zipcode = zipcode
    }
    
    // Getters
    func getID() -> String {
        return id
    }
    
    func getFirstName() -> String {
        return firstName
    }
    
    func getLastName() -> String {
        return lastName
    }
    
    func getFullName() -> String {
        return fullName
    }
    
    func getDateOfBirth() -> String {
        return dateOfBirth
    }
    
    func getZipcode() -> String {
        return zipcode
    }
    
    
    // Setters
    func setID(key: String) {
        self.id = key
    }
    
    func setFirstName(fName: String) {
        self.firstName = fName
    }
    
    func setLastName(lName: String) {
        self.lastName = lName
    }
    
    func setFullName(fullN: String) {
        self.fullName = fullN
    }
    
    func setDateOfBirth(DOB: String) {
        self.dateOfBirth = DOB
    }
    
    func setZipcode(zip: String) {
        self.zipcode = zip
    }
    
    // Helper Functions
    func toDictionary() -> NSDictionary {
        let output = ["id": id, "firstName": firstName, "lastName": lastName, "fullName": fullName, "dateOfBirth": dateOfBirth, "zipcode": zipcode]
        return output
    }
    
}