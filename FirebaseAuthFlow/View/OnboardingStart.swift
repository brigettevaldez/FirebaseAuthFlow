//
//  OnboardingStart.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import SwiftUI

struct OnboardingStart: View {
    
    let appName = "App Name Here"
    
    var body: some View {
        VStack {
            Image.appIcon
                .resizable()
                .frame(width: 70, height: 70, alignment: .center)
                .padding(.top, 100)
            Text("Welcome to")
                .font(.medTwentyEight)
                .foregroundColor(.space)
            Text(appName)
                .font(.medTwentyEight)
                .foregroundColor(.slateBlue)
            Spacer()
            NavigationLink(
                destination: OnboardingPhoneEntry(),
                label: {
                    BigButton(titleText: "Get Started")
                        .frame(width: 250)
                      
                }).buttonStyle(PlainButtonStyle())
                
                .padding(.bottom, 50)
        }
    
    }
    
}

struct OnboardingStart_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStart()
    }
}
