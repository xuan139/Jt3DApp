import UIKit
import AVFoundation

class JT3DVideoPlayerViewController: UIViewController {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var timeObserverToken: Any?
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24) // 设置字体大小为24
        button.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var videoURL: URL? {
        didSet {
            configurePlayer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer!)
        
        setupControls()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
    }
    
    private func configurePlayer() {
        guard let videoURL = videoURL else { return }
        
        let playerItem = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: playerItem)
        playerLayer?.player = player
        
        addPeriodicTimeObserver()
    }
    
    private func setupControls() {
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playPauseButton)
        
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 600)
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.updateProgressBar()
        }
    }
    
    private func updateProgressBar() {
        // 这里可以添加进度条更新的逻辑
    }
    
    @objc private func playPauseButtonTapped() {
        if player?.timeControlStatus == .playing {
            player?.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            player?.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    deinit {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        player?.pause()
        player = nil
    }
}
