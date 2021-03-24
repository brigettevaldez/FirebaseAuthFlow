//
//  SignInWithAppleDelegates.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/24/21.
//


import UIKit
import SwiftUI
import AuthenticationServices
import Contacts
import CryptoKit

class SignInWithAppleViewModel: NSObject {
    
    private weak var window: UIWindow!
    @Binding var errorStr: String?
    
    fileprivate var currentNonce: String?
    
    init(window: UIWindow?, errorStr: Binding<String?>) {
        self.window = window
        self._errorStr = errorStr
        super.init()
        currentNonce = self.randomNonceString()
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

}

extension SignInWithAppleViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
          fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetch identity token")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
          return
        }
        FirebaseNetworking().appleSignIn(idTokenString: idTokenString, nonce: nonce, errorCompletion: errorCompletion(_:))
      }
    }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error
    errorCompletion(error)
  }
    
    func errorCompletion(_ error: Error) {
        self.errorStr = error.localizedDescription
    }
}

extension SignInWithAppleViewModel: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.window
  }
}
