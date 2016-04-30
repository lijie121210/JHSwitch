//
//  ViewController.swift
//  JHSwitchExample
//
//  Created by Lijie on 16/4/29.
//  Copyright © 2016年 HuatengIOT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var theSwitch: JHSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        theSwitch.on = true
        theSwitch.didChangeClosure = { (value:Bool) -> Void in
            print(#function, value)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

