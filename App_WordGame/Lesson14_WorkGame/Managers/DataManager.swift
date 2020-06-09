//
//  DataManager.swift
//  Lesson14_WorkGame
//
//  Created by MacBook Air on 30.01.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class DataManager {
	
	func getCurrentMaxScore() -> Int? {
		let currentMaxScore = realm.objects(MaxScore.self).first?.maxScore
		return currentMaxScore
	}
	
	func addObjectToDataBase(_ object: Object) {
		try! realm.write {
			realm.add(object)
		}
	}
	
	func removeFromDataBase(object: Object) {
		try! realm.write {
			realm.delete(object)
		}
	}
	
	func rewriteToDataBase(objectAdd: Object, objectDelete: Object) {
		try! realm.write {
			realm.add(objectAdd)
			realm.delete(objectDelete)
		}
	}
	
	func deleteAllAndWriteToDB(objectAdd: Object) {
		try! realm.write {
			realm.deleteAll()
			realm.add(objectAdd)
		}
	}
	
	func checkEmptyInWordsDB() -> Bool {
		return realm.objects(Word.self).isEmpty
	}
	
	func checkMaxScoreEmpty() -> Bool {
		return realm.objects(MaxScore.self).isEmpty
	}
	
	
}
