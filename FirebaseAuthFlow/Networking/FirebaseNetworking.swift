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
    
    
    /// This function is responsible for connecting to firebase and requesting the server send a six digit auth code to the user specified phone number
    /// - Parameters:
    ///   - phoneNumber: the phone number the user wished the code be sent to
    ///   - errorCompletion: a completion block for use when firebase returns an error
    ///   - successCompletion: a completion block to be used when the code is successfully sent to the given number
    func sendCodeTextTo(_ phoneNumber: String, errorCompletion: @escaping (Error?) -> Void, successCompletion: @escaping (Bool) -> Void) {
        //filter out anything that is not a number or a plus sign
        let rawVal = phoneNumber.filter(phoneNumCharSet.contains)
        //call the necessary firebase method to send the six digit code
        PhoneAuthProvider.provider().verifyPhoneNumber(rawVal, uiDelegate: nil) { (verificationID, error) in
          if let error = error { //propogate any errors through the error completion
            errorCompletion(error)
            return
          }
            if let verID = verificationID {//store the verificationID returned from firebase in user defaults to be used later once the user has entered the six digit text code. Return that the code was sent successfully
                UserDefaults.standard.set(verID, forKey: Constants.authIdKey)
                successCompletion(true)
            }
        }
    }
    
    
    /// This function is responsible for connecting to firebase and exchanging the user entered six digit code along with the previously stored verificationID to sign in
    /// - Parameters:
    ///   - verificationCode: six digit code that was texted to the user's phone number and then entered on the onboarding screen
    ///   - errorCompletion: a completion block for use when firebase returns an error
    ///   - successCompletion: a completion block used to echo back a successful sign in
    func verifyCode(_ verificationCode: String, errorCompletion: @escaping (Error?) -> Void, successCompletion: @escaping (Bool) -> Void) {
        //fetch the verificationID previously saved to user defaults
        guard let verificationID = UserDefaults.standard.string(forKey: Constants.authIdKey) else {
            errorCompletion(OnboardingError.noVerificationIDStored)
            return
        }
        //use the verificationID and the six digit code to create a firebase credential
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        //send the credential to firebase as a login attempt
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {//propogate any errors to the parent class
                errorCompletion(error)
            }
            if let result = authResult {//if the login attempt succeeds firebase will send back an authResult containing the uid for the user and their profile
                successfulSignIn(result)
                successCompletion(true)
            }
        }
    }
    
    
    func appleSignIn(idTokenString: String, nonce: String, errorCompletion: @escaping (Error) -> Void) {
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            // Error. If error.code == .MissingOrInvalidNonce, make sure
            // you're sending the SHA256-hashed nonce as a hex string with
            // your request to Apple.
            errorCompletion(error)
            return
          }
            if let result = authResult {
                successfulSignIn(result)
            }
        }
    }
    
    func successfulSignIn(_ result: AuthDataResult) {
        let uid = result.user.uid
        //save the new uid to user defaults
        //this will get picked up by the ViewRouter and change the currentView from .onboarding to .main
        UserDefaults.standard.set(uid, forKey: Constants.UIDKey)
        print("User default uid set from FirebaseNetworking")
    }
    
    
    
    func updateUserData(uid: String, newData: [String:Any], errorCompletion: @escaping (Error?) -> Void) {
        db.collection("users").document(uid).setData(newData, merge: true, completion: errorCompletion)
    }
    
}
