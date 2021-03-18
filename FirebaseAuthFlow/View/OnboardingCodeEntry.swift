//
//  OnboardingCodeEntry.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import SwiftUI

struct OnboardingCodeEntry: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: OnboardingEntryViewModel
    
    
    var body: some View {
            VStack(spacing: 30) {
                if viewModel.visibleError != nil { errorView }
                Spacer(minLength: 100)
            headerView
                CodeEntry(code: $viewModel.code)
                
                Spacer()
                Button(action: {
                    viewModel.resendCode()
                }, label: {
                    Text("Send me a new code")
                        .font(.medFourteen)
                        .foregroundColor(.slateBlue)
                })
                Button(action: {
                    viewModel.verifyCode()
                }, label: {
                BigButton(titleText: "Continue")
                    .padding(.bottom, 50)
                    .frame(width: 250)
                })
                NavigationLink(
                    destination: SetupGenderPicker(),
                    isActive: $viewModel.finished,
                    label: { })
                
                }.padding([.leading, .trailing], 50)
            .navigationBarBackButtonHidden(true)
           .navigationBarItems(leading: CustomBackButton(buttonTap: backBtnTapped))
            .background(viewBackground)
    }
    
    var headerView: some View {
        VStack(spacing: 15) {
            Text("STEP 2/2")
                .font(.medTwelve)
                .foregroundColor(.darkMustard)
                .tracking(1.5)
            
            Text("Verify your number")
                .font(.medTwentyFour)
                .foregroundColor(.space)
                .multilineTextAlignment(.center)
            
            Text("We'll text you at \(viewModel.phoneNum)")
                .font(.regSixteen)
                .foregroundColor(.navy)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                ProgressStepper(range: 0...2, fill: 2)
                    .frame(width: 120)
            }
        }
    }
    
    var phoneNumEntry: some View {
        Rectangle()
        //PhoneNumEntryView()
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

struct OnboardingCodeEntry_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCodeEntry(viewModel: OnboardingEntryViewModel())
    }
}
