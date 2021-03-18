//
//  DefaultsObservation.swift
//  FirebaseAuthFlow
//
//  Created by Brigette Valdez on 3/18/21.
//

import Foundation


import Foundation
import Combine

//Tutorial that gave me this idea -> https://github.com/V8tr/UserDefaultsPropertyWrapper
class DefaultsObservation: NSObject {
    let key: Key
    private var onChange: (Any, Any) -> Void

    init(key: Key, onChange: @escaping (Any, Any) -> Void) {
        self.onChange = onChange
        self.key = key
        super.init()
        UserDefaults.standard.addObserver(self, forKeyPath: key.rawValue, options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change, object != nil, keyPath == key.rawValue else { return }
        onChange(change[.oldKey] as Any, change[.newKey] as Any)
    }

    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: key.rawValue, context: nil)
    }
}


struct Key: RawRepresentable {
    let rawValue: String
}

extension Key: ExpressibleByStringLiteral {
    static let UIDKey: Key = "uid"
    
    init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}


@propertyWrapper
struct UserDefault<T: PropertyListValue> {
    let key: Key

    var wrappedValue: T? {
        get { UserDefaults.standard.value(forKey: key.rawValue) as? T }
        set { UserDefaults.standard.set(newValue, forKey: key.rawValue) }
    }
    
    var projectedValue: UserDefault<T> { return self }
    
    func observe(change: @escaping (T?, T?) -> Void) -> NSObject {
        return DefaultsObservation(key: key) { old, new in
            change(old as? T, new as? T)
        }
    }
}

// The marker protocol
protocol PropertyListValue {}

extension Data: PropertyListValue {}
extension String: PropertyListValue {}
extension Date: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}

// Every element must be a property-list type
extension Array: PropertyListValue where Element: PropertyListValue {}
extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}
