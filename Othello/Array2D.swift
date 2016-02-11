//
//  Array2D.swift
//  Othello
//
//  Created by anthony1618 on 2016/02/11.
//  Copyright © 2016年 kujiranoki. All rights reserved.
//

import Foundation

struct Array2D<T> {
    let rows: Int
    let columns: Int
    
    private var array: [T?]
    
    init(rows: Int, columns: Int, repeatedValue: T? = nil) {
        self.rows = rows
        self.columns = columns
        self.array = Array<T?>(count: rows * columns, repeatedValue: repeatedValue)
    }
    
    subscript(row: Int, column: Int) -> T? {
        get {
            if row < 0 || self.rows <= row || column < 0 || self.columns <= column {
                return nil
            }
            let idx = row * self.columns + column
            
            return array[idx]
        }
        set {
            self.array[row * self.columns + column] = newValue
        }
    }
}
