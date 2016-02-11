//
//  GameScene.swift
//  Othello
//
//  Created by anthony1618 on 2016/02/09.
//  Copyright © 2016年 kujiranoki. All rights reserved.
//

import Foundation
import SpriteKit

//ディスクを置くマスのサイズ
let SquareHeight: CGFloat = 47.0
let SquareWidth: CGFloat = 47.0

let DiskImageNames = [
    CellState.Black : "disc_black_basic",
    CellState.White : "disc_white_basic",
]

class GameScene: SKScene {
    
    let gameLayer = SKNode()
    let disksLayer = SKNode()

    var diskNodes = Array2D<SKSpriteNode>(rows: BoardSize, columns: BoardSize)
    var board: Board!
    var nextColor: CellState!
    
    override func didMoveToView(view: SKView) {
        //基準点を中心に設定
        super.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //背景の設定
        let background = SKSpriteNode(imageNamed: "board")
        background.size = CGSize(width: self.size.width, height: self.size.width)
        self.addChild(background)
        self.addChild(self.gameLayer)
        self.initBoard()
        
        //anchorPountからの相対位置
        let layerPosition = CGPoint(
            x: -SquareWidth * CGFloat(BoardSize) / 2,
            y: -SquareHeight * CGFloat(BoardSize) / 2
        )
        
        self.disksLayer.position = layerPosition
        self.gameLayer.addChild(self.disksLayer)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(self.disksLayer)
        
        if let (row, column) = self.convertPointOnBoard(location) {
            
            let move = Move(color: self.nextColor, row: row, column: column)
            
            if move.canPlace(self.board.cells) {
                self.board.makeMove(move)
                self.updateDiskNodes()
                self.nextColor = self.nextColor.opponent
            }
        }
    }
    
    func initBoard() {
        self.board = Board()
        self.updateDiskNodes()
        self.nextColor = .Black
    }
    
    //現在の状態で、石の表示を更新する
    func updateDiskNodes() {
        for row in 0..<BoardSize {
            for column in 0..<BoardSize {
                if let state = self.board.cells[row, column] {
                    if let imageName = DiskImageNames[state] {
                        if let prevNode = self.diskNodes[row, column] {
                            if prevNode.userData?["state"] as! Int == state.rawValue {
                                //変化が無いセルはスキップする
                                continue
                            }
                            //古いノードを消去
                            prevNode.removeFromParent()
                        }
                        // 新しいノードをレイヤーに追加
                        let newNode = SKSpriteNode(imageNamed: imageName)
                        newNode.userData = ["state" : state.rawValue] as NSMutableDictionary
                        newNode.size = CGSize(width: SquareWidth, height: SquareHeight)
                        newNode.position = self.convertPointOnLayer(row, column: column)
                        self.disksLayer.addChild(newNode)
                        
                        self.diskNodes[row, column] = newNode
                    }
                }
            }
        }
    }
    
    //盤上での座標をレイヤー上での座標に変換する
    func convertPointOnLayer(row: Int, column: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * SquareWidth + SquareWidth / 2,
            y: CGFloat(row) * SquareHeight + SquareHeight / 2
        )
    }
    
    //レイヤー上での座標を盤上での座標に変換する
    func convertPointOnBoard(point: CGPoint) -> (row: Int, column: Int)? {
        if 0 <= point.x && point.x < SquareWidth * CGFloat(BoardSize) && 0 <= point.y && point.y < SquareHeight * CGFloat(BoardSize) {
            return (Int(point.y / SquareHeight), Int(point.x / SquareWidth))
        } else {
            return nil
        }
    }
}
