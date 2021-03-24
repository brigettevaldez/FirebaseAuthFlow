//
//  OnboardingStart.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import SwiftUI
import AuthenticationServices

struct OnboardingStart: View {

    let appName = "A Random Company"
    let buttonSpacing: CGFloat = 10

    @State var errorStr: String? = nil//"Error string testing. Error string testing. Error string testing"
    @State var nextPage: Bool = false
    @Environment(\.window) var window: UIWindow?
    @State var appleSignInDelegates: SignInWithAppleViewModel! = nil
    
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
            VStack(spacing: buttonSpacing) {
                NavigationLink(
                    destination: OnboardingPhoneEntry(),
                    isActive: $nextPage,
                    label: {
                        BigButton(titleText: "Use Phone Number")
                    })
                alternativeSignInMethods
                    .padding(.bottom, 50)
            }.frame(width: 250)
        }.overlay(errorView)
    }
    
    var errorView: some View {
        VStack {
            if let err = errorStr {
                HStack {
                    Image.warning
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.slateBlue)
                        .frame(width: 18, height: 18)
                    Text(err)
                        .font(.regTwelve)
                }
            }
            Spacer()
        }
    }
    
    var alternativeSignInMethods: some View {
        HStack(spacing: buttonSpacing) {
            AlternativeSignInButton(btnColor: Color("signInBtn"), imgColor: Color("bckColor"), imgName: "apple", btnTap: showAppleLogin)
            AlternativeSignInButton(btnColor: Color("facebook"), imgColor: Color.white, imgName: "facebook", btnTap: showFacebookLogin)
        }.frame(height: 40)
    }
    
    private func showFacebookLogin() {
        
    }
    
    private func showAppleLogin() {
      let request = ASAuthorizationAppleIDProvider().createRequest()
      // specify type of end user data you need
      request.requestedScopes = [.fullName, .email]
        performSignIn(using: [request])
    }
    
    private func performSignIn(using requests: [ASAuthorizationRequest]) {
        appleSignInDelegates = SignInWithAppleViewModel(window: window, errorStr: $errorStr)
      let controller = ASAuthorizationController(authorizationRequests: requests)
      controller.delegate = appleSignInDelegates
      controller.presentationContextProvider = appleSignInDelegates
      controller.performRequests()
    }

    
}

struct OnboardingStart_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStart()
    }
}
