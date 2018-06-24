//
//  ViewController.swift
//  timer90
//
//  Created by Yogesh Patel on 20/12/17.
//  Copyright © 2017 Yogesh Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var playbutton: UIButton!
    
    @IBOutlet var pausebutton: UIButton!
    
    @IBOutlet var titlelabel: UILabel!
    
    @IBOutlet var fpsNum: UITextField!
    
    @IBOutlet var exposureTimeNum: UITextField!
    
    var timer = Timer()
    var counter = 0.00
    var isRunning = false
    var previousFPS:Double = 20
    var previousExposureTime:Double = 50
    //var fps = 30.0
    //var fps = fpsNum

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //titlelabel.text = "\(counter)"
        titlelabel.text = "0.00"
        playbutton.isEnabled = true
        pausebutton.isEnabled = false
        
        //--- add UIToolBar on keyboard and Done button on UIToolBar ---//
        self.addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ViewController.doneButtonAction))

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.fpsNum.inputAccessoryView = doneToolbar
        self.exposureTimeNum.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        validateAndCalculate()
    }
    
    
    @IBAction func keyboardDone(_ sender: UITextField) {
        validateAndCalculate()
    }
    
    func validateAndCalculate() {
        if(!validateFPS())
        {
            fpsNum.text = "0"
        }
        if(fpsNum.text == "")
        {
            fpsNum.text = "0"
        }
        if(!validateExposureTime())
        {
            exposureTimeNum.text = "0"
        }
        if(exposureTimeNum.text == "")
        {
            exposureTimeNum.text = "0"
        }
        guard let text = fpsNum.text else {
            return
        }
        if let fps = Double(text)
        {
            if (fps != previousFPS)
            {
                var exposureTime:Double
                //calculate the new exposure time number
                if(fps == 0)
                {
                    exposureTime = 0
                }
                else
                {
                    exposureTime = round((1/fps)*1000)
                }
                exposureTimeNum.text = String(exposureTime)
                previousExposureTime = exposureTime
                previousFPS = fps
            }
        }
        guard let exposureTimeNumText = exposureTimeNum.text else {
            return
        }
        if let exposureTime = Double(exposureTimeNumText)
        {
            if (exposureTime != previousExposureTime)
            {
                var fps:Double
                //calculate the new fps number
                if(exposureTime == 0)
                {
                    fps = 0
                }
                else
                {
                    fps = round(1000/exposureTime)
                }
                fpsNum.text = String(fps)
                previousFPS = fps
                previousExposureTime = exposureTime
            }
        }
        self.fpsNum.resignFirstResponder()
        self.exposureTimeNum.resignFirstResponder()
    }
    
    func validateFPS() -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = fpsNum.text?.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet?.joined(separator: "")
        return fpsNum.text == numberFiltered
    }
    
    func validateExposureTime() -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = exposureTimeNum.text?.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet?.joined(separator: "")
        return exposureTimeNum.text == numberFiltered
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let s = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        guard !s.isEmpty else { return true }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        return numberFormatter.number(from: s)?.intValue != nil
    }

    
    @IBAction func btnreset(_ sender: UIButton) {
        timer.invalidate()
        counter = 0
        titlelabel.text = "0.00"
        playbutton.isEnabled = true
        pausebutton.isEnabled = false
        isRunning = false
    }
    
    @IBAction func btnpause(_ sender: UIButton) {
        timer.invalidate()
        pausebutton.isEnabled = false
        playbutton.isEnabled = true
        isRunning = false
    }
    
   
    @IBAction func btnplay(_ sender: UIButton) {
        if !isRunning{
            guard let text = fpsNum.text else {
                return
            }
            if let fps = Double(text)
            {
                let timeInterval = (Double(1/fps))
                timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true)
                playbutton.isEnabled = false
                pausebutton.isEnabled = true
                isRunning = true
            }
        }
    }
    
    @objc func UpdateTime(){
        guard let text = fpsNum.text else {
            return
        }
        if let fps = Double(text)
        {
            let timeInterval:Double = (Double(1/fps))
            counter += timeInterval
            titlelabel.text = String(format: "%.2f", counter)
        }
    }
    
    
}

