//
//  OnboardingStart.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import SwiftUI

struct OnboardingStart: View {
    
    @State var nextPage: Bool = false
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
                isActive: $nextPage,
                label: {
                    BigButton(titleText: "Get Started")
                        .frame(width: 250)
                })
           
                
                .padding(.bottom, 50)
        }
    
    }
    
}

struct OnboardingStart_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStart()
    }
}
