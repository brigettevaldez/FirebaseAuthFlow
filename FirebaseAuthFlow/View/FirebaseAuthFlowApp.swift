//
//  FirebaseAuthFlowApp.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import SwiftUI

@main
struct FirebaseAuthFlowApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var viewRouter: ViewRouter
    
    
    init() {
        self.viewRouter = ViewRouter()
    }
    
    
    var body: some Scene {
        WindowGroup {
            switch viewRouter.currentView {
            case .onboarding:
                OnboardingStart()
            case .accountSetup:
                OnboardingStart()
            case .main:
                MainPage()
                    .onAppear() {
                        let _ = viewRouter.startUserDocListener(uid: UserDefaults.standard.string(forKey: Constants.UIDKey))
                    }
            }
        }
    }
}
