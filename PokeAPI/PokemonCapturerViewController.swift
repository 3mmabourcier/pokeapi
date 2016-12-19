//
//  PokemonCapturerViewController.swift
//  PokeAPI
//
//  Created by Etudiant on 16-12-19.
//  Copyright © 2016 Etudiant. All rights reserved.
//

import UIKit

class PokemonCapturerViewController: UIViewController {
    
    var lePokemon = Dictionary<String,Any>()
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var type1: UIImageView!
    @IBOutlet weak var type2: UIImageView!
    @IBOutlet weak var chNom: UILabel!
    @IBOutlet weak var chNo: UILabel!
    @IBOutlet weak var chAbility: UILabel!
    @IBOutlet weak var chWeight: UILabel!
    @IBOutlet weak var chHeight: UILabel!
    
    @IBAction func btRetour(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        afficherLesInfos(lesInfos: lePokemon)
        
        // Do any additional setup after loading the view.
    }
    
    func afficherLesInfos(lesInfos:Dictionary<String,Any> ){
        //AFFICHE LES INFO
        if let _nom = lesInfos["name"] as? String {
            nom.text = "\(_nom)"
            chNom.text = "\(_nom)"
        }
        if let _id = lesInfos["id"] as? Int {
            if(_id<10000){
                chNo.text = "\(_id)"
            }else{
                chNo.text = "None"
            }
        }
        
        if let _weight = lesInfos["weight"] as? String {
            chWeight.text = "\(_weight)"
        }
        if let _height = lesInfos["height"] as? String {
            chHeight.text = "\(_height)"
        }
        if let _abilities = lesInfos["abilities"] as? Array<Dictionary<String,Any>> {
            if let _ability = _abilities[0]["ability"] as? Dictionary<String,String>{
                if let _abilityName = _ability["name"]{
                    chAbility.text = "\(_abilityName)"
                }
            }
        }
        //////// CHANGER LES NOM DE TYPEPAGES-LETYPEpng
        if let _lesTypes = lesInfos["types"] as? Array<Dictionary<String,Any>>{
            for type in _lesTypes{
                
                let _leType = type["type"] as? Dictionary<String,String>
                let _num = type["slot"] as? Int
                if let _nomType = _leType?["name"] as String!{
                    if(_lesTypes.count>=2){
                        if(_num==1){
                            type1.image = maskImage(image: UIImage(named: "typesPage-\(_nomType).png")!, mask: UIImage(named: "masque.png")!)
                        }else{
                            type2.image = UIImage(named:"typesPage-\(_nomType).png")
                        }
                    }else{
                        type1.image = UIImage(named:"typesPage-\(_nomType).png")
                    }
                    
                }
                
            }
        }
        
    }
    
    func maskImage(image:UIImage, mask:(UIImage))->UIImage{
        
        let imageReference = image.cgImage
        let maskReference = mask.cgImage
        
        let imageMask = CGImage(maskWidth: maskReference!.width,
                                height: maskReference!.height,
                                bitsPerComponent: maskReference!.bitsPerComponent,
                                bitsPerPixel: maskReference!.bitsPerPixel,
                                bytesPerRow: maskReference!.bytesPerRow,
                                provider: maskReference!.dataProvider!, decode: nil, shouldInterpolate: true)
        
        let maskedReference = imageReference!.masking(imageMask!)
        
        let maskedImage = UIImage(cgImage:maskedReference!)
        
        return maskedImage
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
