//
//  Storage.swift
//  TinkoffCalculator
//
//  Created by Alexander Bokhulenkov on 22.04.2024.
//

import Foundation

struct Calculation {
    
//    MARK: - Properties
    
    let expressions: [CalculationHistoryItem]
    let result: Double
}

// MARK: - Extension

extension Calculation: Codable {
    
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
        
        if let number = try container.decodeIfPresent(Double.self, forKey: .number) {
            self = .number(number)
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

// class для сохраниния истории вычисления
class CalculationHistoryStorage {
    
    static let calculationHistoryKey = "calculationHistoryKey"
    
    func setHistory(calculation: [Calculation]) {
        if let encoded = try? JSONEncoder().encode(calculation) {
            UserDefaults.standard.set(encoded, forKey: CalculationHistoryStorage.calculationHistoryKey)
        }
    }
    
    func loadHistory() -> [Calculation] {
        if let data = UserDefaults.standard.data(forKey: CalculationHistoryStorage.calculationHistoryKey) {
            return (try? JSONDecoder().decode([Calculation].self, from: data)) ?? []
        }
        return []
    }
}
