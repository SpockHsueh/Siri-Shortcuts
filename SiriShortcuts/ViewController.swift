//
//  ViewController.swift
//  SiriShortcuts
//
//  Created by Spoke on 2019/3/3.
//  Copyright © 2019年 Spock. All rights reserved.
//

import UIKit
import IntentsUI

enum TradeType: String {
    case golden = "黃金買賣"
    case stock = "證卷交易"
    case options = "選擇權交易"
}

class ViewController: UIViewController {
    
    let currentDefaults = UserDefaults.standard
    
    @IBOutlet weak var buttonWater: UIButton!
    @IBOutlet weak var buttonCoffee: UIButton!
    @IBOutlet weak var buttonTea: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonWater.setTitle("買黃金 (\(currentCount(for: .golden)))", for: .normal)
        buttonCoffee.setTitle("證卷下單 (\(currentCount(for: .stock)))", for: .normal)
        buttonTea.setTitle("選擇權下單 (\(currentCount(for: .options)))", for: .normal)
    }
    
    @IBAction func addShortcutWasTapped(_ sender: Any) {
        let activityTypeName = "com.spock.SiriShortcuts.drinkCount"
        let activity = NSUserActivity(activityType: activityTypeName)
        activity.suggestedInvocationPhrase = "說一句話代表交易畫面的捷徑"
        let shortcut = INShortcut(userActivity: activity)
        let vc = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func glassOfWaterButtonTapped(_ sender: Any?) {
        increment(for: .golden)
        buttonWater.setTitle("買黃金 (\(currentCount(for: .golden)))", for: .normal)
        self.donateUserActivity(with: .golden)
    }
    
    @IBAction func cupOfCoffeeButtonTapped(_ sender: Any?) {
        increment(for: .stock)
        buttonCoffee.setTitle("證卷下單 (\(currentCount(for: .stock)))", for: .normal)
        self.donateUserActivity(with: .stock)
    }
    
    
    @IBAction func cupOfTeaButtonTapped(_ sender: Any?) {
        increment(for: .options)
        buttonTea.setTitle("選擇權下單 (\(currentCount(for: .options)))", for: .normal)
        self.donateUserActivity(with: .options)
    }
    
    private func increment(for drink: TradeType) {
        let updatedValue = self.currentCount(for: drink) + 1
        currentDefaults.set(updatedValue, forKey: drink.rawValue)
    }
    
    private func currentCount(for drink: TradeType) -> Int {
        return currentDefaults.integer(forKey: drink.rawValue)
    }
    
    // MARK: Public Action
    // Siri shortcuts 導入的接口
    public func selectTradeType(_ trade: TradeType) {
        switch trade {
        case .golden:
            self.glassOfWaterButtonTapped(.none)
        case .stock:
            self.cupOfCoffeeButtonTapped(.none)
        case .options:
            self.cupOfTeaButtonTapped(.none)
        }
    }
}

// MARK: Donate User Activity due to DrinkType
extension ViewController {
    func donateUserActivity(with type: TradeType) {
        let activityTypeName = "com.spock.SiriShortcuts.drinkCount"
        let activity = NSUserActivity(activityType: activityTypeName)
        activity.title = "交易畫面進行 \(type.rawValue)"
        activity.userInfo = ["TradeType": type.rawValue]
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.suggestedInvocationPhrase = "說一句話代表 \(type.rawValue) 的捷徑"
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

