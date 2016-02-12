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

extension SKLabelNode {
    //スコア表示用のSKLabelNodeを生成する
    class func createScoreLabel(x x: Int, y: Int) -> SKLabelNode {
        let node = SKLabelNode(fontNamed: "Helvetica")
        node.position = CGPoint(x: x, y: y)
        node.fontSize = 25
        node.horizontalAlignmentMode = .Right
        node.fontColor = UIColor.whiteColor()
        return node
    }
    
    class func createMessageLabel(x x: Int, y: Int) -> SKLabelNode {
        let node = SKLabelNode(fontNamed: "Helvetica")
        node.position = CGPoint(x: x, y: y)
        node.fontSize = 25
        node.horizontalAlignmentMode = .Center
        node.fontColor = UIColor.whiteColor()
        return node
    }
    class func createResultLabel(x x: Int, y: Int) -> SKLabelNode {
        let node = SKLabelNode(fontNamed: "Helvetica")
        node.position = CGPoint(x: x, y: y)
        node.fontSize = 25
        node.horizontalAlignmentMode = .Center
        node.fontColor = UIColor.redColor()
        return node
    }
}



class GameScene: SKScene {
    
    let gameLayer = SKNode()
    let disksLayer = SKNode()
    
    var diskNodes = Array2D<SKSpriteNode>(rows: BoardSize, columns: BoardSize)
    var board: Board!
    var nextColor: CellState!
    
    let blackScoreLabel = SKLabelNode.createScoreLabel(x: 10, y: -260)
    let whiteScoreLabel = SKLabelNode.createScoreLabel(x: 10, y: -310)
    let messageLabel = SKLabelNode.createMessageLabel(x: 70, y: 250)
    var resultLabel = SKLabelNode.createResultLabel(x: 50, y: 0)
    
    var switchTurnHandler: (() -> ())?
    var gameResultLayer: SKNode?
    var gameEndFlag = false
    var resetBtn = UIButton()
    
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
        
        self.gameLayer.addChild(self.blackScoreLabel)
        self.gameLayer.addChild(self.whiteScoreLabel)
        self.gameLayer.addChild(self.messageLabel)
        
        self.disksLayer.position = layerPosition
        self.gameLayer.addChild(self.disksLayer)
        
        resetBtn.frame = CGRectMake(10,55,120,40)
        resetBtn.backgroundColor = UIColor.grayColor()
        resetBtn.layer.cornerRadius = 20.0
        resetBtn.setTitle("リスタート", forState: UIControlState.Normal)
        resetBtn.addTarget(self, action: "onClickResetBtn:", forControlEvents: .TouchUpInside)
        self.view!.addSubview(resetBtn);
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.locationInNode(self.disksLayer)
        
        //ゲームをリセットする
        if gameEndFlag == true {
            gameEndFlag = false
            hideGameResult()
            self.messageLabel.text = "黒のターンです"
        } else {
            
            if let (row, column) = self.convertPointOnBoard(location) {
                
                let move = Move(color: self.nextColor, row: row, column: column)
                
                if move.canPlace(self.board.cells) {
                    self.board.makeMove(move)
                    self.updateDiskNodes()
                    
                    //ゲームの終了を判定
                    if self.board.hasGameFinished() == true {
                        print("ゲーム終了")
                        self.showGameResult()
                        gameEndFlag = true
                    }
                    
                    self.nextColor = self.nextColor.opponent
                    
                    //おけない場合はパスする
                    if let state = self.nextColor {
                        if self.board.hasTurnPassed(state) {
                            self.nextColor = self.nextColor.opponent
                            
                            if state == .Black {
                                self.messageLabel.text = "白のターンです"
                            } else {
                                self.messageLabel.text = "黒のターンです"
                            }
                        }
                    }
                } else {
                    self.messageLabel.text = "そこには置けません！ "
                }
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
        
        //スコアの表示
        self.updateScores()
        //メッセージの表示
        self.updateMessage()
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
    
    //スコアを更新する
    func updateScores() {
        self.blackScoreLabel.text = "黒の枚数 : " + String(self.board.countCells(.Black))
        self.whiteScoreLabel.text = "白の枚数 : " + String(self.board.countCells(.White))
    }
    
    func updateMessage() {
        if let color = self.nextColor {
            if color == .Black {
                self.messageLabel.text = "白のターンです"
            } else {
                self.messageLabel.text = "黒のターンです"
            }
        }
    }
    
    //リザルト画面を表示する
    func showGameResult() {
        let black = self.board.countCells(.Black)
        let white = self.board.countCells(.White)
        
        if white < black {
            resultLabel.text = "黒の勝ち！"
        } else if (black < white) {
            resultLabel.text = "白の勝ち！"
        } else {
            resultLabel.text = "引き分け！"
        }
        
        resultLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        
        let gameResultLayer = GameResultLayer()
        gameResultLayer.userInteractionEnabled = true
        gameResultLayer.touchHandler = self.hideGameResult
        gameResultLayer.addChild(resultLabel)
        
        self.gameResultLayer = gameResultLayer
        self.addChild(self.gameResultLayer!)
    }
    
    //ゲームをリスタートする
    func restartGame() {
        for row in 0..<BoardSize {
            for column in 0..<BoardSize {
                if let diskNode = self.diskNodes[row, column] {
                    diskNode.removeFromParent()
                    self.diskNodes[row, column] = nil
                }
            }
        }
        
        self.initBoard()
    }
    
    //リザルト画面を非表示にする
    func hideGameResult() {
        self.gameResultLayer?.removeFromParent()
        self.gameResultLayer = nil
        
        self.restartGame()
    }
    
    func onClickResetBtn(sender : UIButton) {
        self.restartGame()
    }
}

class GameResultLayer: SKNode {
    var touchHandler: (() -> ())?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchHandler?()
    }
}

