//
//  MemeTableView.swift
//  MemeMe
//
//  Created by Mohammed Jarad on 04/04/2019.
//  Copyright © 2019 Jarad. All rights reserved.
//

import Foundation
import UIKit

class MemeTableView: UITableViewController {
    
    var memes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(MemeTableView.New))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func New() {
        let controller: EditorViewController
        controller = storyboard?.instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
            present(controller, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the image
        cell.imageView?.image = meme.imageMemed
        cell.textLabel?.text = meme.textTop
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailView") as! MemeDetailView
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
