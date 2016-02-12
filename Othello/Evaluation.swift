//
//  Evaluation.swift
//  Othello
//
//  Created by anthony1618 on 2016/02/12.
//  Copyright © 2016年 kujiranoki. All rights reserved.
//

import Foundation

typealias EvaluationFunction = (board: Board, color: CellState) -> Int

func countColor(board: Board, color: CellState) -> Int {
    return board.countCells(color)
}