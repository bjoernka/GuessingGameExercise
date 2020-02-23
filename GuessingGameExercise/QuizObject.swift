//
//  QuizObject.swift
//  GuessingGameExercise
//
//  Created by Björn Kaczmarek on 21/2/20.
//  Copyright © 2020 Björn Kaczmarek. All rights reserved.
//

import Foundation

public struct QuizObject {
    
    var correctAnswerIndex: Double = 0
    var imageUrl: String = ""
    var storyURL: String = ""
    var standFirst: String = ""
    var section: String = ""
    var headlines: [String] = []
    
    init(correctAnswerIndex: Double, imageUrl: String, storyURL: String, standFirst: String, section: String, headlines: [String]) {
        self.correctAnswerIndex = correctAnswerIndex
        self.imageUrl = imageUrl
        self.storyURL = storyURL
        self.standFirst = standFirst
        self.section = section
        self.headlines = headlines
    }
}
