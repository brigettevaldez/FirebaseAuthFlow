//
//  PhoneNumEntryView.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import SwiftUI

struct PhoneNumEntryView: View {
    
    @ObservedObject var viewModel: OnboardingEntryViewModel
    
    let phoneNumMaskStr = "(XXX) XXX-XXXX"
    var columns: [GridItem] =
        Array(repeating: .init(.flexible()), count: 1)
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .shadow(color: .shadowBlue, radius: 20, x: 0.0, y: 0.0)
                .frame(height: 60)
            HStack(alignment: .top, spacing: 0) {
                countryCodePicker
                    .frame(width: 80)
                    .mask(maskRect)
                openDropDownBtn
                    .padding(.top, 22)
                Rectangle()
                    .frame(width: 10)
                    .foregroundColor(.clear)
                phoneNumEntry
                    .padding(.top, 17)
            }.padding([.leading, .trailing], 15)
        }
    }
    
    var maskRect: some View {
        VStack {
            Rectangle()
                .frame(maxHeight: viewModel.open ? .infinity : 60)
            Spacer()
        }
    }
    
 
    var openDropDownBtn: some View {
        Button(action: {
            viewModel.open.toggle()
            viewModel.deselectCountry()
        }, label: {
            Image.arrowIcon
                .resizable()
                .renderingMode(.template)
                .frame(width: 15, height: 15, alignment: .center)
                .rotationEffect(Angle(degrees: 180))
                .foregroundColor(.lavendarGrey)
        })
    }
    
    var countryCodePicker: some View {
        ScrollViewReader { scrollView in
            ScrollView(.vertical , showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.activeCountryCodes, id: \.self.code) { country in
                        Button(action: {
                            withAnimation {
                                scrollView.scrollTo(country.code, anchor: .top)
                                viewModel.open.toggle()
                                viewModel.selectCountry(country)
                            }
                        }, label: {
                        HStack {
                            ZStack {
                                Text(country.flag())
                                    .font(.title)
                            }
                            Text(country.dial_code)
                                .font(.boldTwelve)
                                .frame(height: 60)
                            Spacer(minLength: 0)
                        }
                        }).buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .onAppear() {
                scrollView.scrollTo("US", anchor: .top)
            }
           
        }
    }
    
   

    var phoneNumEntry: some View {
        
        TextField(phoneNumMaskStr, text: $viewModel.phoneNum)
            .keyboardType(.numberPad)
            .onChange(of: viewModel.phoneNum) { value in
                viewModel.phoneNum = viewModel.phoneNum.format(with: phoneNumMaskStr)
            }
    }
    
    
}

struct PhoneNumEntryView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumEntryView(viewModel: OnboardingEntryViewModel())
    }
}
