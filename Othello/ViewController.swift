//
//  ViewController.swift
//  Othello
//
//  Created by anthony1618 on 2016/02/07.
//  Copyright © 2016年 kujiranoki. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    private var scene: GameScene!
    var computer: ComputerPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Viewの設定
        let skView = self.view as! SKView
        skView.multipleTouchEnabled = false
        
        self.scene = GameScene()
        
        self.scene.size = CGSize(width: 375, height: 667)
        self.scene.scaleMode = .AspectFit
        
        skView.presentScene(self.scene)
        let evaluate = countColor
        let maxDepth = 2
        let search = MiniMaxMethod(evaluate: evaluate, maxDepth: maxDepth)
        self.computer = ComputerPlayer(color: .White, search: search)
        
        self.scene.switchTurnHandler = self.switchTurn
        self.scene.initBoard()
    }
    
    func switchTurn() {
        if self.scene.nextColor == self.computer.color {
            self.scene.userInteractionEnabled = false
            NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: "makeMoveByComputer", userInfo: nil, repeats: false)
        }
    }
    
    func makeMoveByComputer() {
        let nextMove = self.computer.selectMove(self.scene.board!)
        self.scene.makeMove(nextMove)
        
        if self.scene.board.hasGameFinished() == false && self.scene.board.existsValidMove(self.computer.color.opponent) == false {
            self.makeMoveByComputer()
        }
        self.scene.userInteractionEnabled = true
    }

    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

