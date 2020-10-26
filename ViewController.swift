
//  ViewController.swift
//  AudioPicker
//
//  Created by NINKAL GUPTA on 30/08/20.
//  Copyright © 2020 NINKAL GUPTA. All rights reserved.

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
class ViewController: UIViewController,MPMediaPickerControllerDelegate {
    
    @IBOutlet weak var selectAudioBtn: UIButton!
     
          
     var avMusicPlayer: AVAudioPlayer!
     var mpMediapicker: MPMediaPickerController!
     var mediaItems = [MPMediaItem]()
     let currentIndex = 0
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    }
@IBAction func selectSongs(_ sender: UIButton) {
//    let controller = MPMediaPickerController(mediaTypes: .music)
//    controller.allowsPickingMultipleItems = true
//    controller.popoverPresentationController?.sourceView = sender
//    controller.delegate = self
//    controller.prompt = NSLocalizedString("Chose audio file", comment: "Please chose an audio file")
//
//    present(controller, animated: true)
    
    
    mpMediapicker = MPMediaPickerController.self(mediaTypes:MPMediaType.music)
    mpMediapicker.allowsPickingMultipleItems = false
    mpMediapicker.delegate = self
    self.present(mpMediapicker, animated: true, completion: nil)
    
}
    
//func mediaPicker(_ mediaPicker: MPMediaPickerController,
//                 didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
//    // Get the system music player.
//    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
//    musicPlayer.setQueue(with: mediaItemCollection)
//    mediaPicker.dismiss(animated: true)
//    // Begin playback.
//    musicPlayer.play()
//}
//
//func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
//    mediaPicker.dismiss(animated: true)
//}

    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        //What to do?
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        mediaItems = mediaItemCollection.items
        updatePlayer()
        self.dismiss(animated: true, completion: nil)
    }
    
    func updatePlayer(){
        let item = mediaItems[currentIndex]
        // DO-TRY-CATCH try to setup AVAudioPlayer with the path, if successful, sets up the AVMusicPlayer, and song values.
        if let path: NSURL = item.assetURL as NSURL? {
            do
            {
                avMusicPlayer = try AVAudioPlayer(contentsOf: path as URL)
                avMusicPlayer.enableRate = true
                avMusicPlayer.rate = 1.0
                avMusicPlayer.numberOfLoops = 0
                avMusicPlayer.currentTime = 0
            }
            catch
            {
                avMusicPlayer = nil
            }
        }
    }
    
//
//    @IBAction func Play(_ sender: AnyObject) {
//        //AVMusicPlayer.deviceCurrentTime
//        avMusicPlayer.play()
//    }
//
//    @IBAction func Stop(_ sender: AnyObject) {
//        avMusicPlayer.stop()
//    }
//
//    @IBAction func picker(_ sender: AnyObject) {
//
//    }
    
    
    
}
// let picker = MPMediaPickerController()
//        picker.delegate = self
//        picker.allowsPickingMultipleItems = true
//        self.presentViewController(picker, animated: true, completion: nil)
//}
//func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
//    self.dismissViewControllerAnimated(true, completion: nil)
//}
//func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
//    //run any code you want once the user has picked their chosen audio
//}


//Add 'NSAppleMusicUsageDescription' to your Info.plist for the privacy authority.
//Make sure your music is available in your iPhone. It will not work in the simulator.
//iOS 10.0.1


