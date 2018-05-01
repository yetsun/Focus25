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
        
        focus = Focus(viewController: self, cycleLength: 25 * 60)
        focusEndedAlert = FocusEndedAlert(viewController: self, cycleLength: 3)
        rest = Rest(viewController: self, cycleLength: 5 * 60)
        restEndedAlert = RestEndedAlert(viewController: self, cycleLength: 3)
        
        cycle = focus
    }
    
}


class Cycle {
    var paused: Bool
    var count: Int
    var viewController: ViewController!
    var cycleLength: Int
    
    init(viewController: ViewController, cycleLength: Int){
        self.viewController = viewController
        self.cycleLength = cycleLength
        
        self.paused = false
        self.count = cycleLength
    }
    
    func reset() {
        paused = false
        count = cycleLength
    }
    
    func countDown() {
        count -= 1
    }
    
    func calculateMiunteSecond(seconds: Int) -> (minutes: String, seconds: String) {
        let iMinutes = seconds / 60
        let iSeconds = seconds % 60
        return (String(format: "%02d", iMinutes), String(format: "%02d", iSeconds))
    }
    
    func tick(){}
    func buttonClicked() {}
}


class FocusEndedAlert: Cycle {
    override func tick() {
        if count > 0 {
            countDown()
            //TODO make a sound
            print("Focus ended")
        }else{
            //viewController.setState(Rest)
            viewController.setCycle(cycle: viewController.rest)
        }
    }
    
    override func buttonClicked() {
        count = 0
    }
}


class RestEndedAlert: Cycle {
    override func tick(){
        if count > 0 {
            countDown()
            //TODO make a sound
            print("Rest ended")
        }else{
            viewController.setCycle(cycle: viewController.focus)
        }
    }
    
    override func buttonClicked() {
        count = 0
    }
    
}


class Focus: Cycle {
    override func tick() {
        if !paused {
            if count > 0 {
                countDown()
                let (strMinutes, strSeconds) = calculateMiunteSecond(seconds: count)
                
                viewController.minuteLabel.stringValue = strMinutes
                viewController.secondLabel.stringValue = strSeconds
            }else{
                viewController.setCycle(cycle: viewController.focusEndedAlert)
            }
        }
    }
    
    override func buttonClicked() {
        paused = !paused
    }
    
}

class Rest: Cycle {
    override func tick() {
        
        if count > 0 {
            countDown()
            let (strMinutes, strSeconds) = calculateMiunteSecond(seconds: count)
            
            viewController.minuteLabel.stringValue = strMinutes
            viewController.secondLabel.stringValue = strSeconds
        }else{
            viewController.setCycle(cycle: viewController.restEndedAlert)
        }
        
    }
    
    override func buttonClicked() {}
}
