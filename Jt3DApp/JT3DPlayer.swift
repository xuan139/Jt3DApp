//
//  JT3DPlayer.swift
//  Jt3DApp
//
//  Created by XUAN LI on 6/19/24.
//

import UIKit
import AVFoundation

import UIKit
import AVFoundation

class JT3DVideoPlayerViewController: UIViewController {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    var videoURL: URL? {
        didSet {
            configurePlayer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black // Set background color to black for video playback
        
        // Configure and add player layer to view
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill // Adjust video aspect ratio as needed
        view.layer.addSublayer(playerLayer!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds // Adjust player layer frame to match view bounds
    }
    
    private func configurePlayer() {
        guard let videoURL = videoURL else { return }
        
        let playerItem = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: playerItem)
        playerLayer?.player = player
        
        // Start playing automatically
        player?.play()
    }
    
    deinit {
        player?.pause()
        player = nil
    }
}
