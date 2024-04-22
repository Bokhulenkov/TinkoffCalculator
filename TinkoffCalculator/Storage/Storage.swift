//
//  Storage.swift
//  TinkoffCalculator
//
//  Created by Alexander Bokhulenkov on 22.04.2024.
//

import Foundation

struct Calculations {
    
//    MARK: - Properties
    
    let exprassions: [CalculationHistoryItem]
    let result: Double
}

// MARK: - Extension

extension Calculations: Codable {
    
}

// чтобы Calculations комформил протаколу Codable, надо и чтобы CalculationHistoryItem ему конформил
extension CalculationHistoryItem: Codable {
    enum CondingKeys: String, CodingKey {
        case number
        case operation
    }
    
    enum CalculationHistoryItemError: Error {
        case itemNotFound
    }
    
    func encode(to encoder: Encoder) throws {
//        контейнер для ключей
        var container = encoder.container(keyedBy: CondingKeys.self)
        
        switch self {
        case .number(let value):
            try container.encode(value, forKey: CondingKeys.number)
        case .operation(let value):
            try container.encode(value.rawValue, forKey: CondingKeys.operation)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CondingKeys.self)
        
        if let Number = try container.decodeIfPresent(Double.self, forKey: .number) {
            self = .number(Number)
            return
        }
        
        if let rawOperation = try container.decodeIfPresent(String.self, forKey: .operation), let operation = Operation(rawValue: rawOperation) {
            self = .operation(operation)
            return
        }
//        если нет ни одного ключа, то ошибка
        throw CalculationHistoryItemError.itemNotFound
    }
}
