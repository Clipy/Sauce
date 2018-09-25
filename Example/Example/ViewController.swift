//
//  ViewController.swift
//
//  Sauce
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Created by Econa77 on 2018/07/30.
//
//  Copyright © 2018 Clipy Project.
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

