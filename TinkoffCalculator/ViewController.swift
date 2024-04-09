//
//  ViewController.swift
//  Calculator
//
//  Created by Alexander Bokhulenkov on 10.03.2024.
//

import UIKit

class ViewController: UIViewController {
    
    //    MARK: - Properties
    
    @IBOutlet weak var label: UILabel!
    
    enum CalculatorError: Error {
        case dividedByZero
    }
    
    enum Operation: String {
        case add = "+"
        case substract = "-"
        case multiplay = "x"
        case divide = "/"
        
        func calculate(_ number1: Double, _ number2: Double) throws -> Double {
            switch self {
            case .add:
                return number1 + number2
            case .substract:
                return number1 - number2
            case .multiplay:
                return number1 * number2
            case .divide:
                if number2 == 0 {
                    throw CalculatorError.dividedByZero
                }
                return number1 / number2
            }
        }
    }
    
//    хранение данных
    enum CalculatorHistoryItem {
        case number(Double)
        case operation(Operation)
    }
    
//    преобразование числа из строки и обратно
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_Ru")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    var calculatorHistoryItem: [CalculatorHistoryItem] = []
    
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetLabelText()
    }
    
    //    MARK: - Selectors
    
    
    //    MARK: - Helpers
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        
        if buttonText == "," && label.text?.contains(",") == true {
            return
        }
        
//        проверяем text label на равенство 0 и убираем 0 перед числами
        if label.text == "0" {
            label.text = buttonText
        } else {
            label.text?.append(contentsOf: buttonText)
        }
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let operation = Operation(rawValue: buttonText)
        else { return }
        
//        проверяем на наличие text label и конвертируем его в число
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        calculatorHistoryItem.append(.number(labelNumber))
        calculatorHistoryItem.append(.operation(operation))

        label.text = ""
    }
    
    @IBAction func clearButton() {
        calculatorHistoryItem.removeAll()
        resetLabelText()
    }
    
    @IBAction func calculateButton() {
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        calculatorHistoryItem.append(.number(labelNumber))
        
        do {
            let result = try calculate()
            
            //        отображаем отформатированное число
            label.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            label.text = "Warning!!!"
        }
            
            calculatorHistoryItem.removeAll()
    }
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculatorHistoryItem[0] else { return 0 }
        var currentResult = firstNumber
        
//        проходим по массиву и получаем пару  operation number
        for index in stride(from: 1, to: calculatorHistoryItem.count, by: 2) {
            guard
                case .operation(let operation) = calculatorHistoryItem[index],
                case .number(let number) = calculatorHistoryItem[index + 1]
            else { break }
            
            try currentResult = operation.calculate(currentResult, number)
        }
        return currentResult
    }
    
//    @IBAction func showCalculationList(_ sender: Any) {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let calculationListVC = sb.instantiateViewController(withIdentifier: "CalculationListViewContoller")
        
//        передаем значение в label
//        if let vc = calculationListVC as? CalculationListViewContoller {
//            vc.result = label.text
//        }
//        
//        show(calculationListVC, sender: self)
//        
//    }
    
    func resetLabelText() {
        label.text = "0"
    }
    

}

