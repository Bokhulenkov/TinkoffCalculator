//
//  CalculationListViewController.swift
//  TinkoffCalculator
//
//  Created by Alexander Bokhulenkov on 05.04.2024.
//

import UIKit

class CalculationListViewContoller: UIViewController {
    
    //    MARK: - Properties
    
    var calculations: [Calculation] = []
    
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
        title = "История вычислений"
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
    
//    add header to history
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .lightGray
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let todayDate = formatter.string(from: date)
        
        let label = UILabel()
        label.frame = CGRect(x: 5, y: 5, width: tableView.frame.width, height: 50)
        label.text = todayDate
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        headerView.addSubview(label)
        
        return headerView
        
    }
//    height header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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
        cell.configure(with: expressionsToString(historyItem.expressions), result: String(historyItem.result))
        return cell
        
    }
}
