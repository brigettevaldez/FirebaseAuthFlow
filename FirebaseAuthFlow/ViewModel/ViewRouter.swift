//
//  ViewRouter.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import Foundation
import SwiftUI
import Combine 
import FirebaseFirestore


/// The ViewRouter is created at the same time as the App. It watches the user credentials in user defaults and controls the current scene of the app
class ViewRouter: ObservableObject {
    
    
    private var userDocListener: ListenerRegistration?
    private var uidObserver: NSObject? = nil
    private var subscribers: Set<AnyCancellable> = []
    
    @Published var currentView: ActiveTabView = .main
    @Published var user: User?
    @UserDefault(key: .UIDKey) var userDefaultUserUID: String?

    

    init() {
        if let _ =  UserDefaults.standard.string(forKey: Constants.UIDKey) { //if there is a uid stored in user defaults we do not need to sign in and can simply show the main page
            currentView = .main
        } else {
            print("ViewRouter init reported no uid stored. ActiveTab will be set to onboarding")
            currentView = .onboarding
        }
        //start an observer on currentView
        $currentView.sink { (newActiveView) in
            print("Current view updated to -> \(self.currentView)")
        }.store(in: &subscribers)
        
        /// Start an observer on userDefaultUserUID to alert this class when the user default is changed
        uidObserver = $userDefaultUserUID.observe { old, new in
            if  self.validateUID(new) {
                self.currentView = .main
            } else {
                self.currentView = .onboarding
            }
        }
    }
    
    deinit {
        userDocListener = nil
        uidObserver = nil
        subscribers = []
    }
    
    
    /// Simple function to determine if a string is a valid uid
    /// - Parameter uid: uid to test
    /// - Returns: a bool if the uid is valid or not
    func validateUID(_ uid: String?) -> Bool {
        //check that the string exists and is longer than 1 char
        guard let uid = uid,
              uid.count > 0 else {
            print("Failed to start uid listener. Valid uid not found")
            return false
        }
        return true
    }
    
    
    /// Request a snapshot listener from firebase for the user doc cooresponding to the signed in user
    /// - Parameter uid: signed in user uid
    func setUidDocListener(uid: String?) {
        guard let _uid = uid,
              validateUID(uid) else { //if the uid is not valid set the active tab to .onboarding so the user sign's in again
            self.currentView = .onboarding
            return
        }
        
        print("Attempting to add user doc listener")
        userDocListener = FirebaseNetworking().db.collection("users").document(_uid).addSnapshotListener({  (snapshot, error) in
            //this completion block is triggered once when originally called and then again anytime there is a change to the doc in firebase
            if let error = error { print("error with snapshot listener: \(error.localizedDescription)") }
            if let snapshot = snapshot {
                print("User doc snapshot returned")
               if let data = snapshot.data() {
                    let usr = User(uid: _uid, data: data)
                    print("change reported for user doc.\n \(usr.printDescription)")
                    self.user = usr
               } else { print("No data included in returned snapshot for user doc") }
            }
        })
    }
    
}


/// This enum is for which scene is currently active in the app
enum ActiveTabView {
    case main
    case accountSetup
    case onboarding
}


