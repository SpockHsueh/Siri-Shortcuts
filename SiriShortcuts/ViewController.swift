//
//  ViewController.swift
//  SiriShortcuts
//
//  Created by Spoke on 2019/3/3.
//  Copyright © 2019年 Spock. All rights reserved.
//

import UIKit
import IntentsUI

enum DrinkType: String {
    case water
    case coffee
    case tea
}

class ViewController: UIViewController {
    
    let currentDefaults = UserDefaults.standard
    
    @IBOutlet weak var buttonWater: UIButton!
    @IBOutlet weak var buttonCoffee: UIButton!
    @IBOutlet weak var buttonTea: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonWater.setTitle("Glass of Water (\(currentCount(for: .water)))", for: .normal)
        buttonCoffee.setTitle("Cup of Coffee (\(currentCount(for: .coffee)))", for: .normal)
        buttonTea.setTitle("Cup of Tea (\(currentCount(for: .tea)))", for: .normal)
    }
    
    @IBAction func addShortcutWasTapped(_ sender: Any) {
        let activityTypeName = "com.spock.SiriShortcuts.drinkCount"
        let activity = NSUserActivity(activityType: activityTypeName)
        
        let shortcut = INShortcut(userActivity: activity)
        let vc = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func glassOfWaterButtonTapped(_ sender: Any?) {
        increment(for: .water)
        buttonWater.setTitle("Glass of Water (\(currentCount(for: .water)))", for: .normal)
        self.donateUserActivity(with: .water)
    }
    
    @IBAction func cupOfCoffeeButtonTapped(_ sender: Any?) {
        increment(for: .coffee)
        buttonCoffee.setTitle("Cup of Coffee (\(currentCount(for: .coffee)))", for: .normal)
        self.donateUserActivity(with: .coffee)
    }
    
    
    @IBAction func cupOfTeaButtonTapped(_ sender: Any?) {
        increment(for: .tea)
        buttonTea.setTitle("Cup of Tea (\(currentCount(for: .tea)))", for: .normal)
        self.donateUserActivity(with: .tea)
    }
    
    private func increment(for drink: DrinkType) {
        let updatedValue = self.currentCount(for: drink) + 1
        currentDefaults.set(updatedValue, forKey: drink.rawValue)
    }
    
    private func currentCount(for drink: DrinkType) -> Int {
        return currentDefaults.integer(forKey: drink.rawValue)
    }
    
    // MARK: Public Action
    public func didDrank(_ drank: DrinkType) {
        switch drank {
        case .water:
            self.glassOfWaterButtonTapped(.none)
        case .coffee:
            self.cupOfCoffeeButtonTapped(.none)
        case .tea:
            self.cupOfTeaButtonTapped(.none)
        }
    }
}

// MARK: Donate User Activity due to DrinkType
extension ViewController {
    func donateUserActivity(with type: DrinkType) {
        let activityTypeName = "com.spock.SiriShortcuts.drinkCount"
        let activity = NSUserActivity(activityType: activityTypeName)
        activity.title = "I just drank \(type.rawValue)"
        activity.userInfo = ["drinkType": type.rawValue]
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.suggestedInvocationPhrase = "Drank \(type.rawValue)"
        view.userActivity = activity
        activity.becomeCurrent()
    }
}

extension ViewController:INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

