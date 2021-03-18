//
//  FirebaseNetworking.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct FirebaseNetworking {
    
    let phoneNumCharSet = "0123456789+"
    
    var db: Firestore = Firestore.firestore()
    
    func sendCodeTextTo(_ phoneNumber: String, errorCompletion: @escaping (Error?) -> Void, successCompletion: @escaping (Bool) -> Void) {
        let rawVal = phoneNumber.filter(phoneNumCharSet.contains)
        PhoneAuthProvider.provider().verifyPhoneNumber(rawVal, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            errorCompletion(error)
            return
          }
            if let verID = verificationID {
                UserDefaults.standard.set(verID, forKey: Constants.authIdKey)
                successCompletion(true)
            }
        }
    }
    
    
    func verifyCode(_ verificationCode: String, errorCompletion: @escaping (Error?) -> Void, successCompletion: @escaping (Bool) -> Void) {
        guard let verificationID = UserDefaults.standard.string(forKey: Constants.authIdKey) else {
            errorCompletion(OnboardingError.noVerificationIDStored)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                errorCompletion(error)
            }
            if let result = authResult {
                let uid = result.user.uid
                UserDefaults.standard.set(uid, forKey: Constants.UIDKey)
                print("User default uid set")
                successCompletion(true)
            }
        }
    }
    
    func updateUserData(uid: String, newData: [String:Any], errorCompletion: @escaping (Error?) -> Void) {
        db.collection("users").document(uid).setData(newData, merge: true, completion: errorCompletion)
    }
    
}
