//
//  ViewController.swift
//  MemeMe
//
//  Created by Mohammed Jarad on 3/24/19.
//  Copyright © 2019 Jarad. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UIToolbar!
    
    
    let textTopDelegate = TextFieldDelegate()
    
    let memeTextAttributes : [String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.0,
        ]
    
//    struct Meme {
//        var textTop: String
//        var textBottom: String
//        var imageOriginal: UIImage?
//        var imageMemed: UIImage?
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        self.shareButton.isEnabled = false
        
        configureTextField(topTextField, text: "TOP")
        configureTextField(bottomTextField, text: "BOTTOM")
 
        topTextField.textAlignment = NSTextAlignment.center
        bottomTextField.textAlignment = NSTextAlignment.center
    }
    
    func configureTextField(_ textField: UITextField, text: String) {
        textField.text = text
        textField.backgroundColor = UIColor.clear
        textField.delegate = textTopDelegate
        textField.defaultTextAttributes = memeTextAttributes
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
        if topTextField.text == "" {
            topTextField.text = "TOP"
        }
        if bottomTextField.text == "" {
            bottomTextField.text = "BOTTOM"
        }
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        pickImage(.photoLibrary)
    }
    
    @IBAction func cameraImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            pickImage(.camera)
        }else {
            print("Camera Not Available")
        }
    }
    
    func pickImage(_ source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        pickerController.allowsEditing = false
        present(pickerController, animated: true, completion: nil)
    }

    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Entering the method")
        let newImage =  info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.backgroundColor = UIColor.black
        imageView.image = newImage
       
        dismiss(animated: true, completion: nil)
        self.shareButton.isEnabled = true
    }
       
    func generateMemedImage() -> UIImage
    {
        var image = UIImage()
        
        toolBarIsHidden(hide: true)
                
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private func toolBarIsHidden(hide: Bool) {
        navigationBar.isHidden = hide
        toolBar.isHidden = hide
    }
    
    func saveMeme(image: UIImage) {
        // Create the meme
        let meme = Meme(textTop: topTextField.text!, textBottom: bottomTextField.text!, imageOriginal: imageView.image!, imageMemed: image)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        
        let image = generateMemedImage() ;
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> () in
            if (completed) {
                self.saveMeme(image: image)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(controller, animated: true, completion: nil)
        toolBar.isHidden = false
        navigationBar.isHidden = false
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        imageView.image = nil
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        textTopDelegate.returnToDefault()
    }
    
}
