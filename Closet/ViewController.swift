//
//  ViewController.swift
//  Closet
//
//  Created by Ting on 2019/6/16.
//  Copyright © 2019 James. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var myImage: UIImage?
	@IBOutlet weak var showPhoto: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        showPhoto.image = myImage
    }


}

