//
//  TableViewController.swift
//  Closet
//
//  Created by Ting on 2019/6/16.
//  Copyright © 2019 James. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    var lists = [String]()
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewContext = app.persistentContainer.viewContext
        
        queryAlbum()
    }
    
    func insertAlbum(name: String) {
        let albumName = NSEntityDescription.insertNewObject(forEntityName: "Album", into: viewContext) as! Album
        albumName.album_name = name
        
        app.saveContext()
    }
    
    func queryAlbum() {
        do {
            let allAlbum = try viewContext.fetch(Album.fetchRequest())
            for album in allAlbum as! [Album] {
                lists.append(album.album_name!)
                print("Album :\((album.album_name)!)")
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAlbum(name: String) {
        do {
            let allAlbum = try viewContext.fetch(Album.fetchRequest())
            for album in allAlbum as! [Album] {
                if album.album_name == name {
                    for photo in album.albumToPhoto as! Set<Photo> {
                        viewContext.delete(photo)
                    }
                    viewContext.delete(album)
                }
                app.saveContext()
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func addAlbumBtn(_ sender: Any) {
        let alert = UIAlertController(title: "輸入", message: "請輸入相簿名稱", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let confirmAction = UIAlertAction(title: "確認", style: .default)
        { (action) in
            let albumName = alert.textFields![0].text
            print("新增相簿名稱：\((albumName)!)")
            self.lists.append(albumName!)
            let indexPath = IndexPath(row: self.lists.count - 1, section: 0)
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            
            self.insertAlbum(name: albumName!)
        }
        
        alert.addTextField
            { (textField) in
                textField.placeholder = "相簿名稱"
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = lists[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowVal = lists[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "showImages") as! CollectionViewController
		vc.myTitle = lists[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        print("you select row: \(rowVal)")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print("shit:\(lists[indexPath.row])")
            deleteAlbum(name: lists[indexPath.row])
            lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert{
            print("insert editingStyle: \((lists[indexPath.row]))")
        }
    }

}
