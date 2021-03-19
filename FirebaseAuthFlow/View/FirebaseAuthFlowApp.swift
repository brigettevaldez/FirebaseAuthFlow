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

        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        
    }
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                switch viewRouter.currentView {
                case .onboarding:
                    OnboardingStart()
                case .accountSetup:
                    OnboardingStart()
                case .main:
                    MainPage()
                        .onAppear() {
                            let _ = viewRouter.setUidDocListener(uid: UserDefaults.standard.string(forKey: Constants.UIDKey))
                        }
                }
            }
        }
    }
}
