//
//  AddNewVIewController.swift
//  TestProject
//
//  Created by Jake Tran on 8/4/17.
//  Copyright © 2017 Jake Tran. All rights reserved.
//

import Foundation
import UIKit

class AddNewViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var takeOrChooseImageButton: UIButton!
    @IBOutlet weak var datePickerText: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    //VarCategoryPicker
    var categoryData = ["Entertainment", "Food", "Grocery", "Ultility", "Banking", "Shopping", "Travel", "Others"]
    var categoryPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageVIew.layer.cornerRadius = 12
        takeOrChooseImageButton.layer.cornerRadius = 12
        
        //creatingDatePicker
        createDatePicker()
        
        //createCategoryPicker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryTextField.inputView = categoryPicker
        
        //AmounttextFieldConfig
        amountTextField.keyboardType = UIKeyboardType.numberPad
        self.amountTextField.delegate = self
    }
    
    let datePicker = UIDatePicker()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func takeOrChooseImagePress(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("Camera Unavailable")
            }
            
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageVIew.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    //DatePickerFunc
    func createDatePicker() {
        
        //format picker
        datePicker.datePickerMode = .date
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //barButtonItem
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        datePickerText.inputAccessoryView = toolbar
        
        //assigning date picker to text field
        datePickerText.inputView = datePicker
    }
    
    func donePressed() {
        //format Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        datePickerText.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    //CategoryPickerFunc
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categoryData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryData[row]
    }
    
    //Amount text Config
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

    
    
}
