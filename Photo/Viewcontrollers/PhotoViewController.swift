//
//  PhotoViewController.swift
//  Photo
//
//  Created by Александр Панин on 27.01.2022.
//

import UIKit

class PhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var photoImage: UIImageView!
    
    var imagePhoto: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func photoButton(_ sender: Any) {
        
        imagePhoto = UIImagePickerController() // инициализировали контролер
        imagePhoto.delegate = self // указываем что здесь будем использовать методы делегата
       
        
        imagePhoto.sourceType = .camera // казываем что будем использовать камеру в info - прописать запрос на использование камеры
        imagePhoto.cameraDevice = .front
        
        imagePhoto.allowsEditing = true
        
        present(imagePhoto, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePhoto.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        photoImage.image = image
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
