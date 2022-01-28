//
//  PhotoViewController.swift
//  Photo
//
//  Created by Александр Панин on 27.01.2022.
//
import CoreImage
import UIKit

enum Source {
    case camera
    case gallary
}

class PhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var photoImage: UIImageView!
    
    var imagePhoto: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func gallaryButton(_ sender: Any) {
        imagePhoto = UIImagePickerController() // инициализировали контролер
        imagePhoto.delegate = self // указываем что здесь будем использовать методы делегата
        imagePhoto.sourceType = .photoLibrary // указываем что используем
        imagePhoto.allowsEditing = true // разрешение редактирования встроенными методами
        imagePhoto.modalPresentationStyle = .pageSheet // вид представления встроенных инструментов
        
        present(imagePhoto, animated: true, completion: nil) // запуск контроллера
        
    }
    
    @IBAction func photoButton(_ sender: Any) {
        imagePhoto = UIImagePickerController()
        imagePhoto.delegate = self
        imagePhoto.sourceType = .camera
        imagePhoto.cameraDevice = .front
        imagePhoto.allowsEditing = true
        imagePhoto.modalPresentationStyle = .pageSheet
        present(imagePhoto, animated: true, completion: nil)
        
 
    }
    
    @IBAction func saveButton(_ sender: Any) {
    }
    
        //MARK: -  действия после окончания работы встроенных вью контроллеров
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // проверка какое фото используем, едактируемое или нет
        if let image = info[.editedImage] as? UIImage {
            imageFilter(image)
        } else {
            guard  let image = info[.originalImage] as? UIImage else { return }
            imageFilter(image)
        }
        // выключение встроенного вью контроллера
        imagePhoto.dismiss(animated: true, completion: nil)
    }
    
        // MARK: - применение фильтра и вывод изображения во вью
    func imageFilter(_ image: UIImage) {
        let context = CIContext(options: nil)
        
        if let currentFilter = CIFilter(name: "CIPhotoEffectMono") {
            let beginImage = CIImage(image: image)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey) // ключ определяет определяет входное изображение
      //      currentFilter.setValue(0.9, forKey: kCIInputIntensityKey) - ключ определяет интенсивность фильта, для Монохрома не нужен
            
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    photoImage.image = processedImage
                }
            }
        }
        
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
