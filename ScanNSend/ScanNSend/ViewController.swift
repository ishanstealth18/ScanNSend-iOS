//
//  ViewController.swift
//  ScanNSend
//
//  Created by Lightwave Technology on 2020-12-07.
//

import UIKit
import CoreBluetooth


var inputStr: String!


class ViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties

    @IBOutlet weak var commandTextInput: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sampleLabel: UILabel!

    var centralManager: CBCentralManager!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //When view controller instance is loaded, commandInputText delegates to viewController
        commandTextInput.delegate = self
    }

    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Clear the keyboar and resign the first responder
        commandTextInput.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        sampleLabel.text = commandTextInput.text
    }


    //MARK: Actions

    @IBAction func sendCommandButton(_ sender: UIButton) {

        inputStr = commandTextInput.text
        BleFunction.bleObj.startBLEFunction(inputString: inputStr)
    }

}

