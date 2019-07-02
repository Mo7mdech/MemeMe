//
//  MemeDetailView.swift
//  MemeMe
//
//  Created by Mohammed Jarad on 04/04/2019.
//  Copyright © 2019 Jarad. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailView : UIViewController {
    
    @IBOutlet weak var detailImage: UIImageView!
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.detailImage!.image = meme.imageMemed
    }
}
