//
//  ComputerPlayer.swift
//  Othello
//
//  Created by anthony1618 on 2016/02/12.
//  Copyright © 2016年 kujiranoki. All rights reserved.
//

import Foundation

class ComputerPlayer {
    let color: CellState
    let search: Search
    
    init(color: CellState, search: Search) {
        self.color = color
        self.search = search
    }
    
    func selectMove(board: Board) -> Move? {
        var bestMove: Move?
        var bestScore = MinScore
        
        let moves = board.getValidMoves(self.color)
        for nextMove in moves {
            let test = board.clone()
            test.makeMove(nextMove)
            
            let score = self.search.getBestScore(test, color: self.color)
            
            if bestScore <= score {
                bestScore = score
                bestMove = nextMove
            }
        }
        return bestMove
    }
}