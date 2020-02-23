//
//  QuizViewController.swift
//  GuessingGameExercise
//
//  Created by Björn Kaczmarek on 21/2/20.
//  Copyright © 2020 Björn Kaczmarek. All rights reserved.
//

import UIKit
import WebKit

class QuizViewController: UIViewController {

    var allQuizObjects: [QuizObject] = []
    var currentLevel = 0
    var currentScore: Double = 0
    var alphaValue: CGFloat = 0.6
    var cornerRadius: CGFloat = 10
    
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var standFirst: UILabel!
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var readArticle: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var endGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpView()
    }
    
    func setUpView() {
        totalScore.text = "Current Score: " + String(format: "%g", currentScore)
        quizImage.downloaded(from: allQuizObjects[currentLevel].imageUrl)
        standFirst.layer.cornerRadius = cornerRadius
        standFirst.text = allQuizObjects[currentLevel].standFirst
        standFirst.isHidden = true
        standFirst.alpha = alphaValue
        
        answer1.alpha = alphaValue
        answer1.layer.cornerRadius = cornerRadius
        answer1.setTitle(allQuizObjects[currentLevel].headlines[0], for: .normal)
        answer1.tag = 0
        answer1.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
        
        answer2.layer.cornerRadius = cornerRadius
        answer2.setTitle(allQuizObjects[currentLevel].headlines[1], for: .normal)
        answer2.alpha = alphaValue
        answer2.tag = 1
        answer2.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
        
        answer3.layer.cornerRadius = cornerRadius
        answer3.setTitle(allQuizObjects[currentLevel].headlines[2], for: .normal)
        answer3.alpha = alphaValue
        answer3.tag = 2
        answer3.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
        
        readArticle.alpha = alphaValue
        readArticle.setTitle("Read Article", for: .normal)
        readArticle.addTarget(self, action: #selector(readArticlePressed), for: .touchUpInside)
        
        skipButton.alpha = alphaValue
        skipButton.setTitle("Skip", for: .normal)
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        
        endGameButton.layer.cornerRadius = cornerRadius
        endGameButton.setTitle("End Game", for: .normal)
        endGameButton.alpha = alphaValue
        endGameButton.setTitle("End Game", for: .normal)
        endGameButton.addTarget(self, action: #selector(endButtonPressed), for: .touchUpInside)
    }
    
    @objc func readArticlePressed(sender: UIButton!) {
        // open article to image
        let articleWebView = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ArticleVC") as? ArticleViewController
        articleWebView?.webViewURL = allQuizObjects[currentLevel].storyURL
        self.navigationController?.present(articleWebView!, animated: true, completion: nil)
    }
    
    @objc func skipButtonPressed(sender: UIButton!) {
        showNextViewController()
    }
    
    @objc func endButtonPressed(sender: UIButton!) {
        // go to result view
        let resultViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResultVC") as? ResultViewController
        resultViewController?.currentScore = currentScore
        self.navigationController?.pushViewController(resultViewController!, animated: true)
    }
    
    @objc func checkAnswer(sender: UIButton!) {
        // check if chosen button is correct
        answer1.isUserInteractionEnabled = false
        answer2.isUserInteractionEnabled = false
        answer3.isUserInteractionEnabled = false
        let chosenAnswer = Double(sender.tag)
        let rightAnswer = allQuizObjects[currentLevel].correctAnswerIndex
        if chosenAnswer == rightAnswer {
            currentScore += 2
            sender.backgroundColor = .green
            standFirst.isHidden = false
            skipButton.setTitle("Next", for: .normal)
        } else {
            currentScore -= 1
            sender.backgroundColor = .red
            standFirst.isHidden = false
            skipButton.setTitle("Next", for: .normal)
        }
    }
    
    func showNextViewController() {
        
        currentLevel += 1
        
        // if it was the last level show result, otherwise go to next question
        if currentLevel < allQuizObjects.count {
            let quizViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "QuizVC") as? QuizViewController
            quizViewController?.allQuizObjects = allQuizObjects
            quizViewController?.currentLevel = currentLevel
            quizViewController?.currentScore = currentScore
            self.navigationController?.pushViewController(quizViewController!, animated: true)
        } else {
            let resultViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResultVC") as? ResultViewController
            resultViewController?.currentScore = currentScore
            self.navigationController?.pushViewController(resultViewController!, animated: true)
        }
    }
}

extension UIImageView {
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
}
