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


class ViewRouter: ObservableObject {
    
    var userDocListener: ListenerRegistration?
    var uidObserver: NSObject? = nil
    
    @Published var user: User?
    
    
    @UserDefault(key: .UIDKey) var userUID: String?

    
    @Published var currentView: ActiveTabView = .main
    private var subscribers: Set<AnyCancellable> = []
   
    
    init() {
       // UserDefaults.standard.removeObject(forKey: Constants.UIDKey)
        if let _ =  UserDefaults.standard.string(forKey: Constants.UIDKey) {
            currentView = .main
        } else {
            print("No uid stored. Please sign in")
            currentView = .onboarding
        }
        $currentView.sink { (newActiveView) in
            print("Current view updated to -> \(self.currentView)")
        }.store(in: &subscribers)
        startUIDObserver()
    }
    
    deinit {
        userDocListener = nil
        subscribers = []
    }
    
    func startUserDocListener(uid: String?) -> Bool {
        guard let uid = uid,
              uid.count > 0 else {
            print("Failed to start uid listener. Valid uid not found")
            return false
        }
        self.setUidListener(uid: uid)
        return true
    }
    
    
    private func startUIDObserver() {
        print("setting uid observer")
        uidObserver = $userUID.observe { old, new in
            if  self.startUserDocListener(uid: new) {
                self.currentView = .main
            }
            /*guard let uid = new,
                  uid.count > 0 else {
                print("Failed to start uid listener. Valid uid not found")
                return
            }
            //self.setUidListener(uid: uid)
            self.currentView = .main*/
        }
    }
    
    private func setUidListener(uid: String) {
        print("Adding user doc listener")
        userDocListener = FirebaseNetworking().db.collection("users").document(uid).addSnapshotListener({  (snapshot, error) in
            print("User doc snapshot returned")
            if let error = error { print("error with snapshot listener: \(error.localizedDescription)") }
            if let snapshot = snapshot {
               if let data = snapshot.data() {
                let usr = User(uid: uid, data: data)
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


