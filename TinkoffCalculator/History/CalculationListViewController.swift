//
//  CalculationListViewController.swift
//  TinkoffCalculator
//
//  Created by Alexander Bokhulenkov on 05.04.2024.
//

import UIKit

class CalculationListViewContoller: UIViewController {
    
    var calculations: [(expression: [CalculationHistoryItem], result: Double)] = []
    
    @IBOutlet weak var calculationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        регистрируем ячейку таблицы
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryTableViewCell")
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

extension CalculationListViewContoller: UITableViewDelegate {
    
}

extension CalculationListViewContoller: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
        
    }
    
    
}
