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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Прошлые вычисления"
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        calculationLabel.text = result
    }
    
    //    MARK: - Helpers
    
//     кнопка закрыть
    @IBAction func dismissVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func initialize() {
        modalPresentationStyle = .fullScreen
    }
}
