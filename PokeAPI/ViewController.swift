//
//  ViewController.swift
//  PokeAPI
//
//  Created by Etudiant on 16-11-24.
//  Copyright © 2016 Etudiant. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, TypeViewDelegate {
    var UrlPokemon = "https://pokeapi.co/api/v2/type/1"
    var RequeteUrl = URL(string: "")
    var pokemonUrlList = Array<Dictionary<String, String>>()
    var pokemonList = Dictionary<String,Dictionary<String, Any>>()
    var pokemonImgList = Dictionary<String,UIImage>()
    var capturedList = Dictionary<String,Bool>()
    var nbCapture = 0;
    let limit = 1000
    var etatBtCap = false
    
    @IBOutlet weak var btCapture: UIButton!
    
    @IBOutlet weak var monTableView: UITableView!


    @IBAction func goToType(_ sender: AnyObject) {
        let viewType = listeTypeViewController()
        viewType.delegate = self
        self.present(viewType, animated: true)
    }
    func returnTypeUrl(info: String) {
        UrlPokemon = info
        print("le url de type \(info)")
        RequeteUrl = URL(string: UrlPokemon)!
        getPokemonListFromTypeUrl(leUrl: RequeteUrl!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Voir tester silouette
        /*//http://stackoverflow.com/questions/32538700/outline-path-of-a-image-silhouette-in-swift
         */
        //let UrlPokemon = "https://pokeapi.co/api/v2/pokemon/?limit=\(limit)"
        
        RequeteUrl = URL(string: UrlPokemon)!
        getPokemonListFromTypeUrl(leUrl: RequeteUrl!)
        
        
        //getPokemonListFromUrl(leUrl: DepartUrl)
        
        //print(pokemonUrlList)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Le count \(pokemonUrlList.count)")
        var count = pokemonUrlList.count
        if etatBtCap{
            for pokemon in pokemonUrlList{
                if let leId = pokemon["name"]{
                    if let leBool = capturedList[leId]{
                        if(leBool){
                            count += 1
                        }
                    }
                }
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let _id = pokemonUrlList[indexPath.row]["name"]! as String
        var uneCell:PokemonTableViewCell
        if let _cap = capturedList[_id] as Bool!{
            if (_cap){
                uneCell = tableView.dequeueReusableCell(withIdentifier: "PokemonCapture") as! PokemonTableViewCell
                print("Captured 1 \(capturedList[_id])")
            }else{
                uneCell = tableView.dequeueReusableCell(withIdentifier: "Pokemon") as! PokemonTableViewCell
                
            }
        }else{
            capturedList[_id] = false
            uneCell = tableView.dequeueReusableCell(withIdentifier: "Pokemon") as! PokemonTableViewCell
        }

        
        if let lePokemon = self.pokemonList[_id]{
            if (!lePokemon.isEmpty){
            afficherLesInfos(lesInfos: lePokemon, laCellulle: uneCell, leId: _id)
            self.afficherLesImages(lesInfos: (self.pokemonList[_id])!, laCellulle: uneCell, lesImg: self.pokemonImgList, leId: _id)
            }else{
                afficherLoading(laCellulle: uneCell)
                print("loading en cours\(_id)")
            }
        }else{
            //RECHERCHE DES INFO
            if let _url = self.pokemonUrlList[indexPath.row]["url"] as String! {
                //TODO:
                afficherLoading(laCellulle: uneCell)
                self.pokemonList[_id] = Dictionary<String,Any>()
                DispatchQueue.global().async {
                    self.getPokemonFromUrl(leUrl: URL(string: _url)!, idPath:indexPath)
                }
                //self.afficherLesInfos(lesInfos: (pokemonList[_id])!, laCellulle: uneCell, leId: _id)
                //self.afficherLesImages(lesInfos: pokemonList[_id], laCellulle: uneCell, lesImg: pokemonImgList, leId: _id)
            }
        }
        return uneCell
        
    }
    func afficherLoading(laCellulle:PokemonTableViewCell){
        //AFFICHE LES INFO
        laCellulle.champNom.text = "Loading"
        laCellulle.champId.text = "???"
        laCellulle.img.image = UIImage(named: "loading.gif")
        laCellulle.bgType.image = UIImage(named: "listeType-unknown.png")
        
    }

    func afficherLesInfos(lesInfos:Dictionary<String,Any>, laCellulle:PokemonTableViewCell, leId:String){
        //AFFICHE LES INFO
        if let _nom = lesInfos["name"] as? String {
            laCellulle.champNom.text = "\(_nom)"
        }
        if let _id = lesInfos["id"] as? Int {
            if(_id<10000){
                laCellulle.champId.text = "\(_id)"
            }
        }
        
        //////// CHANGER LES NOM DE TYPEPAGES-LETYPEpng
        if let _lesTypes = lesInfos["types"] as? Array<Dictionary<String,Any>>{
            for type in _lesTypes{
                
                let _leType = type["type"] as? Dictionary<String,String>
                let _num = type["slot"] as? Int
                if let _nomType = _leType?["name"] as String!{
                    laCellulle.bgType.image = UIImage(named: "listeType-\(_nomType).png")
                    if(_lesTypes.count>=2){
                        if(_num==1){
                            //laCellulle.type1.image = maskImage(image: UIImage(named: "typesPage-\(_nomType).png")!, mask: UIImage(named: "masque.png")!)
                        }else{
                            //laCellulle.type2.image = UIImage(named:"typesPage-\(_nomType).png")
                        }
                    }else{
                        //laCellulle.type1.image = UIImage(named:"typesPage-\(_nomType).png")
                    }
                    
                }
                
            }
        }
        
        }

    func afficherLesImages(lesInfos:Dictionary<String,Any>,laCellulle:PokemonTableViewCell, lesImg:Dictionary<String,UIImage>, leId:String){
        if let uneIMG = lesImg[leId]{
            laCellulle.img.image = uneIMG
        }else{
            if let _liens = lesInfos["sprites"] as? Dictionary<String,Any> {
                print("Liens trouvé")
                laCellulle.img.image = UIImage(named: "1.png")
                if let _lien = _liens["front_default"] as! String!{
                    let _url = URL(string: _lien)
                        if let _data = NSData(contentsOf: _url!) as? Data {
                            let _img = UIImage(data: _data)
                            self.pokemonImgList[leId] = _img!
                            laCellulle.img.image = _img
                        }
                }
            }else{
                laCellulle.img.image = UIImage(named: "1.png")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*func getPokemonListFromUrl(leUrl : URL) {
        
        /// DispatchQueue.main.async ( execute: {
        if let _données = NSData(contentsOf: leUrl) as? Data {
            do {
                let json = try JSONSerialization.jsonObject(with: _données, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                
                print("Reception Json des liens")
                //print(json)
                self.pokemonUrlList = json?["results"] as! Array<Dictionary<String, String>>
                //return json!
            } catch {
                print("\n\n#Erreur: Problème de conversion json:\(error)\n\n")
            } // do/try/catch
        } else
        {
            print("\n\n#Erreur: impossible de lire les données via:\(leUrl.absoluteString)\n\n")
        } // if let _données = NSData
        
        /// }) // DispatchQueue.main.async
    }*/
    
    func getPokemonListFromTypeUrl(leUrl : URL) {
        /// DispatchQueue.main.async ( execute: {
        if let _données = NSData(contentsOf: leUrl) as? Data {
            do {
                let json = try JSONSerialization.jsonObject(with: _données, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                
                print("Reception Json des liens")
                //print(json)
                var laList = Array<Dictionary<String, String>>()
                for pokemon in json?["pokemon"] as! Array<Dictionary<String, Any>>{
                    laList.append(pokemon["pokemon"] as! [String : String])
                }
                self.pokemonUrlList = laList
                //return json!
            } catch {
                print("\n\n#Erreur: Problème de conversion json:\(error)\n\n")
            } // do/try/catch
        } else
        {
            print("\n\n#Erreur: impossible de lire les données via:\(leUrl.absoluteString)\n\n")
        } // if let _données = NSData
        
        /// }) // DispatchQueue.main.async
    }
    
    func getPokemonFromUrl(leUrl : URL, idPath: IndexPath) {
        if let _données = NSData(contentsOf: leUrl) as? Data {
                do {
                    let json = try JSONSerialization.jsonObject(with: _données, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                    
                    let id = json?["name"] as! String
                    print("Conversion JSON du \(id)")
                    self.pokemonList[id] = ( json as Dictionary<String, Any>!)
                    self.monTableView.reloadRows(at: [idPath], with: UITableViewRowAnimation(rawValue: 0)!)
                 //   print(self.pokemonList[id] as Dictionary<String, Any>!))
                
                } catch {
                    print("\n\n#Erreur: Problème de conversion json:\(error)\n\n")
                } // do/try/catch
            } else
            {
                print("\n\n#Erreur: impossible de lire les données via:\(leUrl.absoluteString)\n\n")
            } // if let _données = NSData
    }
    
    func pressed(sender: UIButton!) {
        
    }
    
    @IBAction func rechercheCapture(_ sender: AnyObject) {
        etatBtCap = !etatBtCap
        
        if etatBtCap{
            btCapture.setBackgroundImage(UIImage(named:"interface-13.png"), for: .normal )
        }else{
            btCapture.setBackgroundImage(UIImage(named:"interface-14.png"), for: .normal )
        }
        monTableView.reloadData()
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

    
    
}

