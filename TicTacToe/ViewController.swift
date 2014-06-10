//
//  ViewController.swift
//  TicTacToe
//
//  Created by Jacob Schatz on 6/5/14.
//  Copyright (c) 2014 Bisonkick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tictacBtn1 : UIButton = nil
    @IBOutlet var tictacBtn2 : UIButton = nil
    @IBOutlet var tictacBtn3 : UIButton = nil
    @IBOutlet var tictacBtn4 : UIButton = nil
    @IBOutlet var tictacBtn5 : UIButton = nil
    @IBOutlet var tictacBtn6 : UIButton = nil
    @IBOutlet var tictacBtn7 : UIButton = nil
    @IBOutlet var tictacBtn8 : UIButton = nil
    @IBOutlet var tictacBtn9 : UIButton = nil
    
    @IBOutlet var tictacImg1 : UIImageView = nil
    @IBOutlet var tictacImg2 : UIImageView = nil
    @IBOutlet var tictacImg3 : UIImageView = nil
    @IBOutlet var tictacImg4 : UIImageView = nil
    @IBOutlet var tictacImg5 : UIImageView = nil
    @IBOutlet var tictacImg6 : UIImageView = nil
    @IBOutlet var tictacImg7 : UIImageView = nil
    @IBOutlet var tictacImg8 : UIImageView = nil
    @IBOutlet var tictacImg9 : UIImageView = nil
    
    
    
    @IBOutlet var resetBtn : UIButton = nil
    @IBOutlet var userMessage : UILabel = nil
    
    var plays = Dictionary<Int,Int>()
    var done = false
    
    var aiDeciding = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func resetBtnClicked(sender : UIButton) {
        done = false
        resetBtn.hidden = true
        userMessage.hidden = true
        reset()
    }
    
    @IBAction func UIImageViewClicked(sender:UIButton){
        
        userMessage.hidden = true
        if !plays[sender.tag] && !aiDeciding && !done {
            setImageForSpot(sender.tag, player: 1)
        }
        
        checkForWin()
        aiTurn()
    }
    
    func setImageForSpot(spot:Int,player:Int){
        var playerMark = player == 1 ? "x" : "o"
        plays[spot] = player
        switch spot {
        case 1:
            tictacImg1.image = UIImage(named: playerMark)
        case 2:
            tictacImg2.image = UIImage(named: playerMark)
        case 3:
            tictacImg3.image = UIImage(named: playerMark)
        case 4:
            tictacImg4.image = UIImage(named: playerMark)
        case 5:
            tictacImg5.image = UIImage(named: playerMark)
        case 6:
            tictacImg6.image = UIImage(named: playerMark)
        case 7:
            tictacImg7.image = UIImage(named: playerMark)
        case 8:
            tictacImg8.image = UIImage(named: playerMark)
        case 9:
            tictacImg9.image = UIImage(named: playerMark)
        default:
            tictacImg5.image = UIImage(named: playerMark)
        }
    }
    
    func checkForWin(){
        //first row across
        var youWin = 1
        var theyWin = 0
        var whoWon = ["I":0,"you":1]
        for (key,value) in whoWon {
            if ((plays[7] == value && plays[8] == value && plays[9] == value) || //across the bottom
            (plays[4] == value && plays[5] == value && plays[6] == value) || //across the middle
            (plays[1] == value && plays[2] == value && plays[3] == value) || //across the top
            (plays[7] == value && plays[4] == value && plays[1] == value) || //down the left side
            (plays[8] == value && plays[5] == value && plays[2] == value) || //down the middle
            (plays[9] == value && plays[6] == value && plays[3] == value) || //down the right side
            (plays[7] == value && plays[5] == value && plays[3] == value) || //diagonal
                (plays[9] == value && plays[5] == value && plays[1] == value)){//diagonal
                    userMessage.hidden = false
                    userMessage.text = "Looks like \(key) won!"
                    resetBtn.hidden = false;
                    done = true;
            }
        }
    }
    
    func reset() {
        plays = [:]
        tictacImg1.image = nil
        tictacImg2.image = nil
        tictacImg3.image = nil
        tictacImg4.image = nil
        tictacImg5.image = nil
        tictacImg6.image = nil
        tictacImg7.image = nil
        tictacImg8.image = nil
        tictacImg9.image = nil
    }
    
    func checkBottom(#value:Int) -> (location:String,pattern:String){
        return ("bottom",checkFor(value, inList: [7,8,9]))
    }
    func checkMiddleAcross(#value:Int) -> (location:String,pattern:String){
        return ("middleHorz",checkFor(value, inList: [4,5,6]))
    }
    func checkTop(#value:Int) -> (location:String,pattern:String){
        return ("top",checkFor(value, inList: [1,2,3]))
    }
    func checkLeft(#value:Int) -> (location:String,pattern:String){
        return ("left",checkFor(value, inList: [1,4,7]))
    }
    func checkMiddleDown(#value:Int) -> (location:String,pattern:String){
        return ("middleVert",checkFor(value, inList: [2,5,8]))
    }
    func checkRight(#value:Int) -> (location:String,pattern:String){
        return ("right",checkFor(value, inList: [3,6,9]))
    }
    func checkDiagLeftRight(#value:Int) -> (location:String,pattern:String){
        return ("diagRightLeft",checkFor(value, inList: [3,5,7]))
    }
    func checkDiagRightLeft(#value:Int) -> (location:String,pattern:String){
        return ("diagLeftRight",checkFor(value, inList: [1,5,9]))
    }
    
    func checkFor(value:Int, inList:Int[]) -> String {
        var conclusion = ""
        for cell in inList {
            if plays[cell] == value {
                conclusion += "1"
            }else{
                conclusion += "0"
            }
        }
        return conclusion
    }
    
    func rowCheck(#value:Int) -> (location:String,pattern:String)?{
        var acceptableFinds = ["011","110","101"]
        var findFuncs = [checkTop,checkBottom,checkLeft,checkRight,checkMiddleAcross,checkMiddleDown,checkDiagLeftRight,checkDiagRightLeft]
        for algorthm in findFuncs {
            var algorthmResults = algorthm(value: value)
            if find(acceptableFinds,algorthmResults.pattern) {
                return algorthmResults
            }
        }
        return nil
    }
    
    func isOccupied(spot:Int) -> Bool {
        println("occupied \(plays)")
        return Bool(plays[spot])
    }
    
    func whereToPlay(location:String,pattern:String) -> Int {
        var leftPattern = "011"
        var rightPattern = "110"
        var middlePattern = "101"
        switch location {
            case "top":
                if pattern == leftPattern {
                    return 1
                }else if pattern == rightPattern{
                    return 3
                }else{
                    return 2
                }
            case "bottom":
                if pattern == leftPattern {
                    return 7
                }else if pattern == rightPattern{
                    return 9
                }else{
                    return 8
                }
            case "left":
                if pattern == leftPattern {
                    return 1
                }else if pattern == rightPattern{
                    return 7
                }else{
                    return 4
                }
            case "right":
                if pattern == leftPattern {
                    return 3
                }else if pattern == rightPattern{
                    return 9
                }else{
                    return 6
                }
            case "middleVert":
                if pattern == leftPattern {
                    return 2
                }else if pattern == rightPattern{
                    return 8
                }else{
                    return 5
                }
            case "middleHorz":
                if pattern == leftPattern {
                    return 4
                }else if pattern == rightPattern{
                    return 6
                }else{
                    return 5
                }
            case "diagLeftRight":
                if pattern == leftPattern {
                    return 1
                }else if pattern == rightPattern{
                    return 9
                }else{
                    return 5
                }
            case "diagRightLeft":
                if pattern == leftPattern {
                    return 3
                }else if pattern == rightPattern{
                    return 7
                }else{
                    return 5
                }
            
            default:
            return 4
        }
    }
    
    func firstAvailable(#isCorner:Bool) -> Int? {
        var spots = isCorner ? [1,3,7,9] : [2,4,6,8]
        for spot in spots {
            println("checking \(spot)")
            if !isOccupied(spot) {
                println("not occupied \(spot)")
                return spot
            }
        }
        return nil
    }
    
    
    
    func aiTurn() {
        if done {
            return
        }
        aiDeciding = true
        //We (the computer) have two in a row
        if let result = rowCheck(value: 0){
            println("comp has two in a row")
            var whereToPlayResult = whereToPlay(result.location, pattern: result.pattern)
            if !isOccupied(whereToPlayResult) {
                println("is not occupied")
                setImageForSpot(whereToPlayResult, player: 0)
                aiDeciding = false
                checkForWin()
                return
            }
        }
        //They (the player) have two in a row
        if let result = rowCheck(value: 1) {
            var whereToPlayResult = whereToPlay(result.location, pattern: result.pattern)
            if !isOccupied(whereToPlayResult) {
                setImageForSpot(whereToPlayResult, player: 0)
                aiDeciding = false
                checkForWin()
                return
            }

        //Is center available?
        }
        if !isOccupied(5) {
            setImageForSpot(5, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if let cornerAvailable = firstAvailable(isCorner: true){
            setImageForSpot(cornerAvailable, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if let sideAvailable = firstAvailable(isCorner: false){
            setImageForSpot(sideAvailable, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        
        userMessage.hidden = false
        userMessage.text = "Looks like it was a tie!"
        
        reset()
        
        println(rowCheck(value: 0))
        //They have two in a row
        println(rowCheck(value: 1))
        

        //do we have two in a row
        
//        1) Win: Ifs you have two in a row, play the third to get three in a row.
//        
//        2) Block: If the opponent has two in a row, play the third to block them.
//        
//        3) Fork: Create an opportunity where you can win in two ways.
//        
//        4) Block Opponent's Fork:
//        
//        Option 1: Create two in a row to force the opponent into defending, as long as it doesn't result in them creating a fork or winning. For example, if "X" has a corner, "O" has the center, and "X" has the opposite corner as well, "O" must not play a corner in order to win. (Playing a corner in this scenario creates a fork for "X" to win.)
//        
//        Option 2: If there is a configuration where the opponent can fork, block that fork.
//        
//        5) Center: Play the center.
//        
//        6) Opposite Corner: If the opponent is in the corner, play the opposite corner.
//        
//        7) Empty Corner: Play an empty corner.
//        
//        8) Empty Side: Play an empty side.
        
        aiDeciding = false
    }
    
    
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        println("Touch begins \(event)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

