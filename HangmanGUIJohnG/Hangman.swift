//
//  Hangman.swift
//  HangmanGUIJohnG
//
//  Created by John Grasser on 10/14/20.
//  Copyright © 2020 John Grasser. All rights reserved.
//

import UIKit
import Foundation

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}

extension BidirectionalCollection {
    subscript(safe offset: Int) -> Element? {
        guard !isEmpty, let i = index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
        return self[i]
    }
}

class Hangman: UIViewController,UITextFieldDelegate{

   var wordsToGuess: [String] = ["STEAK","CHICKEN","BEEF","BROCCOLI","PIZZA","SPAGHETTI","MOSTACCIOLI","TACOS", "CARROTS", "CELERY","APPLE","BANANA","LASAGNA","CAKE","PIE","CAULIFLOWER","FAJITAS","WINGS","CRABS","LOBSTER","CASSEROLE", "SOUP","FRIES","SALAD","PINEAPPLE","OMELET","EGGS","PANCAKES", "WAFFLES","BEANS","OATMEAL","MANGOS","SALMON","TUNA","NUTS","SEEDS","YOGURT","POTATOES"]
    
    var wordSelection:Int!
    var playerWord:String!
    var playerGuessWord:[String]! = []
    var usedLetterArra:String! = " "
    let chancesToLose = 7
    var chances = 0
    var letterFound = false
    
    //var playerGuessWord:String!
    var Hi:String! = "hi"
    var playerGuessWordLength = 0

    var hintUsed = false
    
    @IBOutlet var imgHangManPerson: UIImageView!
    
    @IBOutlet var txtGuessName: UITextField!
    
    @IBOutlet var txtUsedName: UITextField!
    
    @IBOutlet var txtEnterLetter: UITextField!
    
    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet var btnHint: UIButton!
        
    let allowedCharacters = CharacterSet.letters.union(CharacterSet(charactersIn: " "))
    let maxLength = 1
    
    
    
    @IBAction func resetGame(_ sender: Any) {
        imgHangManPerson.image = nil
        chances = 0
        usedLetterArra = " "
        playerGuessWord = []
        playerGuessWordLength = 0
        playerWord = ""
        txtUsedName.text = ""
        btnHint.isUserInteractionEnabled = true
        btnHint.setTitle("Hint", for: .normal)
        btnSubmit.isUserInteractionEnabled = true
        randomWord()
        txtEnterLetter.isUserInteractionEnabled = true
    }
    
    
    
    @IBAction func submitLetter(_ sender: UIButton)
    {
        
        let letterGuess = txtEnterLetter.text?.uppercased()
        while(letterGuess == "" || letterGuess == " ")
        {
            let alert = UIAlertController(title: "Try Again", message: "The word cannot have spaces", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in})
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            txtEnterLetter.text = ""
            return
            //t
        }
        
            compareLetterWord(letterGuess: letterGuess!)
        
        
    }
    
    
    
    
    @IBAction func hintFunction(_ sender: UIButton) {
        //hintUsed = true
        var j = 0
        
        btnHint.isUserInteractionEnabled = false
        btnHint.setTitle("Used", for: .normal)
       // var wordToGuessLetter = Array(playerWord)//Array(playerWord)
       // var playerGuessArray = Array(playerGuessWord)
        var playerUsedLet = Array(usedLetterArra)
        var index2:String

        //var playerRandomLet = playerGuessArray[0]
        var k = 0
        
        while(j == 0)
        {
            let randomLetter = Int.random(in: 0 ... (playerGuessWord.count - 1))
            
            
            if playerGuessWord[randomLetter] == "-"
            {
                j = 1
                
                //index2 = playerWord[randomLetter]//playerWord.index(playerWord.startIndex, offsetBy: randomLetter)
                
                
                txtEnterLetter.text = String(playerWord[randomLetter])
                index2 = txtEnterLetter.text!
                let index3 = Array(index2)
                
                
                playerGuessWord.replaceSubrange(randomLetter...randomLetter, with: [index2])

                playerUsedLet.append(contentsOf: index3)
                usedLetterArra = String(playerUsedLet)
                j = 1
                //usedLetterArra?.append()
                break
            }
            
        }
        
        while k < (playerWord.count - 1)
        {
            index2 = txtEnterLetter.text!
            if playerWord[k] == index2[0]
            {
               
                playerGuessWord.replaceSubrange(k...k, with: [index2])
            }
            k = k + 1
        }
        
         let playerGuessString = playerGuessWord?.joined()
         txtGuessName.text = playerGuessString
         txtUsedName.text = usedLetterArra
        txtEnterLetter.text = ""
        winState()
    }
    
    func winState()
    {
        var winState = true
        let playerGuessArray = Array(playerGuessWord)
        for count in 0...(playerWord.count - 1)
        {
            if (playerGuessArray[count] == "-")
            {
                winState = false
                break
                
            }
            
        }
        
        if(winState == true)
        {
            //txtGuessName.text = "You Win"
            winner()
            txtEnterLetter.isUserInteractionEnabled = false
            btnHint.isUserInteractionEnabled = false
            btnSubmit.isUserInteractionEnabled = false
            
        }
        
    }
    
    func loseState(letterFound2:Bool)
    {
        if letterFound == false && letterFound2 == false
        {
            chances = chances + 1
            print(chances)
            
        }
        
        switch(chances)
        {
        case 1:
            let yourImage: UIImage = UIImage(named: "hangmana")!
            imgHangManPerson.image = yourImage
            //break
        case 2:
             let yourImage: UIImage = UIImage(named: "hangmanb")!
            imgHangManPerson.image = yourImage
            //break
        case 3:
            let yourImage: UIImage = UIImage(named: "hangmanc")!
            imgHangManPerson.image = yourImage
            //break
        case 4:
            let yourImage: UIImage = UIImage(named: "hangmand")!
            imgHangManPerson.image = yourImage
           // break
        case 5:
             let yourImage: UIImage = UIImage(named: "hangmane")!
            imgHangManPerson.image = yourImage
           // break
        case 6:
            let yourImage: UIImage = UIImage(named: "hangmanf")!
            imgHangManPerson.image = yourImage
          //  break
        case 7:
            let yourImage: UIImage = UIImage(named: "hangmanf")!
            imgHangManPerson.image = yourImage
          //  break
        default:
            imgHangManPerson.image = nil
           // break
        }
        
        if chances == chancesToLose
        {
            //txtGuessName.text = "You Lost"
            loser()
            txtEnterLetter.isUserInteractionEnabled = false
            btnHint.isUserInteractionEnabled = false
            btnSubmit.isUserInteractionEnabled = false
            
        }
        
    }
    

    
    func winner()
    {
        
        let alert = UIAlertController(title: "You Win", message: "The word is \(playerWord!)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in})
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func loser()
    {
        
        let alert = UIAlertController(title: "You Lost", message: "The word is \(playerWord!)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in})
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
     func guessAgain()
    {
        
        let alert = UIAlertController(title: "Try Again", message: "You Have Already Chosen This Letter. Please Choose Again!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in})
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func compareLetterWord(letterGuess:String)
    {
        var i = 0
        var j = 0
        
        letterFound = false
        var letterFound2 = false
        //var playersChose = wordToGuessArray[0]
        let wordToGuessLetter = Array(letterGuess)
        var usedLet = Array(usedLetterArra)
        let playerGuessArray = Array(playerWord)
        while(i <= (playerWord.count - 1))
        {
            if wordToGuessLetter[0] == playerGuessArray[i]
            {
                playerGuessWord.replaceSubrange(i...i, with: [letterGuess])
                letterFound = true
            }
        
            i = i + 1
        }
        let playerGuessString = playerGuessWord?.joined()
        txtGuessName.text = playerGuessString
        
        
        while(j <= (usedLet.count - 1))
        {
            if letterFound2 == false
            {
                print("Letter Guess is \(wordToGuessLetter[0])")
                if usedLet[j] == wordToGuessLetter[0]
                {
                    letterFound2 = true
                    
                }
            }
            j = j+1
        }
        

        txtEnterLetter.text = ""
       
        if letterFound2 == false
        {
             usedLet.append(wordToGuessLetter[0])
            usedLetterArra = String(usedLet)
        }
        else{
            
            guessAgain()
        }
        print(usedLet)
        txtUsedName!.text = usedLetterArra
        winState()
        loseState(letterFound2:letterFound2)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUsedName.isUserInteractionEnabled = false
        txtGuessName.isUserInteractionEnabled = false
        txtEnterLetter.delegate = self
        //txtEnterLetter.keyboardType = UIKeyboardType.asciiCapable       //txtGuessName.delegate = true as! UITextFieldDelegate
        //txtUsedName.delegate = self
        // Do any additional setup after loading the view.
        randomWord()
        
    }
    

    func randomWord()
    {
        wordSelection = Int.random(in:0...wordsToGuess.count - 1)
        playerWord = wordsToGuess[wordSelection]
        //txtGuessName.text(playerWord)
        //txtUsedName.text = playerWord
        fillWord()
    }
    
    func fillWord()
    {
        //for count in 0...(playerWord.count - 1){
        for _ in 0...(playerWord.count - 1){
            playerGuessWord?.append("-")
            
        }
        
        let playerGuessString = playerGuessWord?.joined()
        txtGuessName.text = playerGuessString!
        //txtUsedName.text = playerWord
       
    }
    
    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return (newText.rangeOfCharacter(from: allowedCharacters.inverted) == nil) && (newText.count <= maxLength)
    }
   

}
