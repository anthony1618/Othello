//
//  CellState.swift
//  Othello
//
//  Created by anthony1618 on 2016/02/09.
//  Copyright © 2016年 kujiranoki. All rights reserved.
//

import Foundation

public enum CellState: Int {
    case Empty = 0, Black, White
    
    var opponent: CellState {
        switch self {
        case .Black:
            return .White
        case .White:
            return .Black
        default:
            return self
        }
    }
}