//
//  ViewController.swift
//  Toe Beans
//
//  Created by Alyssa Ma on 4/14/21.
//

import UIKit
import AVFoundation

class MainScreenViewController: UIViewController{
    var player = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK:- Sound Functionality
    //when search button is pressed, play click sound
    @IBAction func playSearchButton(_ sender: Any) {
        playSound()
    }
    
    //func to play sound from button
    func playSound() {
        //mp3 path
        let soundURL = Bundle.main.path(forResource: "Tiny Button Push-SoundBible.com-513260752", ofType: "mp3")
        
        //try to play sound
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundURL!))
            print("success audio")
        }
        catch {
            print("error playing audio")
        }
        player.play()
    }
    
}

