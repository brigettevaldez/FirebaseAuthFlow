//
//  SignInWithAppleButton.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/24/21.
//

import SwiftUI

struct AlternativeSignInButton: View {

    var btnColor: Color
    var imgColor: Color
    var imgName: String
    var btnTap: () -> Void
    
    var body: some View {
        Button(action: {
            btnTap()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(btnColor)
                Image(imgName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(imgColor)
                    .padding(.all, 10)
                    .aspectRatio(1, contentMode: .fit)
            }
        })
    }
}

struct SignInWithAppleButton_Previews: PreviewProvider {
    static var previews: some View {
        AlternativeSignInButton(btnColor: Color("signInBtn"), imgColor: Color("bckColor"), imgName: "apple", btnTap: { print("Button Tapped") })
    }
}
