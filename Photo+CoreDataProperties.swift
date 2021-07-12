//
//  Photo+CoreDataProperties.swift
//  Closet
//
//  Created by Ting on 2019/6/16.
//  Copyright © 2019 James. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photo_image: NSData?
    @NSManaged public var photoToAlbum: Album?

}
