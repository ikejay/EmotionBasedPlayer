//
//  PlayerViewController.swift
//  EmotionalPlayer
//
//  Created by Isaac Annan on 10/03/2019.
//  Copyright © 2019 Isaac Annan. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer


class PlayerViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var elapsedTime: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    @IBOutlet weak var playbutton: UIButton!
    
    var myPlayer: AVAudioPlayer!
    
    var myTimer: Timer!
    
    var isScrubbing:Bool = false
    
    
    
    //var audioPlayer:AVAudioPlayer! = nil
    var currentAudio = ""
    var currentAudioPath:URL!
    var audioList:NSArray!
    var currentAudioIndex = 0
    var timer:Timer!
    var audioLength = 0.0
    var toggle = true
    var effectToggle = true
    var totalaudioLength = ""
    var finalImage:UIImage!
    var isTableViewOnscreen = false
    var shuffleState = false
    var repeatState = false
    var shuffleArray = [Int]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        albumCover.layer.borderWidth = 0.3
        albumCover.layer.masksToBounds = false
        albumCover.layer.borderColor = UIColor.black.cgColor
        //albumCover.layer.cornerRadius = albumCover.frame.height/2
        albumCover.clipsToBounds = true
        
       // let mediaItems = MPMediaQuery.songs().items
       // var query = MPMediaQuery.songs()
        
       // let predicateByGenre = MPMediaPropertyPredicate(value: "rock", forProperty: MPMediaItemPropertyGenre)
        
        //query.filterPredicates = NSSet(object: predicateByGenre)
        
        //Set the path to song(this comes from the bundle)
        
        /*
        let myPath = URL.init(fileURLWithPath: Bundle.main.path(forResource: "eOneNashVille - God will take care of you", ofType: "mp3")!)
        
        do {
            
            //Unpacking the path String optional
           // if let unpackedPath = myPath {
                
                try myPlayer = AVAudioPlayer(contentsOf: myPath)
            
            guard let player = myPlayer else {return}
            
            player.prepareToPlay()
        }
        catch let error{
            print(error.localizedDescription)
        }
                myTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ timer in
                    
                    self.songProgress.progress = Float(self.myPlayer!.currentTime / self.myPlayer!.duration)
                }
            //}
            
            
      */
        
        prepareAudioFile()
        updateLabels()
        retrieveSliderProgressValue()
    }
    
    
    func  playAudio(){
        myPlayer?.play()
        startTimer()
        updateLabels()
                        //saveCurrentTrackNumber()
                        //showMediaInfo()
    }
    
    func playNextSong(){
        currentAudioIndex += 1
        if currentAudioIndex > audioList.count - 1 {
            currentAudioIndex -= 1
            return
        }
        
        if myPlayer.isPlaying{
            prepareAudioFile()
            playAudio()
            
        }
        
        else {
            prepareAudioFile()
        }
        
    }
    
    
    func playPreviousSong(){
        currentAudioIndex -= 1
        if currentAudioIndex < 0 {
            currentAudioIndex += 1
            return
        }
        
        if myPlayer.isPlaying {
            prepareAudioFile()
            playAudio()
        }
        
        else{
            prepareAudioFile()
        }
    }
    
    
    func stopPlayer(){
        myPlayer.stop()
    }
    
    func startTimer(){
        if timer == nil{
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:
                #selector(PlayerViewController.update(_:)) , userInfo: nil, repeats: true)
            timer.fire()
        }
    }
      
    @objc func update(_ timer:Timer){
        if myPlayer.isPlaying{
            return
        }
        let time = calculateTimeFromNSTimeInterval(myPlayer.currentTime)
        elapsedTime.text = "\(time.minute):\(time.second)"
        slider.value = CFloat(myPlayer.currentTime)
        UserDefaults.standard.set(slider.value, forKey: "sliderProgress")
    }
    
    
    func stopTimer(){
        timer.invalidate()
    }
    
    
    func retrieveSliderProgressValue(){
        let sliderProgressValue = UserDefaults.standard.float(forKey: "sliderProgress")
        if sliderProgressValue != 0 {
            slider.value = sliderProgressValue
            myPlayer.currentTime = TimeInterval(sliderProgressValue)
            
            let time = calculateTimeFromNSTimeInterval(myPlayer.currentTime)
            elapsedTime.text = "\(time.minute):\(time.second)"
            slider.value = CFloat(myPlayer.currentTime)
            
            }
        
        
        else{
            slider.value = 0.0
            myPlayer.currentTime  = 0.0
            elapsedTime.text = "00:00:00"
        }
    }
    
    
    
    func readArtistNameFromPlist(_ indexNumber: Int) -> String {
        readFromPlist()
        var infoDict = NSDictionary();
        infoDict = audioList.object(at: indexNumber) as! NSDictionary
        let artistName = infoDict.value(forKey: "artistName") as! String
        return artistName
    }
    
    func readSongNameFromPlist(_ indexNumber: Int) -> String {
        readFromPlist()
        var songNameDict = NSDictionary();
        songNameDict = audioList.object(at: indexNumber) as! NSDictionary
        let songName = songNameDict.value(forKey: "songName") as! String
        return songName ?? ""
    }
    
    func readAlbumNameFromPlist(_ indexNumber: Int) -> String{
        readFromPlist()
        var albumNameDict = NSDictionary();
        albumNameDict = audioList.object(at: indexNumber) as! NSDictionary
        let albumName = albumNameDict.value(forKey: "albumName") as? String
        return albumName ?? ""
    }
    
    func readArtworkNamefromPlist(_ indexNumber: Int) -> String {
        readFromPlist()
        var artworkNameDict = NSDictionary();
        artworkNameDict =  audioList.object(at: indexNumber) as! NSDictionary
        let artworkName = artworkNameDict.value(forKey: "songArtwork") as? String
        return artworkName ?? ""
    }

    
    func readFromPlist(){
        let myPath = Bundle.main.path(forResource: "myList", ofType: "plist")
        audioList = NSArray(contentsOfFile:myPath!)
    }
    
    
    
    func setCurrentAudioPath(){
        currentAudio = readSongNameFromPlist(currentAudioIndex)
        currentAudioPath = URL(fileURLWithPath: Bundle.main.path(forResource: currentAudio, ofType: "mp3")!)
        print("\(currentAudioPath)")
    }
 
    func saveCurrentTrackNumber(){
        UserDefaults.standard.set(currentAudioIndex, forKey:"currentAudioIndex")
        UserDefaults.standard.synchronize()
        
    }
    
    func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) -> (minute:String ,second:String){
        let myMinute = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
        let mySecond = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
        
        let minute = myMinute > 9 ?"\(myMinute)" : "0\(myMinute)"
        let second = mySecond > 9 ?"\(mySecond)" : "0\(mySecond)"
        
        return (minute,second)
        
    }
    
    func calculateLengthOfSong(){
        let time = calculateTimeFromNSTimeInterval(audioLength)
        totalaudioLength = "\(time.minute) : \(time.second)"
    }
    
    func showTotalAudioLength(){
        calculateLengthOfSong()
        remainingTime.text = totalaudioLength
    }
    
    
    func prepareAudioFile(){
        setCurrentAudioPath()
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }   catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        }   catch _ {
        }
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        myPlayer = try? AVAudioPlayer(contentsOf: currentAudioPath)
        myPlayer!.delegate = self
        audioLength = myPlayer!.duration
        slider.maximumValue = CFloat(myPlayer.duration)
        slider.minimumValue = 0.0
        slider.value = 0.0
        myPlayer!.prepareToPlay()
        showTotalAudioLength()
        updateLabels()
        elapsedTime.text = "00:00"
    }
    
    
    
    func updateLabels(){
        updateArtistNameLabel()
        updateAlbumNameLabel()
        updateSongNameLabel()
        updateAlbumArtwork()
    }
    
    
    func updateArtistNameLabel(){
    let nameOfArtist = readArtistNameFromPlist(currentAudioIndex)
    artistName.text = nameOfArtist
    }
    
    func updateAlbumNameLabel(){
    let nameOfAlbum = readAlbumNameFromPlist(currentAudioIndex)
    albumNameLabel.text = nameOfAlbum
    }
    
    func updateSongNameLabel(){
    let nameOfSong = readSongNameFromPlist(currentAudioIndex)
    songTitleLabel.text = nameOfSong
    }
    
    func updateAlbumArtwork(){
    let nameOfArtwork = readArtworkNamefromPlist(currentAudioIndex)
    albumCover.image = UIImage(named: nameOfArtwork)
    }
    
    
    
    @IBAction func didPressPrevious(_ sender: Any) {
        playPreviousSong()
        prepareAudioFile()
        playAudio()
        
    }
    

    @IBAction func didPressPlay(_ sender: Any) {
        
        let play = UIImage(named: "play")
        let pause = UIImage(named: "pause")
        
        
        if myPlayer?.isPlaying == true{
            myPlayer?.pause()
             playbutton.setImage(play, for: UIControl.State())
        }
        else{
            playAudio()
            //myPlayer?.play()
            playbutton.setImage(pause, for: UIControl.State())
        }
        
    }
    
    
    
    @IBAction func didPressNext(_ sender: Any) {
        playNextSong()
        prepareAudioFile()
        playAudio()
        
    }
    
    
    @IBAction func didChangeSongProgres(_ sender: UISlider) {
        myPlayer.currentTime = TimeInterval(sender.value)
    }
    
    
   
}
