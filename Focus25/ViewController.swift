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

    var total = 25 * 60
    var timer = Timer()
    
    @IBAction func focusButtonCliced(_ sender: Any) {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.tick)), userInfo: nil, repeats: true)
        
      
        
    }
    
    @objc func tick(){
        
        if total > 0 {
            total -= 1
           
            let (strMinutes, strSeconds) = calculateMiunteSecond(seconds: total)
            
            minuteLabel.stringValue = strMinutes
            secondLabel.stringValue = strSeconds
            
        }else{
            timer.invalidate()
        }
        
    }
    
    func calculateMiunteSecond(seconds: Int) -> (minutes: String, seconds: String) {
        let iMinutes = total / 60
        let iSeconds = total % 60

        /*
        print(total)
        print(iMinutes)
        print(iSeconds)
        
        print("---------------")
        */
        
        return (String(format: "%02d", iMinutes), String(format: "%02d", iSeconds))
    }
    
}

