//
//  GameViewController.swift
//  blackjack.io
//
//  Created by Jules on 09/09/2021.
//
//  (la mienne) BOTTOM ADD : ca-app-pub-4889346564502252/7907723689
// ID app : ca-app-pub-4889346564502252~7541718210
//  google if bottom ad : ca-app-pub-3940256099942544/2934735716
import UIKit
import SpriteKit
import GameplayKit
//import GoogleMobileAds
class GameViewController: UIViewController {
    public let defaults = UserDefaults.standard
    
    
//    private let bannertop: GADBannerView = {
//        let banner = GADBannerView()
//        banner.adUnitID = "ca-app-pub-***********************"
//        banner.load(GADRequest())
//        return banner
//
//    }()


    
    override func viewDidLoad() {
      //  bannertop.rootViewController = self
        
        super.viewDidLoad()
   
   
        if let view = self.view as! SKView? {
            
            let menuu = MenuScene(size: view.bounds.size)
            let launch = LaunchScreen(size: view.bounds.size)
                menuu.scaleMode = .aspectFill
                view.presentScene(launch)
                view.ignoresSiblingOrder = true
                //view.addSubview(bannertop)
            
        }

    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    //    bannertop.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35).integral
    }

}
     
