
//  MainViewController.swift
//  Jt3DApp
//
//  Created by XUAN LI on 6/19/24.
//

import UIKit
import PhotosUI
import AVKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let menuItems = ["Photos", "Documents", "Tools", "History", "Exit"]
    var tableView: UITableView!
    var phpPickerHelper = PHPickerHelper()
    var documentPickerHandler = DocumentPickerHandler()
    
    var selectedVideoURL: URL?
    var selectedDocumentURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        initPicker()
    }
    
    func setupUI(){
        title = "Menu"
        self.view.backgroundColor = .white
        // Initialize the table view
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            phpPickerHelper.presentPicker(from: self, filter: nil)
        }else if indexPath.row == 1{
            documentPickerHandler.presentDocumentPicker(from: self)
        }
    }
    
    
    //    videoPlayerView.videoURL = videoURL
    func initPicker(){
        phpPickerHelper.onPicked = { [weak self] url in
            self?.selectedVideoURL = url
            if let videoURL = url {
                let playerVC = JT3DVideoPlayerViewController()
                playerVC.videoURL = videoURL
                  // Present the player view controller
                if let navigationController = self?.navigationController {
                    navigationController.pushViewController(playerVC, animated: true)
                } else {
                    print("Current view controller is not embedded in a navigation controller.")
                }
                print("No URL selected")
            }
        }
        
        documentPickerHandler.onPickedURLs = { [weak self] urls in
            for url in urls {
                self?.selectedDocumentURL = url
                
                let playerVC = JT3DVideoPlayerViewController()
                playerVC.videoURL = url
                  
                if let navigationController = self?.navigationController {
                    navigationController.pushViewController(playerVC, animated: true)
                } else {
                    print("Current view controller is not embedded in a navigation controller.")
                }
                
            }
        }
    }
    
    private func playVideo(with url: URL) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: url)
        
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
}


