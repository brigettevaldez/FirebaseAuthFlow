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
    
    var userDocListener: ListenerRegistration?
    var uidObserver: NSObject? = nil
    
    @Published var user: User?
    
    
    @UserDefault(key: .UIDKey) var userUID: String?

    
    @Published var currentView: ActiveTabView = .main
    private var subscribers: Set<AnyCancellable> = []
   
    
    init() {
        if let _ =  UserDefaults.standard.string(forKey: Constants.UIDKey) { //if there is a uid stored in user defaults we do not need to sign in and can simply show the main page
            currentView = .main
        } else {
            print("No uid stored. Please sign in")
            currentView = .onboarding
        }
        $currentView.sink { (newActiveView) in
            print("Current view updated to -> \(self.currentView)")
        }.store(in: &subscribers)
        
        /// Start an observer on userUID to alert this class when the user default is changed
        print("setting uid observer")
        uidObserver = $userUID.observe { old, new in
            if  self.validateUID(new) {
                self.currentView = .main
            } else {
                self.currentView = .onboarding
            }
        }
    }
    
    deinit {
        userDocListener = nil
        subscribers = []
    }
    
    /* func startUserDocListener(uid: String?) -> Bool {
        guard let uid = uid,
              uid.count > 0 else {
            print("Failed to start uid listener. Valid uid not found")
            return false
        }
        self.setUidListener(uid: uid)
        return true
    }
    */
    

    
    func validateUID(_ uid: String?) -> Bool {
        guard let uid = uid,
              uid.count > 0 else {
            print("Failed to start uid listener. Valid uid not found")
            return false
        }
        return true
    }
    
    
    func setUidDocListener(uid: String?) {
        guard let _uid = uid,
              validateUID(uid) else {
            self.currentView = .onboarding
            return
        }
        
        print("Attempting to add user doc listener")
        userDocListener = FirebaseNetworking().db.collection("users").document(_uid).addSnapshotListener({  (snapshot, error) in
            print("User doc snapshot returned")
            if let error = error { print("error with snapshot listener: \(error.localizedDescription)") }
            if let snapshot = snapshot {
               if let data = snapshot.data() {
                let usr = User(uid: _uid, data: data)
                print("change reported for user doc.\n \(usr.printDescription)")
                self.user = usr
               }
            }
        })
    }
    
}

enum ActiveTabView {
    case main
    case accountSetup
    case onboarding
}


