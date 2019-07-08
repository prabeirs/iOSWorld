//
//  DetailViewController.swift
//  SGM2_UIKit
//
//  Created by P sena on 08/07/19.
//  Copyright © 2019 Codage avec Swift. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String? // Prop in here to hold the name of the image load. When the VC is first created this won't exist so an optional String. Starts of life empty.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thisCountryName = selectedImage
        let charsToDrop = 4
        guard let countryName = thisCountryName?.dropLast(charsToDrop) else { return }
        let realCountryName = String(countryName)
        title = realCountryName // Both are optional as hence direct assignment of one optional to another optional. Title is nil by default.
        
        navigationItem.largeTitleDisplayMode = .never // our config for NavBAr for this screen.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad) // Passing in the (string) image filename to the UIImage method to draw the pixels in DVC.
            //imageView.layer.borderWidth = 3
            //imageView.layer.borderColor = UIColor.black.cgColor
        }
        
    }
    

    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        } // 80 % opacity
        var shareable: [Any] = [image] // shareable items or objects.
        if let imageText = selectedImage {
            shareable.append(imageText)
        }
        let vc = UIActivityViewController(activityItems: shareable, applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
