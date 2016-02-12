//
//  Board.swift
//  Othello
//
//  Created by anthony1618 on 2016/02/11.
//  Copyright © 2016年 kujiranoki. All rights reserved.
//

import Foundation

//
//  Board.swift
//  AppleReversi
//
//  Created by anthony1618 on 2016/02/09.
//  Copyright © 2016年 kujiranoki. All rights reserved.
//

import Foundation

//板の一辺のセルの数
let BoardSize = 8

// 8 * 8 の板
class Board: CustomStringConvertible {
    //盤上のすべてのセルの状態を保持する二次元配列
    var cells: Array2D<CellState>
    
    init() {
        self.cells = Array2D<CellState>(rows: BoardSize, columns: BoardSize, repeatedValue: .Empty)
        
        self.cells[3, 4] = .Black
        self.cells[4, 3] = .Black
        self.cells[3, 3] = .White
        self.cells[4, 4] = .White
    }
    
    var description: String {
        var rows = Array<String>()
        for row in 0..<BoardSize {
            var cells = Array<String>()
            for column in 0..<BoardSize {
                if let state = self.cells[row, column] {
                    cells.append(String(state.rawValue))
                }
            }
            let line = cells.joinWithSeparator(" ")
            rows.append(line)
        }
        return Array(rows.reverse()).joinWithSeparator("\n")
    }
    
    //オセロを打つ
    func makeMove(move: Move) {
        for vertical in Line.allValues {
            for horizontal in Line.allValues {
                if vertical == .Hold && horizontal == .Hold {
                    continue
                }
                let direction = (vertical, horizontal)
                let count = move.countFlippableDisks(direction, cells: self.cells)
                
                if 0 < count {
                    let y = vertical.rawValue
                    let x = horizontal.rawValue
                    for i in 1...count {
                        self.cells[move.row + i * y, move.column + i * x] = move.color
                    }
                }
            }
        }
        
        self.cells[move.row, move.column] = move.color
    }
    
    //指定された状態のセル数を返す
    func countCells(state: CellState) -> Int {
        var count = 0
        for row in 0..<self.cells.rows {
            for column in 0..<self.cells.columns {
                if self.cells[row, column] == state {
                    count++
                }
            }
        }
        return count
    }
    
    // 打つ手がない場合、trueを返す
    func hasTurnPassed(state: CellState) -> Bool {
        return self.existsValidMove(state) == false
    }
    
    //ゲームが終了した場合、trueを返す
    func hasGameFinished() -> Bool {
        return self.existsValidMove(.Black) == false && self.existsValidMove(.White) == false
    }
    
    //合法な手が存在する場合、trueを返す
    func existsValidMove(color: CellState) -> Bool {
        for row in 0..<BoardSize {
            for column in 0..<BoardSize {
                let move = Move(color: color, row: row, column: column)
                if move.canPlace(self.cells) {
                    return true
                }
            }
        }
        return false
    }
    
    func getValidMoves(color: CellState) -> [Move] {
        var moves = Array<Move>()
        for row in 0..<BoardSize {
            for column in 0..<BoardSize {
                let move = Move(color: color, row: row, column: column)
                if move.canPlace(self.cells) {
                    moves.append(move)
                }
            }
        }
        
        return moves
    }
    
    init(cells: Array2D<CellState>) {
        self.cells = cells
    }
    
    func clone() -> Board {
        return Board(cells: self.cells)
    }
}