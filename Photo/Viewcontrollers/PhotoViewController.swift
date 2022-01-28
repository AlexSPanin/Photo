//
//  PhotoViewController.swift
//  Photo
//
//  Created by Александр Панин on 27.01.2022.
//
import CoreImage
import UIKit

// MARK: - type source
enum TypeSource {
    case camera
    case gallary
}

class PhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var photoImage: UIImageView!
    
    var imagePhoto: UIImagePickerController! // инициализация UIImagePickerController для работы с камерой и галлереей
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePhoto = UIImagePickerController() // инициализировали контролер
        imagePhoto.delegate = self // указываем что здесь будем использовать методы делегата_ type:
    }
    
    @IBAction func gallaryButton(_ sender: Any) {
        fetchImage(.gallary)
    }
    
    @IBAction func photoButton(_ sender: Any) {
        fetchImage(.camera)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let image = photoImage.image!
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool { print("Yes")}
        }
        present(shareController, animated: true, completion: nil)
    }
    
    //MARK: -  действия после окончания работы встроенных вью контроллеров
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // проверка какое фото используем, едактируемое или оригинальное
        if let image = info[.editedImage] as? UIImage {
            imageFilter(image)
        } else {
            guard  let image = info[.originalImage] as? UIImage else { return }
            imageFilter(image)
        }
        // выключение встроенного вью контроллера
        imagePhoto.dismiss(animated: true, completion: nil)
    }
}

extension PhotoViewController {
    
    // MARK: - применение фильтра и вывод изображения во вью
    private func imageFilter(_ image: UIImage) {
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
    
    // MARK: - получение изображения в зависимости от типа
    private func fetchImage(_ type: TypeSource) {
        switch type {
        case .camera:
            imagePhoto.sourceType = .camera
            imagePhoto.cameraDevice = .front
        case .gallary:
            imagePhoto.sourceType = .photoLibrary // указываем что используем
        }
        imagePhoto.allowsEditing = true // разрешение редактирования встроенными методами
        imagePhoto.modalPresentationStyle = .pageSheet // вид представления встроенных инструментов
        present(imagePhoto, animated: true, completion: nil) // запуск контроллера
    }
}
