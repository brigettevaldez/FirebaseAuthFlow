//
//  Errors.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import Foundation

enum OnboardingError: Error {
    case noCountryCodeChosen
    case noPhoneNumberEntered
    case noVerificationIDStored
}

extension OnboardingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noCountryCodeChosen:
            return "Please select a country code"
        case .noPhoneNumberEntered:
            return "Please enter a phone number"
        case .noVerificationIDStored:
            return "Error fetching verification id"
        }
    }
}

