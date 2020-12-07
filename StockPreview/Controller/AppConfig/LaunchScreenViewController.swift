//
//  LaunchScreenViewController.swift
//  StockPreview
//
//  Created by Fereizqo Sulaiman on 07/12/20.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let alreadyLogin = UserDefaults.standard.bool(forKey: "User_AlreadyLogin")
        print(alreadyLogin)
        if alreadyLogin {
            // Go to Next VC
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                 self.performSegue(withIdentifier: "goToHome", sender: self)
            })
        } else {
            // State already login
            UserDefaults.standard.set(true, forKey: "User_AlreadyLogin")
            // Default Param for API Call
            UserDefaults.standard.set("Compact", forKey: "User_OutputSize")
            UserDefaults.standard.set("15", forKey: "User_Interval")
            Keychain.shared["User_APIKey"] = "HBST5HOLYWMZL9FD"
            
            // Go to Next VC
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                 self.performSegue(withIdentifier: "goToHome", sender: self)
            })
        }
    }

}
