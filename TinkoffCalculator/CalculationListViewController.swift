//
//  CalculationListViewController.swift
//  TinkoffCalculator
//
//  Created by Alexander Bokhulenkov on 05.04.2024.
//

import UIKit

class CalculationListViewContoller: UIViewController {
    
    var result: String?
    
    @IBOutlet weak var calculationLabel: UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super .init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        initialize()
    }
    
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        calculationLabel.text = result
    }
    
    //    MARK: - Helpers
    
    private func initialize() {
        modalPresentationStyle = .fullScreen
        modalPresentationStyle = .overCurrentContext
    }
}