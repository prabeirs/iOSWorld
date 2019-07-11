//
//  ViewController.swift
//  Hangman simple version original. Ref https://en.wikipedia.org/wiki/Hangman_(game)
//
//  Created by P sena on 10/07/19.
//  Copyright © 2019 Codage avec Swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var allWords = [String]()
    var usedLetters = [String]()
    var theWord: String = ""
    var coverUpStrArr = [String]()
    var attempt: Int = 0 {
        didSet {
            scoreLbl.text = "\(self.attempt)/\(self.maxAttempts)"
        }
    }
    let maxAttempts = 7

    @IBOutlet var wordGuessLbl: UILabel!
    @IBOutlet var scoreLbl: UILabel!
    @IBOutlet var manLbl: UILabel!
    @IBOutlet var usedLettersLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Hangman"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: #selector(redoTapped))
        
        if wordGuessLbl?.tag == 0 {
            wordGuessLbl.font = UIFont.systemFont(ofSize: 24)
            wordGuessLbl.text = ""
            wordGuessLbl.numberOfLines = 0
            wordGuessLbl.textAlignment = .center
        }
        
        if scoreLbl?.tag == 1 {
            scoreLbl.font = UIFont.systemFont(ofSize: 24)
            scoreLbl.text = "0/\(maxAttempts)"
            scoreLbl.numberOfLines = 3
            scoreLbl.textAlignment = .center
        }
        
        if manLbl?.tag == 2 {
            manLbl.font = UIFont.systemFont(ofSize: 24)
            manLbl.text = "Guess the words in \(maxAttempts) attempts"
            manLbl.textAlignment = .center
        }
        
        if usedLettersLbl?.tag == 3 {
            usedLettersLbl.font = UIFont.systemFont(ofSize: 24)
            //usedLettersLbl.text = "Used letters: "
            usedLettersLbl.numberOfLines = 2
            usedLettersLbl.textAlignment = .left
        }
        
        DispatchQueue.global().async {
            self.loadWords()
            DispatchQueue.main.async {
                self.startGame()
            }
        }
        
    }
    
    func loadWords() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: ".txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
    }
    
    func startGame() {
        //print("no. of elemens \(allWords.count)")
        guard let wordToGuess = allWords.randomElement() else { return }
        print("Word to guess is \(String(describing: wordToGuess))")
        theWord = wordToGuess
        var wordToGuessCoverUp: String = ""
        let coverChar = "?"
        var index = 0
        for char in wordToGuess {
            if index == 0 || index == 1 || index == maxAttempts || index == (maxAttempts + 1)/2 {
                wordToGuessCoverUp += String(char) + " "
                coverUpStrArr.append(String(char))
            } else {
                wordToGuessCoverUp += coverChar + " "
                coverUpStrArr.append(coverChar)
            }
            
            index += 1
        }
        wordGuessLbl.text = wordToGuessCoverUp
        usedLettersLbl.text = "Used letters: "
    }

    @objc func addTapped() {
        let ac = UIAlertController(title: "Press a letter and submit", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: {
            [ weak self, weak ac ] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            
            self?.submit(letter: answer)
        })
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func isUsed(letter: String) -> Bool {
        if usedLetters.isEmpty {
            //attempt += 1
            updateUsed(letter: letter)
            return false
        } else if usedLetters.contains(letter) {
            let ac = UIAlertController(title: "Letter already used once!", message: "try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return true
        } else {
            updateUsed(letter: letter)
            return false
        }
    }
    
    func updateUsed(letter: String) {
        usedLetters.append(letter)
        let usedLettersStr = usedLetters.joined(separator: " ")
        usedLettersLbl.text = "Used: \(usedLettersStr)"
    }
    
    func submit(letter: String) {
        var message = ""

        if isUsed(letter: letter) {
            return
        } else {
            attempt += 1
        }
        
        if isInWord(letter: letter) {
            if replaceCoverUpBy(letter: letter) {
                if isWordFormed() {
                    //print("Game over. You have won!")
                    message = "Game over. You have won!"
                    promptNext(message: message)
                }
                else {
                    if attempt >= maxAttempts {
                        message = "Game over. You lost!"
                        showGameOver(message: message)
                        restartGame()
                        return
                    }
                }
            } else {
                if attempt >= maxAttempts {
                    message = "Game over. You lost!"
                    showGameOver(message: message)
                    restartGame()
                    return
                }
            }
        }
        else {
            if attempt >= maxAttempts {
                message = "Game over. You lost!"
                showGameOver(message: message)
                restartGame()
                return
            }
        }
        
        return
    }
    
    func promptNext(message: String) {
        let ac = UIAlertController(title: message, message: "Would you continue play?", preferredStyle: .alert)
        let promptAction = UIAlertAction(title: "OK", style: .default) {
            [ weak self ] _ in
            self?.restartGame()
        }
        
        ac.addAction(promptAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            [ weak self ] _ in
            self?.navigationItem.rightBarButtonItem?.isEnabled = false
        })
        
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
    
    func showGameOver(message: String) {
        let ac = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func isWordFormed() -> Bool {
        let currentGuessWord = coverUpStrArr.joined(separator: "")
        
        if currentGuessWord == theWord {
            return true
        } else {
            return false
        }
    }
    
    func replaceCoverUpBy(letter: String) -> Bool {
        var replaceDone = 0
        
        for (index, char) in theWord.enumerated() {
            let charStr = String(char)
            
            if letter == charStr {
                coverUpStrArr[index] = charStr
                replaceDone += 1
            }
        }
        
        if (replaceDone > 0) {
            wordGuessLbl.text = coverUpStrArr.joined(separator: " ")
            return true
        } else {
            return false
        }
    }
    
    func isInWord(letter: String) -> Bool {
        if theWord.contains(letter) {
            return true
        } else {
            return false
        }
    }
    
    @objc func redoTapped() {
        attempt = 0
        coverUpStrArr.removeAll()
        usedLetters.removeAll()
        
        if navigationItem.rightBarButtonItem?.isEnabled == false {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
        DispatchQueue.global().async {
            self.loadWords()
            DispatchQueue.main.async {
                self.startGame()
            }
        }
    }
    
    func restartGame() {
        redoTapped()
    }
}

