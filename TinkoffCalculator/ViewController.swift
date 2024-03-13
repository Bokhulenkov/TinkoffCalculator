//
//  ViewController.swift
//  Calculator
//
//  Created by Alexander Bokhulenkov on 10.03.2024.
//

import UIKit

class ViewController: UIViewController {
    
    //    MARK: - Properties
    
    
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("calc")
    }
    
    //    MARK: - Selectors
    
    
    //    MARK: - Helpers
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let pressedButton = sender.currentTitle else { return }
        print(pressedButton)
    }
    

}

