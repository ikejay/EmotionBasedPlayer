//
//  libraryViewController.swift
//  EmotionalPlayer
//
//  Created by Isaac Annan on 27/05/2019.
//  Copyright © 2019 Isaac Annan. All rights reserved.
//

import UIKit
import MediaPlayer
import Foundation
import AVFoundation


class libraryViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var libraryTableView: UITableView!
    
   
    
    var playerController = PlayerViewController()
    var myAudioList = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    readFromPlist()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAudioList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        readFromPlist()
        var songNameDict = NSDictionary();
        songNameDict = myAudioList.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        let songName = songNameDict.value(forKey: "songName") as! String
        
        var albumNameDict = NSDictionary();
        albumNameDict = myAudioList.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        let albumName = albumNameDict.value(forKey: "albumName") as? String
        
        var cellNib = Bundle.main.loadNibNamed("TableViewCell", owner: nil, options: nil)
        let cell = cellNib![0] as? TableViewCell
        cell?.albNameLabel.text = albumName
        cell?.myImageView.image = nil
        cell?.sngNameLabel.text = songName
        
        
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
//        cell.textLabel?.font = UIFont(name: "BodoniSvtyTwoITCTT-BookIta", size: 25.0)
//        cell.textLabel?.textColor = UIColor.black
//        cell.textLabel?.text = songName
//
//        cell.detailTextLabel?.font = UIFont(name: "BodoniSvtyTwoITCTT-Book", size: 16.0)
//        cell.detailTextLabel?.textColor = UIColor.black
//        cell.detailTextLabel?.text = albumName
        return cell!
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
  
    func readFromPlist(){
        let myPath = Bundle.main.path(forResource: "myList", ofType: "plist")
        myAudioList = NSArray(contentsOfFile:myPath!) ?? []
    }

}
