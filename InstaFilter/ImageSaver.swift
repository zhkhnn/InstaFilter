//
//  ImageSaver.swift
//  InstaFilter
//
//  Created by Aruzhan Zhakhan on 29.09.2023.
//

import Foundation
import UIKit

class ImageSaver: NSObject{
    var successHandler: (()-> Void)?
    var errorHandler: ((Error)-> Void)?
    
    func writeToAlbum(image: UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error{
            errorHandler?(error)
        }else {
            successHandler?()
        }
    }
}
