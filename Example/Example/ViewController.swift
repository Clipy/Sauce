//
//  ViewController.swift
//
//  Example
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2020 Clipy Project.
//

import Cocoa
import Sauce

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Sauce.shared
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let keyCode = Sauce.shared.currentKeyCode(for: .v) else { return }
        print(keyCode)
        print(Sauce.shared.character(for: Int(keyCode), cocoaModifiers: []) as Any)
        print(Sauce.shared.character(for: Int(keyCode), cocoaModifiers: .shift) as Any)
        print(Sauce.shared.key(for: Int(keyCode)) as Any)
    }

}

