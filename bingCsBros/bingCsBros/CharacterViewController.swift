//
//  CharacterViewController.swift
//  bingCsBros
//
//  Created by Theresa Gundel on 4/21/21.
//

import UIKit

class CharacterViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var img: UIImage?
    var circlePath = UIBezierPath()
    
    @IBOutlet var displayImg: UIImageView!
    @IBOutlet var customButton: UIButton!
    @IBOutlet var defaultButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        
        self.img = UIImage(named: "baxter")
        self.displayImg.image = self.img
        self.displayImg.setNeedsDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    @IBAction func clickedCustomize(button: UIButton){
        prepCamera()
    }
    
    @IBAction func clickedDefault(button: UIButton){
        self.img = UIImage(named: "baxter")
        self.displayImg.image = self.img
        self.displayImg.setNeedsDisplay()
    }
    
    func prepCamera(){

        let vc = UIImagePickerController()
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            present(vc, animated: true)
        }
        else {
            self.img = UIImage(named:"baxter")
            self.displayImg.image = self.img
            self.displayImg.setNeedsDisplay()
        }
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        //now image is the photo we just took
        self.img = image
        //call a func to actually use this img
        createCharImg()
    }
    
    func createCharImg(){
        //crop self.img to be a circle
        makeRoundImg()
        //combine this image with a stick figure with no head
        let bottomImage = UIImage(named: "baxter")
        let topImage = self.img
        
        let size = CGSize(width: 100, height: 150)
        //UIGraphicsBeginImageContextWithOptions(size, false, 1) //make it transparent?
        UIGraphicsBeginImageContext(size)

        var areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        bottomImage!.draw(in: areaSize)
        areaSize = CGRect(x: size.width/7, y: 5, width: size.width*(0.7), height: size.height*(0.55))
        topImage!.draw(in: areaSize, blendMode: .normal, alpha: 1.0)

        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //display character image on screen for approval - ?
        self.displayImg.image = newImage
        self.displayImg.setNeedsDisplay()
        
        self.img = newImage
        //save to assets to use  in the game
    }

    func makeRoundImg(){
        let imgP = UIImageView(image: self.img)
        let imgLayer = CALayer()
        imgLayer.frame = imgP.bounds
        imgLayer.contents = imgP.image?.cgImage
        imgLayer.masksToBounds = true
        imgLayer.cornerRadius = (self.img?.size.width)!/2

        UIGraphicsBeginImageContext(imgP.bounds.size)
        imgLayer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.img = roundedImage
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "characterToGame") {
            let game:GameViewController = segue.destination as!GameViewController
            game.characterImage = self.img
        }
    }
    

}
