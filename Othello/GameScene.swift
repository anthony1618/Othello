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

    override func didMoveToView(view: SKView) {
        //基準点を中心に設定
        super.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //背景の設定
        let background = SKSpriteNode(imageNamed: "board")
        background.size = CGSize(width: self.size.width, height: self.size.width)
        self.addChild(background)
        self.addChild(self.gameLayer)
        
        let sprite = SKSpriteNode(imageNamed:"disc_black_basic")
        
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(sprite)
    }
    
}
