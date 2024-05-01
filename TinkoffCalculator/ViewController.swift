//
//  ViewController.swift
//  Calculator
//
//  Created by Alexander Bokhulenkov on 10.03.2024.
//

import UIKit

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
enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}

protocol LongPressViewProtocol {
    var shared: UIView { get }
    
    func startAnimation()
    func stopAnimation()
}

class ViewController: UIViewController {
    
    //    MARK: - Properties
    
    @IBOutlet var hidenActionView: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var historyButton: UIButton!
    
    private let alertVeiw: AlertView = {
        let screenBounds = UIScreen.main.bounds
        let alertHeight: CGFloat = 100
        let alertWidth: CGFloat = screenBounds.width - 40
//        координаты левого верхнего угла
        let x: CGFloat = screenBounds.width / 2 - alertWidth / 2
        let y: CGFloat = screenBounds.height / 2 - alertHeight / 2
        let alertFrame = CGRect(x: x, y: y, width: alertWidth, height: alertHeight)
        let alertView = AlertView(frame: alertFrame)
        return alertView
    }()
    
    var calculationHistory: [CalculationHistoryItem] = []
//    собираем вычисления
    var calculations: [Calculation] = []

     let calculationHistoryStorage = CalculationHistoryStorage()
    
//    преобразование числа из строки и обратно
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_Ru")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    //    MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(shared)
        
        view.subviews.forEach {
            if type(of: $0) == UIButton.self {
                $0.layer.cornerRadius = 45
            }
        }
        
        
        resetLabelText()
//        инициализируем загрузку из памяти истории вычислений
        calculations = calculationHistoryStorage.loadHistory()
        
        historyButton.accessibilityIdentifier = "historyButton"
        
        view.addSubview(alertVeiw)
        alertVeiw.alpha = 0
        alertVeiw.alertText = "Вы нашли пасхалку"
    }
    
    //    MARK: - Selectors
    
//    long tap animation
    @objc func tapLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            startAnimation()
        } else if gesture.state == .ended {
            stopAnimation()
        }
    }
    
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
        
        if label.text == "3,14" {
            animateAlert()
        }
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        
//        проверяем на наличие text label и конвертируем его в число
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        calculationHistory.append(.number(labelNumber))
        calculationHistory.append(.operation(buttonOperation))

        label.text = "" // resetLabelText()
    }
    
    @IBAction func clearButton() {
        calculationHistory.removeAll()
        resetLabelText()
    }
    
    @IBAction func calculateButton() {
        
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        calculationHistory.append(.number(labelNumber))
        
        do {
            let result = try calculate()
            
            //        отображаем отформатированное число
            label.text = numberFormatter.string(from: NSNumber(value: result))
            let newCalculation = Calculation(expressions: calculationHistory, result: result)
            calculations.append(newCalculation)
            //            сохранение в файловую систему
            calculationHistoryStorage.setHistory(calculation: calculations)
        } catch {
            label.text = "Warning!!!"
        }
        
        calculationHistory.removeAll()
    }
    
    @IBAction func shawCalculationsList(_ sender: UIButton) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let calculationsListVC = sb.instantiateViewController(withIdentifier: "CalculationListViewContoller")
        if let vc = calculationsListVC as? CalculationListViewContoller {
            vc.calculations = calculations
        }
        
        navigationController?.pushViewController(calculationsListVC, animated: true)
    }
    
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculationHistory[0] else { return 0 }
        var currentResult = firstNumber
        
        //        проходим по массиву и получаем пару  operation number
        for index in stride(from: 1, to: calculationHistory.count, by: 2) {
            guard
                case .operation(let operation) = calculationHistory[index],
                case .number(let number) = calculationHistory[index + 1]
            else { break }
            
            try currentResult = operation.calculate(currentResult, number)
        }
        return currentResult
    }
    
    func animateAlert() {
        
        if !view.contains(alertVeiw) {
            alertVeiw.alpha = 0
            alertVeiw.center = view.center
            view.addSubview(alertVeiw)
        }
        
        UIView.animateKeyframes(withDuration: 2, delay: 0.5) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.alertVeiw.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                var newCenter = self.label.center
                newCenter.y -= self.alertVeiw.bounds.height
                self.alertVeiw.center = newCenter
            }
        }
    }
    
    func resetLabelText() {
        label.text = "0"
    }
    
//    long tap animation
    @IBAction func myActionMethod(_ sender: Any) {
        let longTapRecognize = UILongPressGestureRecognizer(target: self, action: #selector(tapLongPress))
        longTapRecognize.allowableMovement = 10
        view.addGestureRecognizer(longTapRecognize)
    }
    
}
    // MARK: - Extensions

extension ViewController: LongPressViewProtocol {
    
    var shared: UIView {
        hidenActionView.isHidden = true
        hidenActionView.backgroundColor = .red
        hidenActionView.sizeToFit()
        hidenActionView.shake()
        return hidenActionView
    }
    
    func startAnimation() {
        shared.isHidden = false
    }
    
    func stopAnimation() {
        shared.isHidden = true
    }
}

extension UIView {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration  = 0.5
        animation.repeatCount = 10
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x, y: center.y - 100))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x, y: center.y + 100))
        layer.add(animation, forKey: "position")
    }
}
