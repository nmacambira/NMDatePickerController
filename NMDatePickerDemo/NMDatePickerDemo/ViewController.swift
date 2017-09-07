//
//  ViewController.swift
//  NMDatePickerDemo
//
//  Created by Natalia Macambira on 21/05/17.
//  Copyright © 2017 Natalia Macambira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NMDatePickerDelegate {
    
    @IBOutlet var dateSelectedLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func callDatePickerButton(_ sender: UIButton) {
        /* Instatiate NMDatePickerController with its Delegate */
        let datePickerController = NMDatePickerController(delegate: self)
        
        /* Config DatePicker anyway you want */
        datePickerController.datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        datePickerController.datePicker.locale = Locale(identifier: "pt_BR")
        
        /* [Optional] - Config Title */
        //datePickerController.titleLabel.isHidden = true
        datePickerController.titleLabel.text = "Escolha uma data e pressione 'Selecionar' ou 'Cancelar'"
        
        /* [Optional] - Config Now Button */
        //datePickerController.nowButton.isHidden = true
        datePickerController.nowButton.setTitle("Agora", for: .normal)
        
        /* [Optional] - Config Cancel and Select Button */
        datePickerController.cancelButton.setTitle("Cancelar", for: .normal)
        datePickerController.selectButton.setTitle("Selecionar", for: .normal)
        
        /* [Optional] - Config blur effect */
        //datePickerController.blurEffect = true
        //datePickerController.blurEffectStyle = .dark
        
        /* [Optional] - Preselect a date in DatePicker: show dateSelectedLabel text in DatePicker instead of the Today's date */
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMMM/yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        let label = dateSelectedLabel.text
        if let date = dateFormatter.date(from: label!) {
            datePickerController.datePicker.date = date
        }
    }
    
    func datePickerCancelButtonAction() {
        
        print("DatePicker cancel button was pressed")
    }
    
    func datePickerSelectButtonAction(dateSelected: Date) {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMMM/yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "pt_BR")
        let date: String = dateFormatter.string(from: dateSelected)
        
        self.dateSelectedLabel.text = date
        print("DatePicker selected value: \(date)")
    }
}
