//
//  HistoryTableViewCell.swift
//  TinkoffCalculator
//
//  Created by Alexander Bokhulenkov on 12.04.2024.
//

import Foundation
import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var expressionLabel: UILabel!
    
    @IBOutlet private weak var resultLabel: UILabel!
    
    func configure(with expressions: String, result: String) {
        expressionLabel.text = expressions
        resultLabel.text = result
    }
    
}
