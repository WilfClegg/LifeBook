//
//  NumbersOnlyAlgorithm.swift
//  MyPeeps
//
//  Created by Wilfred Lalonde on 2023-03-10.
//

import Foundation
import Combine

class NumbersOnlyAlgorithm: ObservableObject {
    
    @Published var filteredPhone: String = "" {
        didSet {
            let filtered = filteredPhone.filter { $0.isNumber }
            
            if filteredPhone != filtered {
                filteredPhone = filtered
            }
        }
    }
}

