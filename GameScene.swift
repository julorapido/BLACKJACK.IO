//
//  GameScene.swift
//  blackjack.io
//
//  Created by Jules on 09/09/2021.
//

import SpriteKit
import GameplayKit
import UIKit
//import GoogleMobileAds

class GameScene: SKScene {
    weak var viewController: GameViewController?
    var noas : Bool!
    override func didMove(to view: SKView) {

        defo.set(false, forKey: "LastGameVictory?")
        defo.set(false, forKey: "FirstLaunch")
        let layout = SKAction.run({self.layoutScene()})
        let game = SKAction.run({self.gameSetup();self.displaycards()})
        let wait = SKAction.wait(forDuration: 0.2)
        run(SKAction.sequence([layout,wait,game]))
        AdaptiveNodes()
        
        disableUserInter(time: 2.3)

    }
    func ModifyPlayerData(Exp : Int, CoinsWon : Int ){
        var PreviousCoin = defo.integer(forKey: "UserCoins")
        PreviousCoin += CoinsWon
        defo.set(PreviousCoin, forKey: "UserCoins")
        
        var PreviousExp = defo.integer(forKey: "UserExp")
        
        if Exp > 0 {
            PreviousExp += Exp
            defo.set(PreviousExp, forKey: "UserExp")
        }else if Exp < 0 {
            if PreviousExp > 0 {
                if PreviousExp >= Exp {
                    defo.set(PreviousExp + Exp, forKey: "UserExp")
                }else if PreviousExp < Exp {
                    defo.set(0, forKey: "UserExp")
                }
            }else if PreviousExp < 0 {
            }
        }
        
    }
    
    func updateDealerScore() -> Int{
        
        if dealerHasAs == 1 {////////////////// LE DEALER A 21
            if dealerScore == 10 {/////// ! ! ! ! ! ! ! ! ! ! ! ! !
                dealerScore = 21
                dealerScoreLabel.text = "\(dealerScore)"
                lost(way: "DealerBetterScore")
                return(0)
            }
        }
        
        if dealerHasAs == 0 { ///////////////// LE DEALER N'AS PAS D'AS
            dealerScoreLabel.text = "\(dealerScore)"
            return(0)

        }
        
        
        
        if dealerHasAs >= 1 {///////// LE DEALER A UN AS OU PLUS
            if dealerEncounteredAs == dealerHasAs {
                dealerScoreLabel.text = "\(dealerScore)"
                return(0)
            }else{
                if dealerHasAs + dealerScore + 10 < 21 {//////////// 11 FAIT PAS BUST
                    dealerScoreLabel.text = "\(dealerScore + 11)"
                    dealerScore += 11
                }else if (dealerHasAs == 1) && (dealerScore == 10) {
                    dealerScore = 21
                    dealerScoreLabel.text = "\(dealerScore)"
                    lost(way: "DealerBetterScore")
                    return(0)
                }else if (dealerHasAs + dealerScore + 10) > 21{///////////// LE 11 AS L'AURAIT FAIT BUST
                    dealerScore += 1
                    dealerScoreLabel.text = "\(dealerScore)"
                }
            }
            dealerEncounteredAs += 1
        }
        return(0)

    }
    func checkwin() -> Int{
        print("bro")
        if dealerScore > 21 {
            won(alt: "DealerBust")
            DealerBusted = true
        }
        if dealerScore <= 21{
          if dealerScore < playerScore {
                won(alt: "VICTORY")
                return(0)
          }else if dealerScore > playerScore {
              lost(way: "DealerBetterScore")
              return(0)
          }
        }
        if dealerScore == playerScore {
            push()
        }
        
        if dealerScore == 21 {
            if dealerScore > playerScore {
                lost(way: "DealerBetterScore")
                return(0)

            }
        }
        return(0)
    }

    func updatePlayerScoreStayPressed(){
        if playerHasAs > 0 {
            if playerHasOut10 == false { ////////////// STAY APPUYÉ :   SI LE SCORE DU  JOUEUR N'A PAS DEPASSSÉ 10 :     4,14 === > 14
                playerScore += playerHasAs+10
                playerScoreLabel.text = "\(playerScore)"
                print("LA ICI")
            }else {
                print("injad")
                playerScore = playerScore + playerHasAs
            }
        }
        
    }

    func updatePlayerScore(){
        
        print("playerscore :\(playerScore)")
        if playerScore + playerHasAs > 21 {//////////////////// LE JOUEUR BUST
            lost(way: "Bust")
            PlayerBusted = true
        }
        
        if playerHasAs >= 1 {
                if playerScore >= 10 {//////////////////////// A UN AS OU + MAIS A DEPASSÉ 10
                    playerHasOut10 = true
                    playerScoreLabel.text = "\(playerScore+playerHasAs)"
                }else if playerHas10onStart == 0 {////////////////////// LE JOUEUR A UN AS ET A 10 DE SCORE
                    if playerScore == 10 {
                        playerScore = playerScore + playerHasAs
                        playerScoreLabel.text = "\(playerScore+playerHasAs)"
                    }else if playerScore < 10 {//////////////////// A EN DESSOUS DE 10 ET N'AS PAS STAY
                        playerScoreLabel.text = "\(playerHasAs+playerScore), \(10 + playerHasAs + playerScore)"
                    }
                }
        }
        if playerHasAs == 0 {//////////////////////// LE JOUEUR N'A AUCUN AS
            playerScoreLabel.text = "\(playerScore)"
        }
        
        if playerHasAs == 1 {//////////////////// 21 SANS BLACKJACK
            if playerScore == 10 {
                playerScore += 11
                playerScoreLabel.text = "\(playerScore)"
                let wait = SKAction.wait(forDuration: 0.7)/////////// JOUEUR TIRE 21
                isUserInteractionEnabled = false/////////////////////////////////////
                let stayy = SKAction.run {
                    (self.stay())
                }
                if playerHasAsonStart == false && playerHas10onStart == 0 {
                    run(SKAction.sequence([wait,stayy]))
                }
            }
        }
        if playerHas10onStart >= 1{////////////////////// BLACKJACK ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
                if playerHasAsonStart == true {
                    isUserInteractionEnabled = false

                    playerScoreLabel.text = "21"
                    won(alt:"BLACKJACK")

                }
            }

    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///
    ///
    ///
    func SpawnCoins(IntGap : Int) {
        generator.impactOccurred()

        let CoinSound = SKAction.playSoundFileNamed("gamecoin.wav", waitForCompletion: false)
        if defo.bool(forKey: "soundon") == true{
            run(SKAction.sequence([CoinSound]))
        }
    
        let vector = SKAction.move(by: CGVector(dx: 30, dy: 17), duration: 2)
        let fadeout = SKAction.fadeOut(withDuration: 0.8)
        let Coins = SKSpriteNode(texture: SKTexture(imageNamed: "COINS1"))
        let CoinsText = SKLabelNode(fontNamed: "TextaW00-Heavy")
        
        CoinsText.fontColor = UIColor.yellow
        Coins.xScale = 0.35
        Coins.yScale = 0.35
        Coins.zPosition = 20
        CoinsText.zPosition = 20
        CoinsText.fontSize = 16
        addChild(Coins)
        addChild(CoinsText)
                 
        let randomint = Int.random(in: -(IntGap)...(IntGap))
        let brr = CGFloat(randomint)
        
        let wait = SKAction.wait(forDuration: 0.2)
        let Animation = SKAction.sequence([
            (SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS2")}),
            wait,
            (SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS3")}),
            wait,
            (SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS4")}),
            wait,
            (SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS5")}),
            wait,
            (SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS6")}),
            wait,
            (SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS7")}),
            wait,
            (SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS8")}),
            wait,
            (SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS9")}),
            wait,
            (SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS10")}),
            wait,
            (SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS1")})
        ])
        let loop = SKAction.sequence([Animation])
        let final = SKAction.repeatForever(loop)
        
            Coins.run(SKAction.rotate(toAngle: M_PI/2,duration: 0.001))
            CoinsText.text = "+1"
        
            Coins.position = CGPoint(x: 3*(self.frame.maxX/4), y: brr + 1.3*(self.frame.maxY/3))
            CoinsText.position = CGPoint(x: 12 + 3*(self.frame.maxX/4) + 3, y: brr + 1.3*(self.frame.maxY/3))
        
            Coins.run(final)
            CoinsText.run(SKAction.sequence([SKAction.wait(forDuration: 1),fadeout]))
            Coins.run(SKAction.sequence([SKAction.wait(forDuration: 1),fadeout]))
            Coins.run(vector)
            CoinsText.run(vector)
        
        
    }
    
    func displayCoins(CoinsNumber : Int) {
        var bruh = CGFloat(0.3)
        var bruh2 = 5
        for i in 1...CoinsNumber {
            run(SKAction.sequence([SKAction.wait(forDuration: bruh),SKAction.run{self.SpawnCoins(IntGap: bruh2)}]))
            bruh2 += 5
            bruh = bruh + CGFloat(0.3)
        }

    }
    
    func DisplayEXPnumbers(EXP : Int) -> SKLabelNode{
        let expsound = SKAction.playSoundFileNamed("expsound.wav", waitForCompletion: false)
        if self.defo.bool(forKey: "soundon") == true{
            self.run(SKAction.sequence([expsound]))
        }
        let fadeSequence = SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 1),SKAction.fadeAlpha(to: 0, duration: 1.1)])
        var vector : CGVector!
        var OperatorString : String!
        let ExpText = SKLabelNode(fontNamed: "TextaW00-Heavy")
        ExpText.position = CGPoint(x: 3.5*(frame.maxX/5), y: 1.4*(frame.maxY/4))
        ExpText.zPosition = 20
        if EXP > 0 {
            vector = CGVector(dx: 0, dy: 15)
            OperatorString = "+"
        }else if EXP < 0 {
            vector = CGVector(dx: 0, dy: -15)
            OperatorString = ""

        }else if EXP == 0 {
            vector = CGVector(dx: 15, dy: 0)
            OperatorString = "+"

        }
        let vectorSequence = SKAction.move(by: vector, duration: 1.85)
        addChild(ExpText)
        var exptext = String(EXP)
        var zbeub = OperatorString + exptext + "exp"
        ExpText.text =  "\(zbeub)"
        ExpText.fontSize = 18
        ExpText.run(fadeSequence)
        ExpText.run(vectorSequence)
        return(ExpText)
    }
    //var layout = SKAction.run()

    //let skView = view as SKView!
    var DealerBusted = false
    let playerScoreLabel = SKLabelNode(fontNamed: "TextaW00-Heavy")
    //playerScoreLabel.text = "0"
    let dealerScoreLabel = SKLabelNode(fontNamed: "TextaW00-Heavy")
    var playerScore = 0
    var dealerScore = 0
    
    let waitingtime =  SKAction.wait(forDuration: 10)

    var doubleass = 0
    
    var rect3 : SKShapeNode!
    var rect2 : SKShapeNode!
    var rect1 : SKShapeNode!

    
    var hitRect : SKShapeNode!
    var stayRect : SKShapeNode!

    var newNode : SKSpriteNode!
    
    var StayTouched = 0
    var hitPressed = 0
    
    var gameOver = false
    var vare = false
    
    var InnerRectangle : SKShapeNode!
    var OuterRectangle : SKShapeNode!
    var dealerEncounteredAs = 0
    var PlayercardSpawned = 0
    var DealercardSpawned = 0
    
    var justdepasse11 = false
    let generator = UIImpactFeedbackGenerator(style: .medium)

    var playerScoreRect : SKShapeNode!
    var dealerScoreRect : SKShapeNode!
    
    var PlayerNewCardX : CGFloat!
    var PlayerNewCardY : CGFloat!
    
    var DealerNewCardX : CGFloat!
    var DealerNewCardY : CGFloat!
    
    var playerHasAs = 0
    var dealerHasAs = 0
    
    var PlayerBusted = false
    var defo = UserDefaults.standard

    var DealerReturnedCard : SKSpriteNode!
    var playerHasOut10 = false

    let CoinsNodes : SKSpriteNode! = nil
    var AlreadyWonLost = false
    var playerHas10onStart = 0
    var dealerHas10 = 0
    

    var deck : SKSpriteNode!
    var deckpos : CGPoint!
    
    var zCardPositions : CGFloat!
    var addedValue : CGFloat!
    var BLACKJACK = false
    var  playerHasAsonStart = false
    var playercard10 = false

    //let NewCardX : CGFloat!
    //let NewCardY : CGFloat!
    
    var background : SKSpriteNode!
    
    var dealercard1 : SKSpriteNode!
    
    var dealercard2 : SKSpriteNode!
    var dealercard3 : SKSpriteNode!
    
    var hitbutton : SKSpriteNode!
    var staybutton : SKSpriteNode!
    
    var playercard1 : SKSpriteNode!
    var playercard2 : SKSpriteNode!
    var playercard3 : SKSpriteNode!

    var AutomaticHIT = false
    
    func transition(){
        let comebackScene = MenuScene(size: view!.bounds.size)
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        comebackScene.scaleMode = .aspectFill
        view!.presentScene(comebackScene,transition: reveal)
    }
    func EndGameText(way:String){
        
        defo.set(defo.integer(forKey:"GamesPlayed") + 1, forKey: "GamesPlayed")
        
        generator.impactOccurred()
        let remove = SKAction.run {
            self.removeFromParent()
        }
        var toploop : Double
        var botloop : Double
        botloop = 0
        toploop = 0
        for child in self.children {

            if child.name == "kardbot"{
                child.run(SKAction.sequence([SKAction.wait(forDuration: 2 + botloop),SKAction.move(by: CGVector(dx: 5, dy: -10), duration: 0.4)]))
                child.run(SKAction.sequence([SKAction.wait(forDuration: 2),SKAction.fadeOut(withDuration: 0.7),remove]))
                botloop += 0.2

            }else if child.name == "TABLEJEU"{
                child.run(SKAction.sequence([SKAction.wait(forDuration: 2),SKAction.fadeOut(withDuration: 0.4),remove]))
            }else if child.name == "kardtop" {
                child.run(SKAction.sequence([SKAction.wait(forDuration: 2 + toploop),SKAction.move(by: CGVector(dx: 8, dy: -10), duration: 0.7)]))
                child.run(SKAction.sequence([SKAction.wait(forDuration: 2),SKAction.fadeOut(withDuration: 0.7),remove]))
                toploop += 0.2
            }
        }

        let wait = SKAction.wait(forDuration: 2.3)
        let trans = SKAction.run({self.transition()})
        let text = SKLabelNode(fontNamed: "TextaW00-Heavy")
        text.fontSize = 33
        text.position = CGPoint(x: frame.maxX + 50, y: 3.35*(frame.maxY/4))
        text.zPosition = 10
        var InnerRectangle = SKShapeNode(rectOf: CGSize(width: 150, height: 50),cornerRadius: 5)
        InnerRectangle.position = CGPoint(x: frame.maxX + 200, y: 3.42*(frame.maxY/4))
        InnerRectangle.strokeColor = UIColor(red: 80/255, green: 130/255, blue: 130/255, alpha: 0)
        InnerRectangle.alpha = 0.2
        InnerRectangle.zPosition = 10
        
        var OuterRectangle = SKShapeNode(rectOf: CGSize(width: 150, height: 50),cornerRadius: 5)
        OuterRectangle.position = CGPoint(x: frame.maxX + 200, y: 3.42*(frame.maxY/4))
        OuterRectangle.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        OuterRectangle.fillColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0)
        OuterRectangle.lineWidth = CGFloat(5.5)
        OuterRectangle.zPosition = 9
        if (frame.maxY) > CGFloat(736) {
            InnerRectangle = SKShapeNode(rectOf: CGSize(width: 150, height: 52),cornerRadius: 5)
            OuterRectangle = SKShapeNode(rectOf: CGSize(width: 150, height: 54),cornerRadius: 5)
            OuterRectangle.position = CGPoint(x: frame.maxX + 200, y: 3.405*(frame.maxY/4))
            OuterRectangle.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            OuterRectangle.fillColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0)
            OuterRectangle.lineWidth = CGFloat(5.5)
            OuterRectangle.zPosition = 9
            InnerRectangle.position = CGPoint(x: frame.maxX + 200, y: 3.405*(frame.maxY/4))
            InnerRectangle.strokeColor = UIColor(red: 80/255, green: 130/255, blue: 130/255, alpha: 0)
            InnerRectangle.alpha = 0.2
            InnerRectangle.zPosition = 10
        }
        let victorySound = SKAction.playSoundFileNamed("victory.wav", waitForCompletion: false)
        let lostsound = SKAction.playSoundFileNamed("lost.wav", waitForCompletion: false)

        
        if way == "PlayerBust"{
            text.text = "YOU BUST"
            text.fontColor = UIColor.white
            EndGameScoreColorRect(User: "Player", Color: UIColor.red, WinState: true)
            DisplayEXPnumbers(EXP: -15)
            ModifyPlayerData(Exp: -15, CoinsWon: 0)
            defo.set(defo.integer(forKey:"GameLost") + 1, forKey: "GameLost")
            InnerRectangle.fillColor = UIColor(red: 15/255, green: 32/255, blue: 45/255, alpha: 1)
            if self.defo.bool(forKey: "soundon") == true{
                self.run(SKAction.sequence([SKAction.wait(forDuration: 1),lostsound]))
            }

        }else if way == "Victory" {
            text.text = "VICTORY"
            text.fontColor = UIColor.white
            EndGameScoreColorRect(User: "Player", Color: UIColor(red: 1/255, green: 200/255, blue: 255/255, alpha: 1), WinState: false)
            
            DisplayEXPnumbers(EXP: 45)
            ModifyPlayerData(Exp: 45, CoinsWon: 2 + defo.integer(forKey: "CoinsBonus"))
            defo.set(defo.integer(forKey:"GameWon") + 1, forKey: "GameWon")
            displayCoins(CoinsNumber: 2 + defo.integer(forKey: "CoinsBonus"))
            defo.set(true,forKey: "LastGameVictory?")
            
            defo.set(2 + defo.integer(forKey: "CoinsBonus"), forKey: "LastGameCoins")
            defo.set(45 + defo.integer(forKey: "LastGameExp"), forKey: "LastGameExp")
            
            InnerRectangle.fillColor = UIColor(red: 1/255, green: 123/255, blue: 255/255, alpha: 0.8)

            if self.defo.bool(forKey: "soundon") == true{
                self.run(SKAction.sequence([SKAction.wait(forDuration: 1),victorySound]))
            }

        }else if way == "DealerWins" {
            text.text = "DEALER WINS"
            text.fontColor = UIColor.white
            EndGameScoreColorRect(User: "Dealer", Color: UIColor.red, WinState: true)
            DisplayEXPnumbers(EXP: -20)
            ModifyPlayerData(Exp: -20, CoinsWon: 0)
            defo.set(defo.integer(forKey:"GameLost") + 1, forKey: "GameLost")
            InnerRectangle.fillColor = UIColor(red: 15/255, green: 32/255, blue: 45/255, alpha: 1)
            if self.defo.bool(forKey: "soundon") == true{
                self.run(SKAction.sequence([SKAction.wait(forDuration: 1),lostsound]))
            }
        }else if way == "Push"{
            text.text = "PUSH"
            text.fontColor = UIColor.white
            EndGameScoreColorRect(User: "Player", Color: UIColor.orange, WinState: false)
            EndGameScoreColorRect(User: "Dealer", Color: UIColor.orange, WinState: false)
            InnerRectangle.fillColor = UIColor(red: 15/255, green: 32/255, blue: 45/255, alpha: 1)
            DisplayEXPnumbers(EXP: 0)
            ModifyPlayerData(Exp: 0, CoinsWon: 0)

        }else if way == "blackjack"{
            
            text.text = "BLACKJACK"
            text.fontColor = UIColor.white
            EndGameScoreColorRect(User: "Player", Color: UIColor.cyan, WinState: true)
            InnerRectangle.fillColor = UIColor(red: 1/255, green: 123/255, blue: 255/255, alpha: 0.8)
            DisplayEXPnumbers(EXP: 80)
            ModifyPlayerData(Exp: 80, CoinsWon: 3 + defo.integer(forKey: "CoinsBonus"))
            
            displayCoins(CoinsNumber: 3 + defo.integer(forKey: "CoinsBonus"))
            defo.set(true,forKey: "LastGameVictory?")
            
            defo.set(80 + defo.integer(forKey: "LastGameExp"), forKey: "LastGameExp")
            defo.set(3 + defo.integer(forKey: "CoinsBonus"), forKey: "LastGameCoins")
            
            
            defo.set(defo.integer(forKey:"Blackjacks") + 1, forKey: "Blackjacks")

            if self.defo.bool(forKey: "soundon") == true{
                self.run(SKAction.sequence([SKAction.wait(forDuration: 1),victorySound]))
            }
        }else if way == "DealerBust"{
            
            text.text = "DEALER BUSTS"
            text.fontColor = UIColor.white
            EndGameScoreColorRect(User: "Player", Color: UIColor(red: 1/255, green: 200/255, blue: 255/255, alpha: 1), WinState: true)
            DisplayEXPnumbers(EXP: 35)
            ModifyPlayerData(Exp: 35, CoinsWon: 2 + defo.integer(forKey: "CoinsBonus"))
            displayCoins(CoinsNumber: 2 + defo.integer(forKey: "CoinsBonus"))
            InnerRectangle.fillColor = UIColor(red: 1/255, green: 123/255, blue: 255/255, alpha: 0.8)
            defo.set(true,forKey: "LastGameVictory?")
            
            defo.set(35 + defo.integer(forKey: "LastGameExp"), forKey: "LastGameExp")
            defo.set(2 + defo.integer(forKey: "CoinsBonus"), forKey: "LastGameCoins")
            
            defo.set(defo.integer(forKey:"GameWon") + 1, forKey: "GameWon")
            if self.defo.bool(forKey: "soundon") == true{
                self.run(SKAction.sequence([SKAction.wait(forDuration: 1),victorySound]))
            }
        }
        let addText = SKAction.run {
            self.addChild(text)
            text.alpha = CGFloat(0.3)
            text.yScale = CGFloat(0.8)
            text.xScale = CGFloat(0.7)
        }
        let MoveIn = SKAction.run {
            text.run(SKAction.fadeAlpha(to: 1, duration: 0.33))
            text.run(SKAction.scaleX(to: 1, duration: 0.33))
            text.run(SKAction.scaleY(to: 1, duration: 0.33))
            text.run(SKAction.moveTo(x: self.frame.midX, duration: 0.8))
        }
        
        let waitvitefait = SKAction.wait(forDuration: 0.6)
        


        
        let ScaleScene = SKAction.scaleX(to: 15, duration: 0.8)
        let meh = SKAction.fadeAlpha(to: 1, duration: 1.25)
        let InnerAction = SKAction.run{InnerRectangle.run(ScaleScene)
                                InnerRectangle.run(meh)}
        let OuterAction = SKAction.run{OuterRectangle.run(ScaleScene)}
        
        let bro = SKAction.wait(forDuration: 0.5)
        let rectSeq = SKAction.sequence([InnerAction,bro,OuterAction])
        
        addChild(InnerRectangle)
        addChild(OuterRectangle)
        
        let VectorAll = SKAction.run {
            self.run(SKAction.sequence([
                addText,
                MoveIn,
                rectSeq
            ]))
            self.deck.run(SKAction.moveTo(y: self.frame.maxY + 100, duration: 0.6))

        }
        run(SKAction.sequence([waitvitefait,VectorAll,wait,trans]))

    }
    
    func EndGameScoreColorRect(User : String,Color : UIColor, WinState : Bool){
        
        rect1 = SKShapeNode(rectOf: CGSize(width: 60, height: 35),cornerRadius: 10)
        rect1.fillColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0)
        rect1.lineWidth = CGFloat(2)
        rect1.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        rect1.zPosition = CGFloat(1)

        rect2 = SKShapeNode(rectOf: CGSize(width: 60, height: 35),cornerRadius: 10)
        rect2.fillColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0)
        rect2.lineWidth = CGFloat(2)
        rect2.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        rect2.zPosition = CGFloat(1)
    
        addChild(rect1)
        addChild(rect2)
        
        rect1.run(SKAction.fadeOut(withDuration: 0.8))
        rect1.run(SKAction.scaleX(to: 1.15, duration: 0.8))
        rect1.run(SKAction.scaleY(to: 1.15, duration: 0.8))
        
        rect2.run(SKAction.fadeOut(withDuration: 0.9))
        rect2.run(SKAction.scaleX(to: 1.25, duration: 0.9))
        rect2.run(SKAction.scaleY(to: 1.25, duration: 0.9))
        

        
        if User == "Dealer"{
            dealerScoreRect.strokeColor = Color
            rect1.position = CGPoint(x: frame.midX, y:2.9*(frame.maxY/4))
            rect2.position = CGPoint(x: frame.midX, y:2.9*(frame.maxY/4))

        }else if User == "Player"{
            playerScoreRect.strokeColor = Color
            rect2.position = CGPoint(x: frame.midX, y: frame.midY-11.25)
            rect1.position = CGPoint(x: frame.midX, y: frame.midY-11.25)

        }
        if WinState == true {
    
        }
    }

    
    func lost(way:String){
        AlreadyWonLost = true
        isUserInteractionEnabled = false
        if way == "Bust"{
            EndGameText(way: "PlayerBust")

            
        }else if way == "DealerBetterScore"{
            EndGameText(way: "DealerWins")
   
        }
    }

    func push(){
        AlreadyWonLost = true
        EndGameText(way: "Push")
    }
    
    
     
    func won(alt : String){
        AlreadyWonLost = true
        isUserInteractionEnabled = false
        hitbutton.isUserInteractionEnabled = false
        staybutton.isUserInteractionEnabled = false

        
        if alt == "DealerBust"{

            EndGameText(way: "DealerBust")

            
        }else if alt == "VICTORY"{

            EndGameText(way: "Victory")


        }else if alt == "BLACKJACK"{
            EndGameText(way: "blackjack")
        }
        
    }
    
    func layerToSKSpritenode(layer : CALayer) -> SKSpriteNode {
        let view = UIView()
        layer.frame = self.frame
        view.layer.addSublayer(layer)
        UIGraphicsBeginImageContext(self.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        newNode = SKSpriteNode(texture: SKTexture(image: bgImage))
        return(newNode)
    }
        
    func MakeCGcolor(RED : CGFloat, GREEN : CGFloat,BLUE : CGFloat) -> CGColor {
        return(CGColor(red: RED/255, green: GREEN/255, blue: BLUE/255, alpha: 1.0))
    }

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func Particles(XValue : CGPoint){
        var exodeX = CGFloat(30)
        var exodeY = CGFloat(10)
        let zizou = Int.random(in: 1...2)
        let zizou2 = Int.random(in: 1...2)
        var rotateValue : Double!
        if zizou == 1 {
            exodeX = -(exodeX)
            rotateValue = M_PI/4
        }else if zizou == 2{
            exodeY = -(exodeY)
            rotateValue = -M_PI/4

        }
            
    
        let exodeAction = SKAction.move(by: CGVector(dx: exodeX, dy: exodeY), duration: 2.6)
        let fadeSequence = SKAction.sequence([SKAction.fadeAlpha(to: 0.7, duration: 1.3),SKAction.fadeAlpha(to: 0, duration: 1.3)])
        let square = SKShapeNode(rectOf: CGSize(width: 4, height: 4))
        let rotating = SKAction.rotate(byAngle: rotateValue, duration: 2)
        let scaleSequence = SKAction.sequence([SKAction.scale(by: 1.3, duration: 1),SKAction.scale(by: 0.6, duration: 1)])
        square.fillColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        square.strokeColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        square.alpha = 0.2

        square.zPosition = -99
     
        
        let randomValue = Int.random(in: 1...30)
        let fdp = CGFloat(randomValue)
            square.position = CGPoint(x: XValue.x + fdp, y: XValue.y + fdp)
            addChild(square)
            square.run(exodeAction)
        square.run(fadeSequence)
        square.run(rotating)
        square.run(scaleSequence)
        
    }

    func layoutScene(){
        let wait4 = SKAction.wait(forDuration: 4.25)
        let wait5 = SKAction.wait(forDuration: 3.9)
        let wait3 = SKAction.wait(forDuration: 3.2)
        let e = SKAction.run{self.Particles(XValue: CGPoint(x: self.frame.midX, y: self.frame.midY))}
        let f = SKAction.run{self.Particles(XValue: CGPoint(x: 2*(self.frame.maxX/5), y: 4*(self.frame.maxY/5)))}
        let t = SKAction.run{self.Particles(XValue: CGPoint(x: 1*(self.frame.maxX/5), y: 4.6*(self.frame.maxY/5)))}
        let y = SKAction.run{self.Particles(XValue: CGPoint(x: 3.4*(self.frame.maxX/5), y: 3.5*(self.frame.maxY/5)))}
        let p = SKAction.run{self.Particles(XValue: CGPoint(x: 0.7*(self.frame.maxX/5), y: 4*(self.frame.maxY/5)))}
        let pp = SKAction.run{self.Particles(XValue: CGPoint(x: 0.4*(self.frame.maxX/5), y: 1.6*(self.frame.maxY/5)))}

        
        let o = SKAction.run{self.Particles(XValue: CGPoint(x: 1*(self.frame.maxX/5), y: 4*(self.frame.maxY/10)))}
        let oo = SKAction.run{self.Particles(XValue: CGPoint(x: 3.5*(self.frame.maxX/5), y: 4*(self.frame.maxY/10)))}

        let i = SKAction.run{self.Particles(XValue: CGPoint(x: 1.5*(self.frame.maxX/5), y: 1*(self.frame.maxY/10)))}
        let ii = SKAction.run{self.Particles(XValue: CGPoint(x: 3.25*(self.frame.maxX/5), y: 1*(self.frame.maxY/10)))}
        
        let pd = SKAction.run{self.Particles(XValue: CGPoint(x: 2.1*(self.frame.maxX/5), y: 3.7*(self.frame.maxY/10)))}
        let z = SKAction.run{self.Particles(XValue: CGPoint(x: 4.4*(self.frame.maxX/5), y: 9*(self.frame.maxY/10)))}
        run(SKAction.repeatForever(SKAction.sequence([wait4,e])))
        run(SKAction.repeatForever(SKAction.sequence([wait3,f])))
        run(SKAction.repeatForever(SKAction.sequence([t,wait5])))
        run(SKAction.repeatForever(SKAction.sequence([wait3,y])))
        run(SKAction.repeatForever(SKAction.sequence([i,wait5])))
        run(SKAction.repeatForever(SKAction.sequence([wait3,ii])))
        run(SKAction.repeatForever(SKAction.sequence([o,wait4])))
        run(SKAction.repeatForever(SKAction.sequence([oo,wait5])))
        run(SKAction.repeatForever(SKAction.sequence([p,wait4])))
        run(SKAction.repeatForever(SKAction.sequence([pp,wait5])))
        run(SKAction.repeatForever(SKAction.sequence([z,wait3])))
        run(SKAction.repeatForever(SKAction.sequence([pd,wait3])))

        let a = MakeCGcolor(RED: 0, GREEN: 12, BLUE: 24)
        let b = MakeCGcolor(RED: 0, GREEN: 23, BLUE: 45)
        let c = MakeCGcolor(RED: 0, GREEN: 38 , BLUE: 77)

        let gradient = CAGradientLayer()
            gradient.type = .axial
            
            gradient.colors = [
                a,
                b,
                c
        
            ]
        gradient.removeFromSuperlayer()
        gradient.frame = self.view!.bounds
        background = layerToSKSpritenode(layer: gradient)
   
        func TopRect(){
            let rect = SKShapeNode(rectOf: CGSize(width: frame.maxX , height: frame.midY / 3),cornerRadius: 40)
            rect.position = CGPoint(x: frame.midX, y: frame.maxY)
            rect.fillColor = UIColor(red: 1/255, green: 123/255, blue: 255/255, alpha: 0.99)
            rect.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
            rect.lineWidth = CGFloat(8)
            rect.zPosition = 10
            addChild(rect)
            
        }
        func MidRect(){

            let rect1 = SKShapeNode(rectOf: CGSize(width: frame.maxX - 14, height: frame.midY + 62), cornerRadius: 10)
            rect1.name = "TABLEJEU"
            rect1.position = CGPoint(x: frame.midX, y: frame.midY)
            rect1.strokeColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            rect1.lineWidth = CGFloat(2)
            rect1.zPosition = -10
            rect1.alpha = 0
            
            addChild(rect1)
            rect1.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        }

        func BottomRect(){
            let rect = SKShapeNode(rectOf: CGSize(width: frame.maxX - 25, height: 3.5 * (frame.maxY/10)),cornerRadius: 35)
            rect.position = CGPoint(x: frame.midX, y: frame.minY)
            rect.fillColor = UIColor(red: 1/255, green: 123/255, blue: 255/255, alpha: 1)
            rect.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
            rect.lineWidth = CGFloat(7.5)
            addChild(rect)
        }
        
        func deckq(){
            deck = SKSpriteNode(texture: SKTexture(imageNamed: defo.string(forKey: "DeckSelected")!))
            deck.position = CGPoint(x: frame.maxX - 40, y: frame.maxY + 40)
            deck.xScale = 0.7
            deck.yScale = 0.65
            deck.zPosition = -10
            addChild(deck)
            deck.run(SKAction.move(to: deckpos  , duration: 1))
            if (defo.string(forKey: "DeckSelected")!) == "deckhalloween" {
                deck.xScale = 0.5
                deck.yScale = 0.45
            }
        }
        func hitfunc(){
            hitbutton = SKSpriteNode(imageNamed: "HIT")
            hitbutton.position = CGPoint(x:frame.midX - 85, y: frame.maxY / 10)
            hitbutton.name = "ButtonHit"
            hitbutton.zPosition = 1
            hitbutton.xScale = 0.36
            hitbutton.yScale = 0.36
            addChild(hitbutton)
            
        }
        func stayfunc(){
            staybutton = SKSpriteNode(imageNamed: "STAND")
            staybutton.position = CGPoint(x:frame.midX + 85, y: frame.maxY / 10)
            staybutton.name = "ButtonStay"
            staybutton.zPosition = 1
            staybutton.xScale = 0.36
            staybutton.yScale = 0.36
            addChild(staybutton)
        }
        func bjbaneer(){
            let baneer = SKSpriteNode(imageNamed: "blackjack2to3")
            baneer.position = CGPoint(x: frame.midX, y: frame.midY+30)
            baneer.xScale = 0.25
            baneer.yScale = 0.25
            addChild(baneer)
        }
        MidRect()
        deckq()
        hitfunc()
        stayfunc()
        BottomRect()
        TopRect()
        background.zPosition = -100
        background.position = CGPoint(x: frame.width/2, y: frame.height/2)
        addChild(background)
        print(staybutton.isUserInteractionEnabled)
        print(hitbutton.isUserInteractionEnabled)

    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func returnDealerCard(card: SKSpriteNode) -> SKSpriteNode{
      return card
    }
    
    func spawnRandomCard(user:String, xPos:CGFloat ,yPos:CGFloat) -> SKSpriteNode{
        print(staybutton.isUserInteractionEnabled)
        print(hitbutton.isUserInteractionEnabled)
        addedValue = 1
        zCardPositions = zCardPositions + addedValue
        let family = ["TREFLE", "CARREAU", "COEUR", "PIC"]
        let randFamily = Int.random(in: 0...3)
        var randInt = Int.random(in: 2...14)///////////////////////////////////////////// RANDOMIZER
        let returnedCard = SKSpriteNode(imageNamed: defo.string(forKey: "SkinSelected")!)
        let randomCardAction = SKAction.run({self.addChild(returnedCard)})
        let RandomCardTexture = SKTexture(imageNamed: "\(randInt) \(family[randFamily])")

        let wait = SKAction.wait(forDuration: 0.3)
                
        if randInt == 11 || randInt == 12 || randInt == 13{
            randInt = 10
        }
        if (user == "Dealer"){
            DealercardSpawned += 0
            run(SKAction.sequence([randomCardAction,wait]))
            if randInt != 14 {
                dealerScore += randInt

            }else if randInt == 14{
                dealerHasAs += 1
            }
            }
        
        else if user == "Player"{
            PlayercardSpawned += 1
            run(SKAction.sequence([randomCardAction,wait]))
            if randInt != 14 {
                playerScore+=randInt
            }else if randInt == 14{
                playerHasAs += 1
            }
            

            if playerHasAs == 11{
                playerScore += playerHasAs
            }

        }
        else if user == "Returned"{
            addChild(returnedCard)
        }

        if vare == true {
            if randInt != 14 {
                noas = false
            }else {
                noas = true
            }
        }
        returnedCard.xScale = 0.33
        returnedCard.yScale = 0.31
        if (frame.maxY) > CGFloat(736) {
            returnedCard.xScale = 0.43
            returnedCard.yScale = 0.4
        }
        returnedCard.zPosition = zCardPositions
        returnedCard.position = CGPoint(x: frame.maxX, y: frame.maxY)
        //let moveToPointX = SKAction.moveTo(x: xPos, duration: 0.5)
        //let moveToPointY = SKAction.moveTo(y: yPos, duration: 0.5)
        //let moveXandY = SKAction.sequence([moveToPointX,moveToPointY])
        let waitCardVector = SKAction.wait(forDuration: 0.45)
        let topleft = CGPoint(x: frame.maxX - 70, y: frame.maxY - 75)
        let CardPoint = CGPoint(x: xPos, y: yPos)
        
        let vector = CGVector(dx: CardPoint.x - topleft.x + 25, dy: CardPoint.y - topleft.y - 8)
        let vectorAction = SKAction.move(by: vector, duration: 0.3)
        
        let vector2 = CGVector(dx: -25, dy: 8)
        let vectorAction2 = SKAction.move(by: vector2, duration: 0.15)

        let ee = SKAction.sequence([vectorAction,SKAction.wait(forDuration: 0.25),vectorAction2])
        let movementSound = SKAction.playSoundFileNamed("cardmoov.mp3", waitForCompletion: false)
        let flippingSound = SKAction.playSoundFileNamed("cardflip.mp3", waitForCompletion: false)
        let waitSound = SKAction.wait(forDuration: 0.59)

        let swapCardSide = SKAction.run {
            returnedCard.run(SKAction.scaleX(to: 0.28, duration: 0.1));///// REDUIT UN PEU LA CARTE
            returnedCard.texture = RandomCardTexture;
            returnedCard.run(SKAction.scaleX(to: -0.32, duration: 0))////////////// SPAWN CARTE EN MIROIR
            returnedCard.run(SKAction.scaleX(to: -0.05, duration: 0.08))//////// RETOURNEMENT 1/2
            returnedCard.run(SKAction.scaleX(to: 0.05, duration: 0))//////////// MIROIR LA CARTE (taille reduite)
            ///
            if (self.frame.maxY) <= CGFloat(736) {
                returnedCard.run(SKAction.scaleX(to: 0.33, duration: 0.15))////////////// REMET A TAILLE NORMALE
            }else {
                returnedCard.run(SKAction.scaleX(to: 0.43, duration: 0.15))////////////// REMET A TAILLE NORMALE
            }
            // ||
        }
        
        let moveBotCards = SKAction.run {
            for child in self.children {
                if child.name == "kardbot"{
                    child.run(SKAction.moveBy(x: -2.5, y: 0, duration: 0.2))
                }
                
            }
        }
        let moveTopCards = SKAction.run {
            for child in self.children {
                if child.name == "kardtop"{
                    child.run(SKAction.moveBy(x: -2.5, y: 0, duration: 0.2))
                }
                
            }
        }
        
        if (user != "StayDealer") && (user != "Returned") {
            run(SKAction.sequence([SKAction.run{returnedCard.run(ee)},waitCardVector,swapCardSide]))
            if defo.bool(forKey: "soundon") == true{
                run(SKAction.sequence([movementSound,waitSound,flippingSound]))
            }
            if (user == "Player") {
                run(moveBotCards)
            }else if user == "Dealer" {
                run(moveTopCards)
            }
        }else if user == "Returned"{
            
            returnedCard.run(SKAction.sequence([ee]))
            if defo.bool(forKey: "soundon") == true{
                run(SKAction.sequence([movementSound]))
            }
        }
        
        return(returnedCard)
    }
    
    
    
    func funcReturnDealer(card : SKSpriteNode, CardNumber : Int, FamilyNumber : Int) -> SKSpriteNode{
        let family = ["TREFLE", "CARREAU", "COEUR", "PIC"]
        let RandomCardTexture = SKTexture(imageNamed: "\(CardNumber) \(family[FamilyNumber])")
        let flippingSound = SKAction.playSoundFileNamed("cardflip.mp3", waitForCompletion: false)

        let swapCardSide = SKAction.run {
            card.run(SKAction.scaleX(to: 0.28, duration: 0.1));///// REDUIT UN PEU LA CARTE
            card.texture = RandomCardTexture;
            card.run(SKAction.scaleX(to: -0.32, duration: 0))////////////// SPAWN CARTE EN MIROIR
            card.run(SKAction.scaleX(to: -0.05, duration: 0.08))//////// RETOURNEMENT 1/2
            card.run(SKAction.scaleX(to: 0.05, duration: 0))//////////// MIROIR LA CARTE (taille reduite)
            if (self.frame.maxY) <= CGFloat(736) {
                card.run(SKAction.scaleX(to: 0.33, duration: 0.15))////////////// REMET A TAILLE NORMALE
            }else {
                card.run(SKAction.scaleX(to: 0.43, duration: 0.15))////////////// REMET A TAILLE NORMALE
            }

        }
        if defo.bool(forKey: "soundon") == true{
            run(SKAction.sequence([flippingSound]))
        }
        run(swapCardSide)
        return(card)
    }
    
    
    func AdaptiveNodes(){
        if (frame.maxY) <= CGFloat(580){///////////////// IPOD

            
        }else if (frame.maxY) > CGFloat(600) && (frame.maxY) <= CGFloat(736){///////////////// IPHONE 7 8
            deckpos = CGPoint(x: frame.maxX - 75, y: ((frame.maxY)-(frame.maxY / 8.3)))
        }else if (frame.maxY) > CGFloat(736) && (frame.maxY) < CGFloat(900){////////////////// IPHONE XR 11 12 13
            deckpos = CGPoint(x: frame.maxX - 75, y: ((frame.maxY)-(frame.maxY / 9.5)))
        }else if (frame.maxY) > CGFloat(900){///////////// IPHONE MAX 13 MAX 12 MAX
            deckpos = CGPoint(x: frame.maxX - 75, y: ((frame.maxY)-(frame.maxY / 9.5)))
        }

    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    func disableUserInter(time :Double){
        let disable = SKAction.run {
            self.view!.isUserInteractionEnabled = false
        }
        let waitTime = SKAction.wait(forDuration: time)
        let enable = SKAction.run {
            self.view!.isUserInteractionEnabled = true
        }
        
        run(SKAction.sequence([disable,waitTime,enable]))
    }
    
    
    func gameSetup(){

        DealerNewCardX = 70
        DealerNewCardY = 80
        zCardPositions = 0
        addedValue = 1
        
        func displayScores(){
                    playerScoreLabel.position = CGPoint (x : frame.midX, y: frame.midY-20)
                    playerScoreLabel.text = "0"
                    playerScoreLabel.fontSize = 23
            playerScoreLabel.zPosition = 21
                    playerScoreRect = SKShapeNode(rect: CGRect(x: frame.midX-30, y: frame.midY-30, width: 60, height: 35),cornerRadius: 10)
                    playerScoreRect.fillColor = UIColor(red: 15/255, green: 32/255, blue: 45/255, alpha: 1)
                    playerScoreRect.lineWidth = CGFloat(3)
                    playerScoreRect.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            playerScoreRect.zPosition = 20
                    addChild(playerScoreLabel)
                    addChild(playerScoreRect)
                    
                    dealerScoreLabel.position = CGPoint (x: frame.midX, y: 2 * (frame.maxY/2.8))
                    dealerScoreLabel.text = "0"
                    dealerScoreLabel.fontSize = 23
            dealerScoreLabel.zPosition = 21
            
                    dealerScoreRect = SKShapeNode(rect: CGRect(x: frame.midX-30, y: 2 * (frame.maxY/2.8) - 10, width: 60, height: 35),cornerRadius: 10)
                    dealerScoreRect.fillColor = UIColor(red: 15/255, green: 32/255, blue: 45/255, alpha: 1)
                    dealerScoreRect.strokeColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            dealerScoreRect.zPosition = 20
                    dealerScoreRect.lineWidth = CGFloat(3)
                    addChild(dealerScoreLabel)
                    addChild(dealerScoreRect)
                }
                
            displayScores()

                
 
            }
            func displaycards(){

                                
                let waitCard = SKAction.wait(forDuration: 0.7)
                let updatePlayerAction = SKAction.run {
                    (self.updatePlayerScore())
                }
                let updateDealerAction = SKAction.run {
                    (self.updateDealerScore())
                }

             
                let playerAction1 = SKAction.run {
                    self.playercard1 = self.spawnRandomCard(user: "Player", xPos: -10, yPos: self.frame.maxY / 3.6 )
                    self.playercard1.name = "kardbot"
                    if self.playerScore == 10 {
                        self.playerHas10onStart += 1
                    }
                        if self.playerHasAs == 1 {
                        self.playerHasAsonStart = true
                    }
                    
                    
                    self.DealerReturnedCard = SKSpriteNode()
                    self.DealerReturnedCard.alpha = 0
                    self.DealerReturnedCard.name = "kardtop"
                }
                
                let dealerCard1Action = SKAction.run {
                    self.dealercard1 = self.spawnRandomCard(user: "Dealer", xPos: -10, yPos: 2 * (self.frame.maxY / 3.6) );
                    self.dealercard1.name = "kardtop"
                }
                
                let playerAction2 = SKAction.run {
                    self.playercard2 = self.spawnRandomCard(user: "Player", xPos: 30 , yPos: self.frame.maxY / 3.6 - 10);
                    self.playercard2.name = "kardbot"

                    if self.playerScore == 10 {
                        self.playerHas10onStart += 1
                    }
                    if self.playerHasAs == 1 {
                        self.playerHasAsonStart = true
                    }
                }

                let dealerCard2Action = SKAction.run {
                    self.DealerReturnedCard = self.spawnRandomCard(user: "Returned", xPos: 30, yPos: 2 * (self.frame.maxY / 3.6) - 10);
                    self.DealerReturnedCard.name = "kardtop"

                }
                run(SKAction.sequence([playerAction1,waitCard,updatePlayerAction,
                                       dealerCard1Action,waitCard,updateDealerAction,
                                       playerAction2,waitCard,updatePlayerAction,
                                       dealerCard2Action]))

                updatePlayerScore()
                updateDealerScore()
                
                if playerScore == 10 {
                    playerHas10onStart += 1
                }
                if playerHasAs == 1 {
                    playerHasAsonStart = true
                }
                PlayerNewCardX = 70
                PlayerNewCardY = 20
                
                if playerHasAsonStart == true && playerHas10onStart == 1 {
                    BLACKJACK = true
                }
        
            }
    
            func hit(){
          
                let waitCard = SKAction.wait(forDuration: 0.7)
                let PlayerUpdate = SKAction.run{
                    self.updatePlayerScore()
                }
                playercard3 = spawnRandomCard(user : "Player", xPos: PlayerNewCardX, yPos: self.frame.maxY / 3.6 - PlayerNewCardY)
                playercard3.name = "kardbot"

                run(SKAction.sequence([waitCard,PlayerUpdate]))

                let waitCardSpawn = SKAction.wait(forDuration: 0.5)
                let disableInter: () = isUserInteractionEnabled = true
                let enableInter: () = isUserInteractionEnabled = true
                let disablePlayerInteraction = SKAction.sequence([
                    SKAction.run{disableInter},
                    SKAction.run{self.hitbutton.alpha = 0.3},
                    waitCardSpawn,
                    SKAction.run{enableInter},
                    SKAction.run{self.hitbutton.alpha = 1.0}
                
                ])
                run(SKAction.sequence([disablePlayerInteraction]))
                if playerScore+playerHasAs == 21 && playerHasAsonStart == false && playerHas10onStart == 0{////////////////////////////////////
                    let wait = SKAction.wait(forDuration: 0.7)/////////// JOUEUR TIRE 21
                    isUserInteractionEnabled = false/////////////////////////////////////
                    let stayy = SKAction.run {
                        if self.BLACKJACK == false {
                            (self.stay())
                        }
                    }
                    run(SKAction.sequence([wait,stayy]))
                }
                PlayerNewCardX += 40
                PlayerNewCardY += 10
                
            }
            
    
            func stay(){
                AutomaticHIT = true
                var stayX : CGFloat!
                var stayY : CGFloat!
                stayX = 70
                stayY = 20
                updatePlayerScoreStayPressed()
   
                var randInt = Int.random(in: 2...14)/////////////////////////////////////////////////// RANDOMIZER
                let waitNextCard = SKAction.wait(forDuration: 0.7)
                var randFamily = Int.random(in: 0...3)
                let spawnReturnedCard = SKAction.run {
                   
                  _ = self.funcReturnDealer(card: self.DealerReturnedCard, CardNumber: randInt, FamilyNumber: randFamily)
                }
                let waitCardAnim = SKAction.wait(forDuration: 0.2)
                
                let returnUpdate = SKAction.run {
                    if randInt == 11 || randInt == 12 || randInt == 13{
                        randInt = 10
                        self.dealerScore += randInt
                    }else if randInt == 14 {
                        self.dealerHasAs += 1
                    }else{
                        self.dealerScore += randInt
                    }
                    self.updateDealerScore()
                }
                let dealerUpdate = SKAction.run {
                    self.updateDealerScore()
                }
                let checkwinn = SKAction.run {
                    self.checkwin()
                }
                
                let giveNewCard = SKAction.run {
                    if self.dealerScore < 17 {
                        self.dealercard3 = self.spawnRandomCard(user: "Dealer", xPos: stayX, yPos:  2 * (self.frame.maxY / 3.6) - stayY)
                        self.dealercard3.name = "kardtop"
                        stayX += 40
                        stayY += 10
                    }else{
                        if self.gameOver == false {
                            self.gameOver = true
                            if self.AlreadyWonLost == false {
                                self.run(checkwinn)
                            }
                            self.removeAllActions()
                        }
                    }
                
                }
                let boucle = SKAction.run {
                    if self.gameOver == false {
                        self.run(SKAction.repeat(SKAction.sequence([giveNewCard,waitNextCard,dealerUpdate]),count: 20))
                    }
                    
                }
                //let repeatAction = SKAction.repeat(SKAction.sequence([giveNewCard,waitNextCard,dealerUpdate]),count: 20)
                run(SKAction.sequence([spawnReturnedCard,waitCardAnim,returnUpdate,waitNextCard,boucle]))
                

            }
    
            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
            {

                let wait = SKAction.wait(forDuration: 0.1)
                
                let generator = UIImpactFeedbackGenerator(style: .medium)

                let ScaleDown = SKAction.scale(by: 0.85, duration: 0.11)
                let FadeDown = SKAction.fadeAlpha(to: 0.92, duration: 0.11)
                let ScaleBack = SKAction.scale(to: 0.35, duration: 0.11)
                let FadeBack = SKAction.fadeAlpha(to: 1, duration: 0.11)
                let Pressedbutton = SKAction.sequence([ScaleDown,FadeDown,ScaleBack,FadeBack])
                
                for touch in touches {
                    
                    let location = touch.location(in: self)
                    let touchedNode = self.nodes(at: location)
                    
                    for node in touchedNode {
                        
                        if node.name == "ButtonHit"{
                                    disableUserInter(time: 1.2)
                                    generator.impactOccurred()
                                    node.run(Pressedbutton)
                                    if StayTouched == 0 {
                                        if playerScore < 21 {
                                            hit()
                                            hitPressed += 1
                                        }
                                    }
                            
                        }
                        else if node.name == "ButtonStay"{
                                    if PlayerBusted == false {
                                    generator.impactOccurred()
                                    node.run(Pressedbutton)
                                    if StayTouched < 1 || AutomaticHIT == false {
                                        StayTouched += 1
                                        stay()
                                    }
                                }
                            
                        }
                    }
                }
            }
        }



