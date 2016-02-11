//
//  Move.swift
//  Othello
//
//  Created by anthony1618 on 2016/02/11.
//  Copyright © 2016年 kujiranoki. All rights reserved.
//

import Foundation

enum Line: Int {
    case Backward = -1, Hold, Forward
    static let allValues: [Line] = [.Backward, .Hold, .Forward]
}

typealias Direction = (vertical: Line, horizontal: Line)

class Move {
    let color: CellState
    let row: Int
    let column: Int
    
    init(color: CellState, row: Int, column: Int) {
        self.color = color
        self.row = row
        self.column = column
    }
    
    func countFlippableDisks(direction: Direction, cells: Array2D<CellState>) -> Int {
        let y = direction.vertical.rawValue
        let x = direction.horizontal.rawValue
        
        let opponent = self.color.opponent
        
        var count = 1
        
        while (cells[self.row + count * y, self.column + count * x] == opponent) {
            count++
        }
        
        if cells[self.row + count * y, self.column + count * x] == self.color {
            return count - 1
        } else {
            return 0
        }
    }
    
    func canPlace(cells: Array2D<CellState>) -> Bool {
        if let state = cells[self.row, self.column] {
            if state != .Empty {
                return false
            }
        }
        
        for vertical in Line.allValues {
            for horizontal in Line.allValues {
                if vertical == .Hold && horizontal == .Hold {
                    continue
                }
                if 0 < self.countFlippableDisks((vertical, horizontal), cells: cells) {
                    return true
                }
            }
        }
        
        return false
    }
}