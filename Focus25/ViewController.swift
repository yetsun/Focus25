//
//  ViewController.swift
//  Focus25
//
//  Created by Jun Ye on 4/29/18.
//  Copyright © 2018 Jun Ye. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var minuteLabel: NSTextField!
    @IBOutlet weak var secondLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    var timer: Timer?
    
    var focus: Focus!
    var focusEndedAlert: FocusEndedAlert!
    var rest: Rest!
    var restEndedAlert: RestEndedAlert!
    
    var cycle: Cycle!
    
    
    @IBAction func focusButtonCliced(_ sender: Any) {
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.tick)), userInfo: nil, repeats: true)
        }else{
            cycle.buttonClicked()
        }
        
        
        
    }
    
    @objc func tick(){
        cycle.tick()
    }
    
    func setCycle(cycle: Cycle){
        cycle.reset()
        self.cycle = cycle
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        focus = Focus(viewController: self)
        focusEndedAlert = FocusEndedAlert(viewController: self)
        rest = Rest(viewController: self)
        restEndedAlert = RestEndedAlert(viewController: self)
        
        cycle = focus
    }
    
}


protocol Cycle {
    func tick()
    func buttonClicked()
    func getCycleLength() -> Int
    func getCount() -> Int
    func countDown()
    func reset()
    
    init(viewController: ViewController)
    
}


extension Cycle {
    func calculateMiunteSecond(seconds: Int) -> (minutes: String, seconds: String) {
        let iMinutes = seconds / 60
        let iSeconds = seconds % 60
        return (String(format: "%02d", iMinutes), String(format: "%02d", iSeconds))
    }
}


class FocusEndedAlert: Cycle {
    
    var count: Int
    
    var viewController: ViewController!
    
    let cycleLength = 3
    
    required init(viewController: ViewController){
        self.viewController = viewController
        count = cycleLength
    }
    
    func reset() {
        count = self.getCycleLength()
    }
    
    func getCycleLength() -> Int {
        return cycleLength
    }
    
    
    func getCount() -> Int {
        return count
    }
    
    func countDown() {
        count -= 1
    }
    
    func tick() {
        if getCount() > 0 {
            countDown()
            //TODO make a sound
            print("Focus ended")
        }else{
            //viewController.setState(Rest)
            viewController.setCycle(cycle: viewController.rest)
        }
    }
    
    func buttonClicked() {
        count = 0
    }
}


class RestEndedAlert: Cycle {
    
    var count: Int
    
    var viewController: ViewController!
    
    let cycleLength = 3
    
    func reset() {
        count = self.getCycleLength()
    }
    
    func getCycleLength() -> Int {
        return cycleLength
    }
    
    required init(viewController: ViewController){
        self.viewController = viewController
        count = cycleLength
    }
    
    func getCount() -> Int {
        return count
    }
    
    func countDown() {
        count -= 1
    }
    
    func tick(){
        if getCount() > 0 {
            countDown()
            //TODO make a sound
            print("Rest ended")
        }else{
            viewController.setCycle(cycle: viewController.focus)
        }
    }
    
    func buttonClicked() {
        count = 0
    }
    
}


class Focus: Cycle {
    
    var paused: Bool
    
    var count: Int
    
    var viewController: ViewController!
    
    let cycleLength = 25 * 60
    
    required init(viewController: ViewController){
        self.viewController = viewController
        paused = false
        count = cycleLength
    }
    
    func reset() {
        count = self.getCycleLength()
    }
    
    func getCycleLength() -> Int {
        return cycleLength
    }
    
    
    func getCount() -> Int {
        return count
    }
    
    func countDown() {
        count -= 1
    }
    
    func tick() {
        if !paused {
            if getCount() > 0 {
                countDown()
                let (strMinutes, strSeconds) = calculateMiunteSecond(seconds: getCount())
                
                viewController.minuteLabel.stringValue = strMinutes
                viewController.secondLabel.stringValue = strSeconds
            }else{
                viewController.setCycle(cycle: viewController.focusEndedAlert)
            }
        }
    }
    
    func buttonClicked() {
        paused = !paused
    }
    
}


class Rest: Cycle {
    
    var count: Int
    
    var viewController: ViewController!
    
    var cycleLength = 5 * 60
    
    required init(viewController: ViewController){
        self.viewController = viewController
        count = cycleLength
    }
    
    func reset() {
        count = self.getCycleLength()
    }
    
    func getCycleLength() -> Int {
        return cycleLength
    }
    
    func getCount() -> Int {
        return count
    }
    
    func countDown() {
        count -= 1
    }
    
    func tick() {
        
        if getCount() > 0 {
            countDown()
            let (strMinutes, strSeconds) = calculateMiunteSecond(seconds: getCount())
            
            viewController.minuteLabel.stringValue = strMinutes
            viewController.secondLabel.stringValue = strSeconds
        }else{
            viewController.setCycle(cycle: viewController.restEndedAlert)
        }
        
    }
    
    func buttonClicked() {}
    
}





