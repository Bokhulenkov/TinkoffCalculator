//
//  AlertView.swift
//  TinkoffCalculator
//
//  Created by Alexander Bokhulenkov on 26.04.2024.
//

import UIKit

class AlertView: UIView {
    
//    MARK: - Properties
    
    var alertText: String? {
        didSet {
            label.text = alertText
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setupUI()
    }
    
    
//    MARK: - Selectors
    
    @objc private func hide() {
        removeFromSuperview()
    }
    
//    MARK: - Helpers
    
//    добавление label на AlertView
    private func setupUI() {
        addSubview(label)
        backgroundColor = .red
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(hide))
        addGestureRecognizer(tap)
    }
    
//    изменение frame при изменение размеров bounds его superView
    override func layoutSubviews() {
        super .layoutSubviews()
        label.frame = bounds
    }
    
}
