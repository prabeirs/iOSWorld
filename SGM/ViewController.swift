//
//  ViewController.swift
//  SGM2_UIKit
//
//  Created by P sena on 08/07/19.
//  Copyright © 2019 Codage avec Swift. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]() // Storage for nations flag names.
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "National maps"
        navigationController?.navigationBar.prefersLargeTitles = true // This enables large title across our whole app because each VC is pushed onto the navigation controler stack and hence inherits the setting style from it's predecessor.
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix(".png") && !item.contains("@") {
            //if item.hasSuffix(".png") {

                pictures.append(item)
            }
        }
        
        print(pictures)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) // Pictur is the reuse identifier we set on the IB while creating the table view at start.
        let countryNamePng = pictures[indexPath.row]
        let numCharsToDrop = 4 // .png is end of every image filename
        let countryName = countryNamePng.dropLast(numCharsToDrop)
        let realCountryName = String(countryName)
        cell.textLabel?.text = realCountryName
        cell.imageView?.image = UIImage(named: countryNamePng)
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.gray.cgColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Load the DVC (Detail view controller) from the storyBoard.
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            // Push this detail view controller screen to the stack of the navigation controller's views of screens it has in stock. Users can swipe left & right on these screens.
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

