//
//  Extension.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 06/12/20.
//

import Foundation
import UIKit

extension UIViewController {
    //Show a basic alert
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Hide keyboard when tap around
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension KeyedDecodingContainer{
    enum ParsingError:Error{
      case noKeyFound
      /*
        Add other errors here for more use cases
      */
    }

    func decode<T>(_ type:T.Type, forKeys keys:[K]) throws -> T where T:Decodable {
       for key in keys{
         if let val = try? self.decode(type, forKey: key){
           return val
         }
       }
     throw ParsingError.noKeyFound
   }
}

extension KeyedDecodingContainer where K == AnyKey {
    func decode<T>(_ type: T.Type, forMappedKey key: String, in keyMap: [String: [String]]) throws -> T where T : Decodable{

        for key in keyMap[key] ?? [] {
            if let value = try? decode(T.self, forKey: AnyKey(stringValue: key)) {
                return value
            }
        }

        return try decode(T.self, forKey: AnyKey(stringValue: key))
    }
}

extension Data {

    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}
