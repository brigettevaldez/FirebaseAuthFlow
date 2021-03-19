//
//  OnboardingEntryViewModel.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import Foundation
import SwiftUI

class OnboardingEntryViewModel: ObservableObject {
    
    var countryCodes: [CountryCode]
    @Published var phoneNum: String = ""
    @Published var open: Bool = false
    @Published var activeCountryCodes: [CountryCode]
    @Published var selectedCode: String? = "+1"
    @Published var nextPage: Bool = false
    @Published var finished: Bool = false
    @Published var visibleError: Error? = nil
    @Published var code: String = ""
    
    init() {
        ///load in country code list from saved json file and save to the activeCountryCode array
        countryCodes = []
        if let path = Bundle.main.url(forResource: "PhoneCountryCodes", withExtension: "json") {
            do {
                let data = try Data(contentsOf: path, options: .alwaysMapped)
                let codes = try JSONDecoder().decode([CountryCode].self, from: data)
                countryCodes.append(contentsOf: codes)
               
            } catch let error{
                print("No country codes data available: \(error.localizedDescription)")
            }
        }
        self.activeCountryCodes = countryCodes
    }
    
    ///set the selectedCode to the user selected code
    func selectCountry(_ country: CountryCode) {
        selectedCode = country.dial_code
    }
    
    func deselectCountry() {
        selectedCode = nil
    }
    
    
    /// concatenate the chosen country code with the user entered phone number and send it to firebase. Firebase will then send a six digit text code to the entered phone number
    func sendTextCode() {
        guard let code = selectedCode else {
            visibleError = OnboardingError.noCountryCodeChosen
            return
        }
        let phoneNumStr = code + phoneNum
        let networking = FirebaseNetworking()
        
        networking.sendCodeTextTo(phoneNumStr, errorCompletion: errorCompletion(_:), successCompletion: successCompletion(_:))
    }
    
    
    /// concatenate the chosen country code with the user entered phone number and send it to firebase. Firebase will then send a six digit text code to the entered phone number
    func resendCode() {
        guard let code = selectedCode else {
            visibleError = OnboardingError.noCountryCodeChosen
            return
        }
        let phoneNumStr = code + phoneNum
        let networking = FirebaseNetworking()
        
        networking.sendCodeTextTo(phoneNumStr, errorCompletion: errorCompletion(_:)) { (success) in }
    }
    
    
    /// send the six digit code to firebase to login the user and return the uid
    func verifyCode() {
        let networking = FirebaseNetworking()
        networking.verifyCode(code, errorCompletion: errorCompletion(_:)) { (success) in
            print("SuccessCompletion returned from FirebaseNetworking")
            if success { print("FirebaseNetworking.verifyCode reported true through successCompletion") }
            else { print("FirebaseNetworking.verifyCode reported false through successCompletion")}
        }
    }
   
    
    /// If an error is returned it is set in visible error where it will be shown onscreen
    /// - Parameter error: the returned error
    func errorCompletion(_ error: Error?) {
        visibleError = error
        print(error?.localizedDescription ?? "Whoops. We run into an error")
    }
    
    
    /// completion block function to signal the six digit code was successfully sent
    /// - Parameter success: bool for if the code was successfully sent
    func successCompletion(_ success: Bool) -> Void {
        visibleError = nil
        nextPage = true
    }

}

class CountryCode: Hashable, Codable {
    var id: String {
        return code
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
    
    static func == (lhs: CountryCode, rhs: CountryCode) -> Bool {
        if lhs.code == rhs.code { return true}
        return false
    }
    
    var name: String
    var dial_code: String
    var code: String
    
    init(name: String, dial_code: String, code: String) {
        self.name = name
        self.dial_code = dial_code
        self.code = code
    }
    
    func flag() -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in self.code.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    var jsonData: String {
        let jsonData = try! JSONEncoder().encode(self)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        print(jsonString)
        return jsonString
    }
    
    
}
