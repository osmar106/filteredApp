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
        imageView.userInteractionEnabled = true;
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
            crossFadeToImage(imageView.image!)
            sender.selected = false
            compareButton.enabled = false
        }
        else {
            if self.originalImage == nil {
                self.originalImage = imageView.image!
            }
            let image = processor.applyFilters(originalImage!, colorRed: 100, colorGreen: 0, colorBlue: 0, colorAlpha: 0, colorGray: 0, colorContrast: 0)
            imageView.image = image
            crossFadeToImage(imageView.image!)
            compareButton.enabled = true
            sender.selected = true
        }
    }
    
    //Filter Green
    @IBAction func filterGreen(sender: UIButton) {
        if(sender.selected){
            imageView.image = originalImage
            crossFadeToImage(imageView.image!)
            sender.selected = false
            compareButton.enabled = false
        }
        else {
            if self.originalImage == nil {
                self.originalImage = imageView.image!
            }
            let image = processor.applyFilters(originalImage!, colorRed: 0, colorGreen: 100, colorBlue: 0, colorAlpha: 0, colorGray: 0, colorContrast: 0)
            imageView.image = image
            crossFadeToImage(imageView.image!)
            compareButton.enabled = true
            sender.selected = true
        }
    }
    
    //Filter Blue
    @IBAction func filterBlue(sender: UIButton) {
        if(sender.selected){
            imageView.image = originalImage
            crossFadeToImage(imageView.image!)
            sender.selected = false
            compareButton.enabled = false
        }
        else {
            if self.originalImage == nil {
                self.originalImage = imageView.image!
            }
            let image = processor.applyFilters(originalImage!, colorRed: 0, colorGreen: 0, colorBlue: 100, colorAlpha: 0, colorGray: 0, colorContrast: 0)
            imageView.image = image
            crossFadeToImage(imageView.image!)
            compareButton.enabled = true
            sender.selected = true
        }
    }
    
    //Filter Gray
    @IBAction func filterGray(sender: UIButton) {
        if(sender.selected){
            imageView.image = originalImage
            crossFadeToImage(imageView.image!)
            sender.selected = false
            compareButton.enabled = false
        }
        else {
            if self.originalImage == nil {
                self.originalImage = imageView.image!
            }
            let image = processor.applyFilters(originalImage!, colorRed: 0, colorGreen: 0, colorBlue: 0, colorAlpha: 0, colorGray: 100, colorContrast: 0)
            imageView.image = image
            crossFadeToImage(imageView.image!)
            compareButton.enabled = true
            sender.selected = true
        }
    }
    
    //Filter Contrast
    @IBAction func filterContrast(sender: UIButton) {
        if(sender.selected){
            imageView.image = originalImage
            crossFadeToImage(imageView.image!)
            sender.selected = false
            compareButton.enabled = false
        }
        else {
            if self.originalImage == nil {
                self.originalImage = imageView.image!
            }
            let image = processor.applyFilters(originalImage!, colorRed: 0, colorGreen: 0, colorBlue: 0, colorAlpha: 0, colorGray: 0, colorContrast: 100)
            imageView.image = image
            crossFadeToImage(imageView.image!)
            compareButton.enabled = true
            sender.selected = true
        }
    }

    
    //COMPARE BUTTON
    @IBAction func onCompare(sender: UIButton) {
        if(sender.selected){
            imageView.image = currentImage
            crossFadeToImage(imageView.image!)
            sender.selected = false
        }
        else {
            if self.currentImage == nil {
                self.currentImage = imageView.image!
            }
//            let image = originalImage
//            imageView.image = image
            
            let labeledImage = addTextToImage("original", inImage: originalImage, atPoint: CGPointMake(0, 0))
            imageView.image = labeledImage
            crossFadeToImage(imageView.image!)
            sender.selected = true
        }
    }
    
    
    // MARK: UIResponder methods (from Week5 forums)
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == imageView {
            // print("imageView is been tapped by the user.")
            if self.currentImage == nil {
                self.currentImage = imageView.image!
            }
            let image = originalImage
            imageView.image = image
        }
        super.touchesBegan(touches, withEvent: event)
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == imageView {
            // print("imageView has been tapped by the user.")
            imageView.image = currentImage
        }
        super.touchesEnded(touches, withEvent: event)
    }
    
    
    //"ORIGINAL" MESSAGE from http://stackoverflow.com/questions/28906914/how-do-i-add-text-to-an-image-in-ios-swift
    func addTextToImage(drawText: NSString, inImage: UIImage, atPoint:CGPoint)->UIImage{
        
        // Setup the font specific variables
        let textColor: UIColor = UIColor.purpleColor()
        // calculate the overlay font size, otherwise for high-res images it will be too small,
        // and for low-res images it will be too huge.
        let fontSize: Int = Int(floorf(Float(inImage.size.width) / 5.0))
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: CGFloat(fontSize))!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            
            ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        
        //Now Draw the text into an image.
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
    }
    
    
    //CROSS-FADE based on http://stackoverflow.com/questions/7638831/fade-dissolve-when-changing-uiimageviews-image
    func crossFadeToImage(image: UIImage) {
        UIView.transitionWithView(imageView, duration:1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.imageView.image = image}, completion: nil)
    }
    
}

