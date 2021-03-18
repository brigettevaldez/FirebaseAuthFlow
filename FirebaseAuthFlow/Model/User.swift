//
//  User.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import Foundation

enum Gender: String {
    case male = "male"
    case female = "female"
    case other = "other"
}

class User: ObservableObject {
    @Published var uid: String
    
    @Published var gender: Gender?
    @Published var names: [String]?
    
    
    init(uid: String, data: [String:Any]) {
        self.uid = uid
        
        if let namesArr = data["names"] as? [String] {
            names = namesArr
        } else { names = [] }
        if let genderStr = data["gender"] as? String {
            gender = Gender(rawValue: genderStr)
        } else { gender = nil }
        
    }
    
    var age: Int? {
        return 22
    }
    
    var needsSetup: Bool {
        if gender != nil && names != nil  {
            print("user does not need further setup")
            return false
        } else {
            print("user needs further setup")
            print(self.printDescription)
            return true
        }
    }
    
    var printDescription: String {
        var str = "UID: \(uid)\n"
        str += "Names: \(String(describing: names))\n"
        str += "Gender: \(String(describing: gender))\n"
        
        return str
    }
    

}

