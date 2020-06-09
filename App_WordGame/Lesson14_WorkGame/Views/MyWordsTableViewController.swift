//
//  MyWordsTableViewController.swift
//  Lesson14_WorkGame
//
//  Created by MacBook Air on 30.01.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit
import RealmSwift

class MyWordsTableViewController: UITableViewController {
	
	let myWordsTableViewModel = MyWordsTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myWordsTableViewModel.wordsNotSorted.count
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "wordsCell")
		cell?.textLabel?.text = myWordsTableViewModel.wordsNotSorted[indexPath.row].word
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		
		let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, action) in
			self.myWordsTableViewModel.removeWordFromDataBase(atIndex: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .middle)
			tableView.reloadData()
		}
		
		return UISwipeActionsConfiguration(actions: [deleteAction])
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Доступные для игры слова"
	}
	
	@IBAction func backButtonAction(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
	
}

