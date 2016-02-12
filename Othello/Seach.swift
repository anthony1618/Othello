//
//  Seach.swift
//  Othello
//
//  Created by anthony1618 on 2016/02/12.
//  Copyright © 2016年 kujiranoki. All rights reserved.
//

import Foundation

let MinScore = Int(UInt8.min)
let MaxScore = Int(UInt8.max)

protocol Search {
    func getBestScore(board: Board, color: CellState) -> Int
}

class SearchAlgorithmBase {
    let evaluate: EvaluationFunction
    
    let maxDepth: Int
    
    init(evaluate:EvaluationFunction, maxDepth: Int) {
        self.evaluate = evaluate
        self.maxDepth = maxDepth
    }
}

class MiniMaxMethod : SearchAlgorithmBase, Search {
    func getBestScore(board: Board, color: CellState) -> Int {
        return self.miniMax(board, color: color, depth: 1)
    }
    
    func miniMax(node: Board, color: CellState, depth: Int) -> Int {
        if self.maxDepth <= depth {
            return self.evaluate(board: node, color: color)
        }
        
        let moves = node.getValidMoves(color)
        
        if depth % 2 == 0 {
            var worstScore = MaxScore
            
            for move in moves {
                let testNode = node.clone()
                testNode.makeMove(move)
                let score = self.miniMax(testNode, color: color.opponent, depth: depth + 1)
                worstScore = min(worstScore, score)
            }
            return worstScore
        } else {
            var bestScore = MinScore
            
            for move in moves {
                let testNode = node.clone()
                testNode.makeMove(move)
                let score = self.miniMax(testNode, color: color.opponent, depth: depth + 1)
                bestScore = max(bestScore, score)
            }
            return bestScore
        }
    }
}

