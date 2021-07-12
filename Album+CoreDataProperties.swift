//
//  Album+CoreDataProperties.swift
//  Closet
//
//  Created by Ting on 2019/6/16.
//  Copyright © 2019 James. All rights reserved.
//
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var album_name: String?
    @NSManaged public var albumToPhoto: NSSet?

}

// MARK: Generated accessors for albumToPhoto
extension Album {

    @objc(addAlbumToPhotoObject:)
    @NSManaged public func addToAlbumToPhoto(_ value: Photo)

    @objc(removeAlbumToPhotoObject:)
    @NSManaged public func removeFromAlbumToPhoto(_ value: Photo)

    @objc(addAlbumToPhoto:)
    @NSManaged public func addToAlbumToPhoto(_ values: NSSet)

    @objc(removeAlbumToPhoto:)
    @NSManaged public func removeFromAlbumToPhoto(_ values: NSSet)

}
