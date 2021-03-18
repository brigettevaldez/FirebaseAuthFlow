//
//  BigButton.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import SwiftUI

struct BigButton: View {
    
    @State var titleText: String
    @State var img: Image? = nil
    
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.slateBlue)
                    .frame(height: 56, alignment: .center)
                HStack {
                    if let btnImage = img {
                        btnImage
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 16, height: 16, alignment: .center)
                            .foregroundColor(.white)
                    }
                    Text(titleText)
                        .foregroundColor(.white)
                        .font(.medSixteen)
                }
            }
        
    }
}

struct BigButton_Previews: PreviewProvider {
    static var previews: some View {
        BigButton(titleText: "Big Button")
    }
}
