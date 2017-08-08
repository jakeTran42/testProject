//
//  AddNewVIewController.swift
//  TestProject
//
//  Created by Jake Tran on 8/4/17.
//  Copyright © 2017 Jake Tran. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class AddNewViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var takeOrChooseImageButton: UIButton!
    @IBOutlet weak var datePickerText: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    var pickedImage: UIImage?
    
    //VarCategoryPicker
    var categoryData = ["", "Entertainment", "Food", "Grocery", "Ultility", "Banking", "Shopping", "Travel", "Others"]
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
        
        pickedImage = image
        
        
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

    @IBAction func saveButtonTapped(_ sender: Any) {
        
        var imageURL = ""
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        // 1
        //create data type to put it to Firebase Storage
        guard let imageData = UIImageJPEGRepresentation(pickedImage!, 0.1) else {
            return
        }
        
        // 2
        //create a reference where you will be putting your imageData
        let rightNow = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss EEE"
        let timeStampForImage = formatter.string(from: rightNow)
        let imageRef = Storage.storage().reference().child(timeStampForImage)

        imageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // 3
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            // 4
            let urlString = metadata?.downloadURL()?.absoluteString
            
            print("image url: \(urlString)")
            if urlString != nil {
                imageURL = urlString!

                dispatchGroup.leave()
            }
        })
        
        
        
        dispatchGroup.notify(queue: .main) { 
            print("successfully uploaded image")
            let newReceipt = Receipt(imageURL: imageURL, title: self.titleTextField.text!, description: self.descriptionTextField.text, category: self.categoryTextField.text!, date: self.datePickerText.text!, location: self.locationTextField.text!, amount: Double(self.amountTextField.text!)!)
            let values = newReceipt.dictionaryToPostOnFirebase
            

            
            
            let receiptRef = Database.database().reference().child("receipts").child(User.current.uid).childByAutoId()
            receiptRef.updateChildValues(values!, withCompletionBlock: { (err, ref) in
                if let _ = err {
                    return
                }
                
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let justPostedReceipt = Receipt(snapshot: snapshot)
                    print("New receipt was created! Title: \(justPostedReceipt?.title)")
                
                })
            })
        }
    }
}
