//
//  OnboardingPhoneEntry.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import SwiftUI

import SwiftUI

struct OnboardingPhoneEntry: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: OnboardingEntryViewModel = OnboardingEntryViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            if viewModel.visibleError != nil { errorView }
            Spacer(minLength: 100)
            headerView
            PhoneNumEntryView(viewModel: viewModel)
            
            Spacer()
            BigButton(titleText: "Verify Now")
                .padding(.bottom, 50)
                .frame(width: 250)
                .onTapGesture {
                    viewModel.sendTextCode()
                }
            NavigationLink(
                destination: OnboardingCodeEntry(viewModel: viewModel),
                isActive: $viewModel.nextPage,
                label: {  })
        }.padding([.leading, .trailing], 50)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton(buttonTap: backBtnTapped))
        .background(viewBackground)
    }
    
    var headerView: some View {
        VStack(spacing: 15) {
            Text("STEP 1/2")
                .font(.medTwelve)
                .foregroundColor(.darkMustard)
                .tracking(1.5)
                .shadow(color: .white, radius: 2, x: 0.0, y: 0.0)
                
            
            Text("Let's start with your mobile number")
                .font(.medTwentyFour)
                .foregroundColor(.space)
                .multilineTextAlignment(.center)
            
            Text("Number we can use to reach you")
                .font(.regSixteen)
                .foregroundColor(.navy)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                ProgressStepper(range: 0...2, fill: 1)
                    .frame(width: 120)
            }
        }
    }
    
    var errorView: some View {
        HStack {
            Spacer()
            Image.warning
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.slateBlue)
                .frame(width: 18, height: 18, alignment: .center)
            Text(viewModel.visibleError?.localizedDescription ?? "")
                .font(.medTwelve)
            Spacer()
        }
        
    }
    
    
    func backBtnTapped() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct PhoneNumEntry_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPhoneEntry()
    }
}

