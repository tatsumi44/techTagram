//
//  ViewController.swift
//  Swift4Photo
//
//  Created by tatsumi kentaro on 2018/02/06.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Accounts

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    var originalIamgeView: UIImage!
    
    var filter:CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //カメラを使用するときのメソット
    @IBAction func cameraUse() {
        //カメラが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
    }
    //読み込んだ画像を実際に描画
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        originalIamgeView = imageView.image
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func AlbumUse(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
    }
    //表示画像にフィルターをかける
    @IBAction func filterUse(_ sender: Any) {
        let filterImage: CIImage = CIImage(image: originalIamgeView)!
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        //彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        //明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        imageView.image = UIImage(cgImage:cgImage!)
    
    }
    @IBAction func shareUse(_ sender: Any) {
        let shareText = "加工できた！"
        let shareImage = imageView.image!
        let activityItem:[Any] = [shareText,shareImage]
        let activityController = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
        let exculudedActivityType = [UIActivityType.postToWeibo,.saveToCameraRoll,.print]
        activityController.excludedActivityTypes = exculudedActivityType
        present(activityController, animated: true, completion: nil)
        
    }
    @IBAction func saveUse(_ sender: Any) {
        
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
    }
    
    

}

