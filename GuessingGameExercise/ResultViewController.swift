//
//  ResultViewController.swift
//  GuessingGameExercise
//
//  Created by Björn Kaczmarek on 23/2/20.
//  Copyright © 2020 Björn Kaczmarek. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    var currentScore: Double = 0
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    func setUpView() {
        
        totalScoreLabel.text = "Total Score: " + String(format: "%g", currentScore)
        
        playAgainButton.layer.cornerRadius = 10
        playAgainButton.setTitle("Play again", for: .normal)
        playAgainButton.alpha = 0.6
    }
    
    @IBAction func playAgainPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
