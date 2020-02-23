//
//  ViewController.swift
//  GuessingGameExercise
//
//  Created by Björn Kaczmarek on 21/2/20.
//  Copyright © 2020 Björn Kaczmarek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var allQuizObjects : [QuizObject] = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarTransparent()
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        setupView()
        
        downloadJSON()
    }
    
    func setupView() {
        startButton.layer.cornerRadius = 10
        startButton.setTitle("Start", for: .normal)
        startButton.alpha = 0.6
    }
    
    // Make navigationbar transparent
    func navigationBarTransparent() {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    func downloadJSON() {
        
        allQuizObjects = []
        let urlString = "https://firebasestorage.googleapis.com/v0/b/nca-dna-apps-dev.appspot.com/o/game.json?alt=media&token=e36c1a14-25d9-4467-8383-a53f57ba6bfe"
        
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let dictionary = json as? [String: Any] {
                            if let items = dictionary["items"] as? [[String: Any]] {
                                for item in items {
                                    let quizObject = QuizObject(correctAnswerIndex: item["correctAnswerIndex"] as! Double,
                                                                imageUrl: item["imageUrl"] as! String,
                                                                storyURL: item["storyUrl"] as! String,
                                                                standFirst: item["standFirst"] as! String,
                                                                section: item["section"] as! String,
                                                                headlines: item["headlines"] as! [String])
                                    self.allQuizObjects.append(quizObject)
                                }
                            }
                        }
                        DispatchQueue.main.async() {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                    } catch {
                    }
                }
            }
            task.resume()
        }
        return
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        
        // if download was succesful go to quizVC, otherwise show error alert
        if allQuizObjects.count > 0 {
            let quizViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "QuizVC") as? QuizViewController
            quizViewController?.allQuizObjects = allQuizObjects
            quizViewController?.currentLevel = 0
            quizViewController?.currentScore = 0
            self.navigationController?.pushViewController(quizViewController!, animated: true)
        } else {
            let alert = UIAlertController(title: "Download failed", message: "Download of the quiz content failed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction) in
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }))
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (alert: UIAlertAction) in
                self.downloadJSON()
            }))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
        
    }
}

