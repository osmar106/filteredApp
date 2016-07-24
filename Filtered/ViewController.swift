//
//  ViewController.swift
//  Filtered
//
//  Created by Osmar Rodríguez on 7/3/16.
//  Copyright © 2016 Osmar Rodríguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var filteredImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var filterButton: UIButton!
    
    @IBOutlet var secondaryMenu: UIView!
    
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var compareButton: UIButton!
    
    
    var originalImage: UIImage!
    var currentImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //SHARE BUTTON
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil) //IMPORTANT
        presentViewController(activityController, animated: true, completion: nil)
    }

    
    //NEW PHOTO BUTTON
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet=UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //imageView.image = image
            setupNewImage(image)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    //FILTER BUTTON
    @IBAction func onFilter(sender: UIButton) {
        if(sender.selected){
            hideSecondaryMenu()
            sender.selected = false
        }
        else {
            showSecondaryMenu()
            sender.selected = true
        }

    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = secondaryMenu.heightAnchor.constraintGreaterThanOrEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }
    
    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: { 
            self.secondaryMenu.alpha = 0.4
            }) { (completed) in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }
    
    func setupNewImage(image: UIImage) {
        // got a new image to filter, update state
        hideSecondaryMenu()
        //hideSliderMenu()
        
        imageView.image = image // display the selected image
        self.originalImage = image // save the selected image for comparing against
        
        // disable comparisons and edits until image is filtered
        //editButton.enabled = false
    }
    
    //Filter Red
    @IBAction func filterRed(sender: UIButton) {
        if(sender.selected){
            imageView.image = originalImage
            sender.selected = false
            compareButton.enabled = false
        }
        else {
            if self.originalImage == nil {
                self.originalImage = imageView.image!
            }
            let image = processor.applyFilters(originalImage!, colorRed: 100, colorGreen: 0, colorBlue: 0, colorAlpha: 0, colorGray: 0, colorContrast: 0)
            imageView.image = image
            compareButton.enabled = true
            sender.selected = true
        }
    }
    
    //Filter Green
    @IBAction func filterGreen(sender: UIButton) {
        if(sender.selected){
            imageView.image = originalImage
            sender.selected = false
            compareButton.enabled = false
        }
        else {
            if self.originalImage == nil {
                self.originalImage = imageView.image!
            }
            let image = processor.applyFilters(originalImage!, colorRed: 0, colorGreen: 100, colorBlue: 0, colorAlpha: 0, colorGray: 0, colorContrast: 0)
            imageView.image = image
            compareButton.enabled = true
            sender.selected = true
        }
    }
    
    //Filter Blue
    @IBAction func filterBlue(sender: UIButton) {
        if(sender.selected){
            imageView.image = originalImage
            sender.selected = false
            compareButton.enabled = false
        }
        else {
            if self.originalImage == nil {
                self.originalImage = imageView.image!
            }
            let image = processor.applyFilters(originalImage!, colorRed: 0, colorGreen: 0, colorBlue: 100, colorAlpha: 0, colorGray: 0, colorContrast: 0)
            imageView.image = image
            compareButton.enabled = true
            sender.selected = true
        }
    }
    
    //Filter Gray
    @IBAction func filterGray(sender: UIButton) {
        if(sender.selected){
            imageView.image = originalImage
            sender.selected = false
            compareButton.enabled = false
        }
        else {
            if self.originalImage == nil {
                self.originalImage = imageView.image!
            }
            let image = processor.applyFilters(originalImage!, colorRed: 0, colorGreen: 0, colorBlue: 0, colorAlpha: 0, colorGray: 100, colorContrast: 0)
            imageView.image = image
            compareButton.enabled = true
            sender.selected = true
        }
    }
    
    //Filter Contrast
    @IBAction func filterContrast(sender: UIButton) {
        if(sender.selected){
            imageView.image = originalImage
            sender.selected = false
            compareButton.enabled = false
        }
        else {
            if self.originalImage == nil {
                self.originalImage = imageView.image!
            }
            let image = processor.applyFilters(originalImage!, colorRed: 0, colorGreen: 0, colorBlue: 0, colorAlpha: 0, colorGray: 0, colorContrast: 100)
            imageView.image = image
            compareButton.enabled = true
            sender.selected = true
        }
    }

    
    @IBAction func onCompare(sender: UIButton) {
        if(sender.selected){
            imageView.image = currentImage
            sender.selected = false
        }
        else {
            if self.currentImage == nil {
                self.currentImage = imageView.image!
            }
            let image = originalImage
            imageView.image = image
            
            sender.selected = true
        }
    }
    
    
}

