//
//  CalculationListViewController.swift
//  TinkoffCalculator
//
//  Created by Alexander Bokhulenkov on 05.04.2024.
//

import UIKit

class CalculationListViewContoller: UIViewController {
    
    //    MARK: - Properties
    
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
        
        tableView.backgroundColor = UIColor.systemGray5
        let tableHeaderView = UIView()
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30)
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
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
    
//    принимаем выражение и отображаем строку
    private func expressionsToString(_ expressions: [CalculationHistoryItem]) -> String {
        var result = ""
        
        for operand in expressions {
            switch operand {
            case let .number(value):
                result += String(value) + " "
            case let .operation(value):
                result += value.rawValue + " "
                
            }
        }
        return result
    }
    
}

// MARK: - Extension


extension CalculationListViewContoller: UITableViewDelegate {
//    высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
}

extension CalculationListViewContoller: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        получаем ячейку
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
//        номер строки ячейки
        let historyItem = calculations[indexPath.row]
        cell.configure(with: expressionsToString(historyItem.expression), result: String(historyItem.result))
        return cell
        
    }
    
    
}
