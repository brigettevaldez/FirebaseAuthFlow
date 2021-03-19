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
    
    func selectCountry(_ country: CountryCode) {
        selectedCode = country.dial_code
    }
    
    func deselectCountry() {
        selectedCode = nil
    }
    
    func sendTextCode() {
        guard let code = selectedCode else {
            visibleError = OnboardingError.noCountryCodeChosen
            return
        }
        let phoneNumStr = code + phoneNum
        let networking = FirebaseNetworking()
        
        networking.sendCodeTextTo(phoneNumStr, errorCompletion: errorCompletion(_:), successCompletion: successCompletion(_:))
    }
    
    func resendCode() {
        guard let code = selectedCode else {
            visibleError = OnboardingError.noCountryCodeChosen
            return
        }
        let phoneNumStr = code + phoneNum
        let networking = FirebaseNetworking()
        
        networking.sendCodeTextTo(phoneNumStr, errorCompletion: errorCompletion(_:)) { (success) in }
    }
    
    func verifyCode() {
        let networking = FirebaseNetworking()
        networking.verifyCode(code, errorCompletion: errorCompletion(_:)) { (success) in
            print("Successfully verified and signed in user")
        }
    }
   
    func errorCompletion(_ error: Error?) {
        visibleError = error
        print(error?.localizedDescription ?? "Whoops. We run into an error")
    }
    
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
