//
//  DocumentsViewController.swift
//  Jt3DApp
//
//  Created by XUAN LI on 6/19/24.
//
import UIKit

class DocumentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var files: [String] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Documents"
        
        setupTableView()
        fetchDocuments()
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    private func fetchDocuments() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            files = try fileManager.contentsOfDirectory(atPath: documentsURL.path)
        } catch {
            print("Error while fetching documents: \(error)")
        }
        
        tableView.reloadData()
    }
    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = files[indexPath.row]
        return cell
    }
    
    // UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedFile = files[indexPath.row]
        let alert = UIAlertController(title: "Selected File", message: selectedFile, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
