//
//  ViewController.swift
//  PokeAPI
//
//  Created by Etudiant on 16-11-24.
//  Copyright © 2016 Etudiant. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UITableViewDataSource, typeChoisiDelegate, CapturerDelegate  {
    
    var UrlPokemon = "https://pokeapi.co/api/v2/type/1"
    var RequeteUrl = URL(string: "")
    var pokemonUrlList = Array<Dictionary<String, String>>()
    var pokemonAfficherUrlList = Array<Dictionary<String, String>>()
    var pokemonList = Dictionary<String,Dictionary<String, Any>>()
    var pokemonImgList = Dictionary<String,UIImage>()
    var capturedList = Dictionary<String,Bool>()
    var nbCapture = 0;
    let limit = 1000
    var etatBtCap = false
    
    
    @IBOutlet weak var btCapture: UIButton!
    
    @IBOutlet weak var monTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monTableView.reloadData()
        returnTypeUrl(info: UrlPokemon)
        
    }
    
    
    func returnTypeUrl(info: String) {
        UrlPokemon = info 
        print("le url de type \(info)")
        RequeteUrl = URL(string: UrlPokemon)!
        getPokemonListFromTypeUrl(leUrl: RequeteUrl!)//recherche de donné selon le url en paramêtre
    }
    
    func envoieDuType(info:String){
        print("les infos de type\(info)")
        pokemonUrlList = Array<Dictionary<String, String>>()
        returnTypeUrl(info: info)
        monTableView.reloadData()//réception du type du VC type et changement des donné
        
        
    }
    
    func envoieDuLaCapture(info: String) {
        capturedList[info] = true
        monTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showType"{//segue vers les type
            let vcType:listeTypeViewController = segue.destination as! listeTypeViewController
            vcType.delegate = self
        }else if segue.identifier == "showPokemon"{//autres segue (vers pokemon et pokemonCapturer)
            //print("Autre segue\()")
                let laCell = sender as! PokemonTableViewCell

                    if let leNom = laCell.champNom.text{
                        print("le nom sur click\(leNom)")
                            let vcPokemon:PokemonViewController = segue.destination as! PokemonViewController
                            vcPokemon.delegate = self
                            if let lesInfos = pokemonList[leNom]{
                                vcPokemon.lePokemon = lesInfos
                            }
                    }
            
        }else if segue.identifier == "showPokemonCapturer"{//segue vers le pokemon
            let laCell = sender as! PokemonTableViewCell
            print("Show pokemon capturer go")
            if let leNom = laCell.champNom.text{
            
                let vcPokemon:PokemonCapturerViewController = segue.destination as! PokemonCapturerViewController
                if let lesInfos = pokemonList[leNom]{
                    vcPokemon.lePokemon = lesInfos
                }
            }
            
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {//vérification si possible de faire le segue
        print("should?")
        if let ident = identifier {
            if(ident == "showPokemon"){
                let laCell = sender as! PokemonTableViewCell
                if let leNom = laCell.champNom.text{
                    print("ident3")
                    if let pokemon = pokemonList[leNom]{
                        print("ident4")
                        ////////Revoir la condition
                    }else{
                        print("should not")
                        return false
                    }
                }// empêche de continuer sur la page d'un pokemon singulier si les infos ne sont pas chargé.
                //monTableView.reloadRows(at: [monTableView.indexPathForSelectedRow! as IndexPath], with: UITableViewRowAnimation(rawValue: 0)!)// reload la cellule cliqué si elle a fini de chargé.
                 monTableView.reloadData()
            }
        }
            
        
        return true
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemonAfficherUrlList = Array<Dictionary<String , String>>()
        if etatBtCap{//si le bouton capturer montre l'état true, seulement les pokémon capturé son affiché
            for pokemon in pokemonUrlList{
                if let leId = pokemon["name"]{
                    if let leBool = capturedList[leId]{
                        if(leBool){
                            pokemonAfficherUrlList.append(pokemon)
                        }
                    }
                }
            }
        }else{//sinon tout les pokémon dans la list de url du type choisi sont montré
            pokemonAfficherUrlList = pokemonUrlList
        }
        return pokemonAfficherUrlList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        //initie la cellulle
        
        let _id = pokemonAfficherUrlList[indexPath.row]["name"]! as String//cherche le id dans la liste
        var uneCell:PokemonTableViewCell
        if let _cap = capturedList[_id] as Bool!{
            if (_cap){// si le pokemon est capturé associé choisi une cellule avec un identifiant différent
                uneCell = tableView.dequeueReusableCell(withIdentifier: "PokemonCapture") as! PokemonTableViewCell
                print("Captured 1 \(capturedList[_id])")
            }else{// sinon le po
                uneCell = tableView.dequeueReusableCell(withIdentifier: "Pokemon") as! PokemonTableViewCell
                
            }
        }else{//si la variable de capture n'existe pas? crée la variable et à false de base
            capturedList[_id] = false
            uneCell = tableView.dequeueReusableCell(withIdentifier: "Pokemon") as! PokemonTableViewCell
        }

        
        if let lePokemon = self.pokemonList[_id]{//si les info son stocker en variable?
            if (!lePokemon.isEmpty){//si les info ne sont pas vide
                afficherLesInfos(lesInfos: lePokemon, laCellulle: uneCell, leId: _id)//afficher le info et image dans la cellule
                self.afficherLesImages(lesInfos: (self.pokemonList[_id])!, laCellulle: uneCell, lesImg: self.pokemonImgList, leId: _id)
            }else{//sinon afficher la cellule de loading
                afficherLoading(laCellulle: uneCell)
                print("loading en cours\(_id)")
            }
        }else{// si les info n'existe pas?
            //RECHERCHE DES INFO
            if let _url = self.pokemonAfficherUrlList[indexPath.row]["url"] as String! {//rechercher selon le url
                afficherLoading(laCellulle: uneCell)//affiche la cellule de loading
                self.pokemonList[_id] = Dictionary<String,Any>()//prépare le tableau vide pour évité les requête double
                DispatchQueue.global().async {
                    self.getPokemonFromUrl(leUrl: URL(string: _url)!, idPath:indexPath)
                }
            }
        }
        return uneCell
        
    }
    func afficherLoading(laCellulle:PokemonTableViewCell){
        //AFFICHE LES INFO DE LOADING
        laCellulle.champNom.text = "Loading"
        laCellulle.champId.text = "???"
        laCellulle.img.image = UIImage(named: "pokemonSubstitute100x100.png")
        laCellulle.bgType.image = UIImage(named: "listeType-unknown.png")
        
    }

    func afficherLesInfos(lesInfos:Dictionary<String,Any>, laCellulle:PokemonTableViewCell, leId:String){
        //AFFICHE LES INFOs
        if let _nom = lesInfos["name"] as? String {
            laCellulle.champNom.text = "\(_nom)"
        }
        if let _id = lesInfos["id"] as? Int {
            if(_id<10000){
                laCellulle.champId.text = "\(_id)"
            }
        }
        //change le Background selon le type primaire du pokemon
        if let _lesTypes = lesInfos["types"] as? Array<Dictionary<String,Any>>{
            for type in _lesTypes{
                let _leType = type["type"] as? Dictionary<String,String>
                if let _nomType = _leType?["name"] as String!{
                    laCellulle.bgType.image = UIImage(named: "listeType-\(_nomType).png")
                }
                
            }
        }
        
    }

    func afficherLesImages(lesInfos:Dictionary<String,Any>,laCellulle:PokemonTableViewCell,
        lesImg:Dictionary<String,UIImage>, leId:String){
        
        if let uneIMG = lesImg[leId]{//si l'image est déja chargé affiche la
            laCellulle.img.image = uneIMG
        }else{//sinon faire une requête
            
            if let _liens = lesInfos["sprites"] as? Dictionary<String,Any> {
                print("Liens trouvé")
                if let _lien = _liens["front_default"] as? String{
                    let _url = URL(string: _lien)
                        if let _data = NSData(contentsOf: _url!) as? Data {
                            let _img = UIImage(data: _data)
                            self.pokemonImgList[leId] = _img!
                            laCellulle.img.image = _img
                        }
                }
            }else{//si la requête fail, retour à l'image par défault
                laCellulle.img.image = UIImage(named: "pokemonSubstitute100x100.png")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPokemonListFromTypeUrl(leUrl : URL) {
        /// DispatchQueue.main.async ( execute: {
        
        //recherche de donné selon le type choisie
        if let _données = NSData(contentsOf: leUrl) as? Data {
            do {
                let json = try JSONSerialization.jsonObject(with: _données, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                
                print("Reception Json des liens")
                //print(json)
                var laList = Array<Dictionary<String, String>>()
                
                //memorise les liens dans un dictionaire dont la clé est leur nom
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
        //requête de donné d'un pokemon spécifique
        //appellé pour les pokémon affiché seulement
        if let _données = NSData(contentsOf: leUrl) as? Data {
                do {
                    let json = try JSONSerialization.jsonObject(with: _données, options: JSONSerialization.ReadingOptions()) as? Dictionary<String, Any>
                    
                    let id = json?["name"] as! String
                    print("Conversion JSON du \(id)")
                    self.pokemonList[id] = ( json as Dictionary<String, Any>!)
                    //reload la cellule une fois les information chargé
                    if(!etatBtCap){ //ne va pas essayer d'afficher des thread qui ne sont plus afficher lorque le tri est pour les pokemon capturé
                        self.monTableView.reloadRows(at: [idPath], with: UITableViewRowAnimation(rawValue: 0)!)
                    }
                
                } catch {
                    print("\n\n#Erreur: Problème de conversion json:\(error)\n\n")
                } // do/try/catch
            } else
            {
                print("\n\n#Erreur: impossible de lire les données via:\(leUrl.absoluteString)\n\n")
            } // if let _données = NSData
    }
    
    
    @IBAction func rechercheCapture(_ sender: AnyObject) {
        etatBtCap = !etatBtCap
        
        if etatBtCap{//change l'état du bouton
            btCapture.setBackgroundImage(UIImage(named:"interface-13.png"), for: .normal )
        }else{
            btCapture.setBackgroundImage(UIImage(named:"interface-14.png"), for: .normal )
        }
        //reload le tableau pour afficher ce qui doit l'être selon l'état du bt
        monTableView.reloadData()
    }
    
    

    
    
}

