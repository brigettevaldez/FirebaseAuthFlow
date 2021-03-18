//
//  Constants.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import Foundation
import SwiftUI

struct Constants {
    
    //UserDefault keys
    static let UIDKey = "uid"
    static let authIdKey = "authVerificationID"
    
}

var viewBackground: some View {
    LinearGradient(gradient: Gradient(colors: [Color(red: 244/255, green: 246/255, blue: 250/250), Color(red: 244/255, green: 246/255, blue: 250/250), .white]), startPoint: .top, endPoint: .bottom)
        .offset(x: 0, y: -100)
}
