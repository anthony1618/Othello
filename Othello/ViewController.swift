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

    override func viewDidLoad() {
        super.viewDidLoad()

        //Viewの設定
        let skView = self.view as! SKView
        skView.multipleTouchEnabled = false
        
        self.scene = GameScene()
        self.scene.size = CGSize(width: 375, height: 667)
        self.scene.scaleMode = .AspectFit
        
        skView.presentScene(self.scene)
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

