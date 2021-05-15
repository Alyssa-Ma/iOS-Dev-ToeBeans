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
    
    @IBAction func playSearchButton(_ sender: Any) {
        playSound()
    }
   
    func playSound() {
        let soundURL = Bundle.main.path(forResource: "ClickSound", ofType: "mp3")
        
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

