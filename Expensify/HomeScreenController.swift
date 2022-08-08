//
//  ViewController.swift
//  CollectionView
//
//  Created by user206828 on 8/1/22.
//

import UIKit

class HomeScreenController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let monthArr:[String] = ["January","February","March","April","May","June", "July", "August", "September", "October", "November", "December"]

    @IBOutlet weak var myCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CollectionViewCell
        
        cell.monthName.text = monthArr[indexPath.row]
        return cell
    }
}

