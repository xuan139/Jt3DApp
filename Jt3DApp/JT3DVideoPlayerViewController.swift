import UIKit
import AVFoundation

class JT3DVideoPlayerViewController: UIViewController {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var timeObserverToken: Any?
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
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
        progressSlider.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playPauseButton)
        view.addSubview(progressSlider)
        view.addSubview(currentTimeLabel)
        view.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            progressSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressSlider.bottomAnchor.constraint(equalTo: playPauseButton.topAnchor, constant: -20),
            
            currentTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentTimeLabel.centerYAnchor.constraint(equalTo: progressSlider.centerYAnchor),
            
            durationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            durationLabel.centerYAnchor.constraint(equalTo: progressSlider.centerYAnchor)
        ])
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 600)
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.updateProgressSlider()
        }
    }
    
    private func updateProgressSlider() {
        guard let player = player else { return }
        let duration = player.currentItem?.duration.seconds ?? 0
        let currentTime = player.currentTime().seconds
        
        progressSlider.value = Float(currentTime / duration)
        currentTimeLabel.text = formatTime(seconds: currentTime)
        durationLabel.text = formatTime(seconds: duration)
    }
    
    private func formatTime(seconds: Double) -> String {
        let totalSeconds = Int(seconds)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
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
    
    @objc private func sliderValueChanged(_ slider: UISlider) {
        guard let player = player else { return }
        let duration = player.currentItem?.duration.seconds ?? 0
        let newTime = Double(slider.value) * duration
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
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
