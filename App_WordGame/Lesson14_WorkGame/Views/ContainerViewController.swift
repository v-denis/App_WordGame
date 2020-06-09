//
//  ContainerViewController.swift
//  Lesson11_WorkGame
//
//  Created by MacBook Air on 23.01.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, StartViewControllerDelegate {
	
	//Создаем два контроллера
	var mainController: UIViewController!
	var menuControllert: UIViewController!
	var isMove: Bool = true
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configMainVC()
		let leftGestureSwipe = UISwipeGestureRecognizer(target: self.mainController, action: #selector(swipeMenu))
		leftGestureSwipe.direction = .left
		view.addGestureRecognizer(leftGestureSwipe)
    }
	
	//Инициализируем контроллер mainController
	func configMainVC() {
		let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! StartViewController
		mainVC.delegate = self
		mainController = mainVC
		view.addSubview(mainController.view)
//		self.addChild(mainController)
	}
	
	//Инициализируем контроллер menuController
	func configMenuVC() {
		if menuControllert == nil {
			let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MenuVC") as! MenuViewController
			menuControllert = menuVC
			view.insertSubview(menuControllert.view, at: 0)
//			self.addChild(menuControllert)
		}
	}
	
	func showMenuVC(shouldMove: Bool) {
		if shouldMove == true {
			UIView.animate(
				withDuration: 0.65,
				delay: 0,
				usingSpringWithDamping: 1,
				initialSpringVelocity: 1,
				options: .curveEaseInOut,
				animations: {
			self.mainController.view.frame.origin.x = 300
			}) { (finished) in
			}
		} else {
			UIView.animate(
				withDuration: 0.65,
				delay: 0,
				usingSpringWithDamping: 1,
				initialSpringVelocity: 1,
				options: .curveEaseInOut,
				animations: {
			self.mainController.view.frame.origin.x = 0
			}) { (finished) in
			}
		}
	}
	
	func toggleMenu() {
		configMenuVC()
		showMenuVC(shouldMove: isMove)
		isMove = !isMove
	}
    
	@objc func swipeMenu() {
		print("Containter gesture!")
//		configMenuVC()
//		showMenuVC(shouldMove: isMove)
//		isMove = !isMove
	}


}
