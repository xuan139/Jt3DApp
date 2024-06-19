import UIKit
import UniformTypeIdentifiers

class DocumentPickerHandler: NSObject, UIDocumentPickerDelegate {
    
    // Add a closure to handle the picked URLs
    var onPickedURLs: (([URL]) -> Void)?
    
    func presentDocumentPicker(from viewController: UIViewController) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.content], asCopy: true)
        documentPicker.delegate = self
        viewController.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        for url in urls {
//            let fileExtension = url.pathExtension.lowercased()
            onPickedURLs?([url])
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
        print("Document picker was cancelled")
    }
}
