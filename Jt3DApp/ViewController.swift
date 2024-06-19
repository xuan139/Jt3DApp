import UIKit
import PhotosUI
import AVKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let menuItems = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
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
    
    func initPicker(){
        phpPickerHelper.onPicked = { [weak self] url in
            self?.selectedVideoURL = url
            if let videoURL = url {
                self?.playVideo(with: videoURL)
            } else {
                print("No URL selected")
            }
        }
        
        documentPickerHandler.onPickedURLs = { [weak self] urls in
            for url in urls {
                self?.selectedDocumentURL = url
                self?.playVideo(with: url)
            }
        }
    }
    
    func setupUI(){
        title = "Navigation Demo"
        
        // Initialize the table view
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -120)
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
    
    private func playVideo(with url: URL) {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: url)
        
        present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
}
