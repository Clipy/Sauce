//
//  ViewController.swift
//
//  Example
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2019 Clipy Project.
//

import Cocoa
import Sauce

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Sauce.shared
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let keyCode = Sauce.shared.currentKeyCode(by: .v) else { return }
        print(keyCode)
    }

}

