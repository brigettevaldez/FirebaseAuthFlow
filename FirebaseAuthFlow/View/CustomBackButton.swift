//
//  CustomBackButton.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import SwiftUI

struct CustomBackButton: View {
    
    let buttonTap: () -> Void
    var color: Color?
    
    var body: some View {
        Button(action: {
            buttonTap()
        }, label: {
            Image.backArrow
                .resizable()
                .renderingMode(color != nil ? .template : .original)
                .foregroundColor(color)
                .scaledToFit()
                .frame(width: 24, height: 24, alignment: .center)
        })
    }
    
}

struct CustomBackButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomBackButton(buttonTap: { print("Button Tapped") })
    }
}
