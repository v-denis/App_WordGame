//
//  GameViewModel.swift
//  Lesson14_WorkGame
//
//  Created by MacBook Air on 19.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation


class GameViewModel {
	
	let dataManager = DataManager()
	
	let currentMaxScore = realm.objects(MaxScore.self)
		
	func getCurrentMaxScore() -> Int {
		let currentMaxScore = dataManager.getCurrentMaxScore()
		return currentMaxScore ?? 0
	}
}
