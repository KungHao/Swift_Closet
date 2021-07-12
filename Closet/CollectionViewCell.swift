//
//  CollectionViewCell.swift
//  Closet
//
//  Created by CHO LIANG LIANG on 2019/6/18.
//  Copyright © 2019 James. All rights reserved.
//

import UIKit

//protocol DataCollectionProtocol {
//	func showImage(indx: Int)
//	func delImage(indx: Int)
//}

class CollectionViewCell: UICollectionViewCell {
	
//    var delegate: DataCollectionProtocol?
//    var index: IndexPath?

	@IBOutlet weak var myImage: UIImageView!	
	@IBOutlet weak var btnDel: UIButton!
}
