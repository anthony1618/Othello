//
//  GameScene.swift
//  Othello
//
//  Created by anthony1618 on 2016/02/09.
//  Copyright © 2016年 kujiranoki. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    let gameLayer = SKNode()
    
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
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            var sprite: SKSpriteNode!
            if nextColor == .Black {
                sprite = SKSpriteNode(imageNamed:"disc_black_basic")
            } else {
                sprite = SKSpriteNode(imageNamed:"disk_white_basic")
                
            }
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            self.addChild(sprite)
            self.nextColor = self.nextColor.opponent
        }
    }
    
    func initBoard() {
        self.nextColor = .Black
    }
}
