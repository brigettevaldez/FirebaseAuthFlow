//
//  MainPage.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import SwiftUI

struct MainPage: View {
    
    
    var body: some View {
        VStack {
        Text("Main Page!")
            Spacer() 
            Button(action: {
                UserDefaults.standard.removeObject(forKey: Constants.UIDKey)
            }, label: {
                BigButton(titleText: "Sign Out")
            })
        }.padding(.all, 50)
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
