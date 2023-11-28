//
//  DetailsViewController.swift
//  ettemeneTask
//
//  Created by Mac on 27/11/23.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var detailsTableview: UITableView!
    @IBOutlet weak var headerImg: UIImageView!
    var agendList:AuthDetails?
    var passID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTableview.register(UINib(nibName: "LocationTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationTableViewCell")
        detailsTableview.register(UINib(nibName: "AgendaTableViewCell", bundle: nil), forCellReuseIdentifier: "AgendaTableViewCell")
        detailsTableview.register(UINib(nibName: "SpeakersTableViewCell", bundle: nil), forCellReuseIdentifier: "SpeakersTableViewCell")
        detailsTableview.register(UINib(nibName: "HyperLinkTableViewCell", bundle: nil), forCellReuseIdentifier: "HyperLinkTableViewCell")
        detailsTableview.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
        // Do any additional setup after loading the view.

    serviceForAgendasList()
}


func serviceForAgendasList(){
    let apiUrl = "http://eventowl.net:3680/demo_agenda_detail?sid=1&eid=1989&pid=117195&aid=\(passID)"
   
    getServicesData(generalType: AuthDetails.self, apiEndPoint: URL(string: apiUrl)!, method: "GET") { (payload, _) in
        
        print(payload)
        self.agendList = payload
        if let imageUrl = payload.imgPath {
            let urled = imageUrl + payload.data.headerImg
            let url = URL(string: urled)
            self.headerImg.sd_setImage(with: url, completed: nil)
        } else {
            self.headerImg.image = nil
        }
        self.detailsTableview.delegate = self
        self.detailsTableview.dataSource = self
        self.detailsTableview.reloadData()
    }
    }
    
//    postContent(path:URL(string:apiUrl )! , modelType: AuthModels.self, params: parameters, method: "POST") { (payload, _) in
//
//        print(payload)
        
   
//        self.listTableview.reloadData()
                  //  }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 1
        }else if section == 2{
            return agendList?.data.agendaSpeakers.count ?? 0
        }else if section == 3 || section == 4 || section == 5 || section == 6{
            return 1
        }else{
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 3{
//            let sectionHeaderBackgroundColor = UIColor(hue: 0.021, saturation: 0.34, brightness: 0.94, alpha: 0.4)
//            let sectionHeaderLabelView = UIView()
//            sectionHeaderLabelView.backgroundColor = .white
//
//            let sectionHeaderLabel = UILabel()
//            sectionHeaderLabel.text = "Speakers"
//            sectionHeaderLabel.textColor = .black
//            sectionHeaderLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
//            sectionHeaderLabel.frame = CGRect(x: 0, y: 0, width: 250, height: 40)
//            sectionHeaderLabelView.addSubview(sectionHeaderLabel)
//
//            return sectionHeaderLabelView
//        }else{
//            return nil
//        }
//
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let sectionCell = detailsTableview.dequeueReusableCell(withIdentifier: "AgendaTableViewCell", for: indexPath) as? AgendaTableViewCell
            else {
                fatalError("dequeuing issue")
            }
            sectionCell.imageUrls.append(Attendee(image: agendList?.data.agendaSpeakers[indexPath.row].image ?? "", companyName: agendList?.data.agendaSpeakers[indexPath.row].companyName ?? "", name: agendList?.data.agendaSpeakers[indexPath.row].name ?? ""))
            sectionCell.selectionStyle = .none
            sectionCell.headerTitleLbl.text = "\(agendList?.data.name ?? "")"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d"
            //let dateString = dateFormatter.string(from: agendaDataDict?.data![indexPath.item].startDate ?? Date())
            sectionCell.timeTitleLbl.text = "\(convertDateFormatter(date: (agendList?.data.startDate)!)) -  \(convertDateFormatter(date: (agendList?.data.endDate)!)) "
            return sectionCell
            
        }else if indexPath.section == 1{
            var locationCell = detailsTableview.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell
            let dateFormatter = DateFormatter()
            let dateString =  formattedDateFromString(dateString: "\(agendList?.data.startDate ?? "")", withFormat: "MMMM dd, yyyy")
            locationCell.dateLbl.text = dateString
            //let dateString = dateFormatter.string(from: agendaDataDict?.data![indexPath.item].startDate ?? Date())
            locationCell.timeslotLbl.text = "\(convertDateFormatter(date: (agendList?.data.startDate)!)) -  \(convertDateFormatter(date: (agendList?.data.endDate)!)) "
            locationCell.venueLbl.text = "\(String(describing: agendList?.data.locationName ?? ""))"
            locationCell.addressLbl.text = "\(convertDateFormatter(date: (agendList?.data.startDate)!)) -  \(convertDateFormatter(date: (agendList?.data.endDate)!)) "
            
            return locationCell
        }else if indexPath.section == 2{
            guard let sectionCell = detailsTableview.dequeueReusableCell(withIdentifier: "SpeakersTableViewCell", for: indexPath) as? SpeakersTableViewCell
            else {
                fatalError("dequeuing issue")
            }
            
            if indexPath.row == 0{
                //sectionCell.imageUrls.append(Attendee(image: agendList?.data.agendaSpeakers[indexPath.row].image ?? "", companyName: agendList?.data.agendaSpeakers[indexPath.row].companyName ?? "", name: agendList?.data.agendaSpeakers[indexPath.row].name ?? ""))
                sectionCell.selectionStyle = .none
                sectionCell.authorLbl.text = "\(agendList?.data.agendaSpeakers[indexPath.row].name ?? "")"
                sectionCell.companyLbl.text = "\(agendList?.data.agendaSpeakers[indexPath.row].companyName ?? "")"
                if let imageUrl = self.agendList?.data.agendaSpeakers[indexPath.row].image, let url = URL(string: imageUrl) {
                    sectionCell.speakerImg.sd_setImage(with: url, completed: nil)
                } else {
                    sectionCell.speakerImg.image = nil
                }
                
                
            }
            return sectionCell
        }else if indexPath.section == 3 {
            guard let sectionCell = detailsTableview.dequeueReusableCell(withIdentifier: "HyperLinkTableViewCell", for: indexPath) as? HyperLinkTableViewCell
            else {
                fatalError("dequeuing issue")
            }
            
           
                //sectionCell.imageUrls.append(Attendee(image: agendList?.data.agendaSpeakers[indexPath.row].image ?? "", companyName: agendList?.data.agendaSpeakers[indexPath.row].companyName ?? "", name: agendList?.data.agendaSpeakers[indexPath.row].name ?? ""))
                sectionCell.selectionStyle = .none
            if indexPath.row == 0{
                sectionCell.registerLbl.text = "Registration"
                sectionCell.hyperlinkBtn.accessibilityHint = "\(agendList?.data.registerLinks[indexPath.row].registerLink ?? "")"
                sectionCell.hyperlinkBtn.setTitle("\(agendList?.data.registerLinks[indexPath.row].registerText ?? "")",  for: UIControl.State.normal)
                sectionCell.hyperlinkBtn.addTarget(self, action: #selector(openLink(_:)), for: UIControl.Event.touchUpInside)
            }
            
            
            
            return sectionCell
        } else if  indexPath.section == 4{
            guard let sectionCell = detailsTableview.dequeueReusableCell(withIdentifier: "HyperLinkTableViewCell", for: indexPath) as? HyperLinkTableViewCell
            else {
                fatalError("dequeuing issue")
            }
                sectionCell.registerLbl.text = "Documents"
                sectionCell.hyperlinkBtn.accessibilityHint = "\(agendList?.data.agendaDocuments[indexPath.row].documentFile ?? "")"
                sectionCell.hyperlinkBtn.setTitle("\(agendList?.data.agendaDocuments[indexPath.row].documentName ?? "")",  for: UIControl.State.normal)
                sectionCell.hyperlinkBtn.addTarget(self, action: #selector(openLink(_:)), for: UIControl.Event.touchUpInside)
             return sectionCell
        }else if indexPath.section == 5{
            guard let sectionCell = detailsTableview.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as? DescriptionTableViewCell
            else {
                fatalError("dequeuing issue")
            }
            let htmlString = "\(agendList?.data.description ?? "")"
            sectionCell.logoImg.isHidden = true
            sectionCell.descriptionLbl.text = "Description"
                   // Convert HTML to attributed string
            if let attributedText = htmlString.attributedHtmlString {
                 // "hello \n\nworld\n"
                sectionCell.htmlTextView.attributedText = attributedText
            }
           
            
            return sectionCell
        }else if indexPath.section == 6{
            guard let sectionCell = detailsTableview.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as? DescriptionTableViewCell
            else {
                fatalError("dequeuing issue")
            }
            sectionCell.descriptionLbl.text = "Sponser Name"
            sectionCell.htmlTextView.isHidden = true
            sectionCell.logoImg.isHidden = false
            if let imageUrl = agendList?.imgPath {
                let urled = imageUrl + agendList!.data.sponsorImg
                let url = URL(string: urled)
                sectionCell.logoImg.sd_setImage(with: url, completed: nil)
            } else {
                sectionCell.logoImg.image = nil
            }
            
            return sectionCell
        }
        
        else{
            return UITableViewCell()
        }
    }
    
    @objc func openLink(_ sender: UIButton){
        let section = sender.accessibilityHint
        guard let url = URL(string: "\(String(describing: section ?? ""))") else { return }
        UIApplication.shared.open(url)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 180
        }else if indexPath.section == 1{
            return 225
        }else if indexPath.section == 2{
            return 100
        }else if indexPath.section == 5 || indexPath.section == 6{
            return 200
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

