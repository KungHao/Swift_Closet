//
//  CollectionViewController.swift
//  Closet
//
//  Created by CHO LIANG LIANG on 2019/6/18.
//  Copyright © 2019 James. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var images = [UIImage]()
//    var images = [UIImage(named: "1234.JPG"), UIImage(named: "1234.JPG"), UIImage(named: "1234.JPG")]
	var myTitle: String?
	let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = myTitle
        viewContext = app.persistentContainer.viewContext
		
        // barItems
        let cameraBtn = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraAction))
        let photoBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(phtotLibraryAction))
		navigationItem.rightBarButtonItems = [photoBtn, cameraBtn]
		
		// 設定 layout
		let itemSize = UIScreen.main.bounds.width/2 - 10
		let layout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
		layout.itemSize = CGSize(width: itemSize, height: 250)
		layout.minimumLineSpacing = 10
		layout.minimumInteritemSpacing = 3
		self.collectionView.collectionViewLayout = layout
        
        queryImage()
        self.collectionView.reloadData()
	}
	
    func queryImage() {
		let fetchRequest: NSFetchRequest<Album> = Album.fetchRequest()
		let predicate = NSPredicate(format: "album_name = '\((myTitle)!)'")
		fetchRequest.predicate = predicate
		
		do {
			let allAlbum = try viewContext.fetch(fetchRequest)
			for album in allAlbum {
				if album.album_name == nil {
					print("Can't find album: \((album.album_name)!)")
				} else {
					for photo in album.albumToPhoto as! Set<Photo> {
						let image = UIImage(data: photo.photo_image! as Data)
						images.append(image!)
					}
				}
			}
        } catch {
            print(error)
        }
	}

    func saveImage(image: UIImage) {
        let fetchRequest: NSFetchRequest<Album> = Album.fetchRequest()
        let predicate = NSPredicate(format: "album_name = '\((myTitle)!)'")
        fetchRequest.predicate = predicate
        
        do {
            let allAlbum = try viewContext.fetch(fetchRequest)
            for album in allAlbum {
                if album.album_name == nil {
                    print("Can't find album: \((album.album_name)!)")
                } else {
                    let photoImage = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: viewContext) as! Photo
                    photoImage.photo_image = image.pngData() as NSData?
                    album.addToAlbumToPhoto(photoImage)
                }
            }
        } catch {
            print(error)
        }
        
        app.saveContext()
    }
    
	@objc func cameraAction(){
		let imagePicker = UIImagePickerController()
		imagePicker.sourceType = .camera
		imagePicker.delegate = self
		present(imagePicker, animated: true, completion: nil)
	}
	
	@objc func phtotLibraryAction(){
		let imagePicker = UIImagePickerController()
		imagePicker.sourceType = .photoLibrary
		imagePicker.delegate = self
		present(imagePicker, animated: true, completion: nil)
	}
	
	@objc func deleteImage(_ sender: UIButton){
		print("delete things \(sender.tag)")
        print("\((images[sender.tag]))")
		
        let fetchRequest: NSFetchRequest<Album> = Album.fetchRequest()
        let predicate = NSPredicate(format: "album_name = '\((myTitle)!)'")
        fetchRequest.predicate = predicate
        let imageData = images[sender.tag].pngData() as NSData?
        
        do {
            let allAlbum = try viewContext.fetch(fetchRequest)
            for album in allAlbum {
                if album.album_name == nil {
                    print("Can't find album: \((album.album_name)!)")
                } else {
                    for photo in album.albumToPhoto as! Set<Photo> {
                        if imageData == photo.photo_image {
                            viewContext.delete(photo)
                            images.remove(at: sender.tag)
                            self.collectionView.reloadData()
                        }
                        app.saveContext()
                    }
                }
            }
        } catch {
            print(error)
        }
	}
	
	// 讀取 拍照或相簿 image
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
		if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			images.append(image)
			saveImage(image: image)
			self.collectionView.reloadData()
		}

		dismiss(animated: true, completion: nil)
	}
	
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
	
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
		
        cell.myImage.image = images[indexPath.row]
		cell.btnDel.tag = indexPath.row
		cell.btnDel.addTarget(self, action: #selector(deleteImage), for: UIControl.Event.touchUpInside)
        return cell
    }
	
	// 進入show image畫面
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "viewController") as! ViewController
        vc.myImage = images[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
	}



}
