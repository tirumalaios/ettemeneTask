//
//  ViewController.swift
//  ettemeneTask
//
//  Created by Mac on 27/11/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var agendLbl: UILabel!
    
    @IBOutlet weak var agendaImg: UIImageView!
    var dates: [Date] = [/* your date objects */]
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    var agendaDataDict:AuthModels?
    @IBOutlet weak var listTableview: UITableView!
    
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableview.register(UINib(nibName: "AgendaTableViewCell", bundle: nil), forCellReuseIdentifier: "AgendaTableViewCell")
        calenderCollectionView.register(UINib(nibName: "ClockCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ClockCollectionViewCell")
        listTableview.delegate = self
        listTableview.dataSource = self
        calenderCollectionView.delegate = self
        calenderCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        calenderCollectionView.collectionViewLayout = layout
        serviceForAgendas()
    }
    
    
    func serviceForAgendas(){
        let apiUrl = "http://eventowl.net:3680/demo_agneda_list"
        
        let parameters:[String:Any] = ["pid":"117195", "eid":"1989"]
        postContent(path:URL(string:apiUrl )! , modelType: AuthModels.self, params: parameters, method: "POST") { (payload, _) in
            
            print(payload)
            
            self.agendaDataDict = payload
            self.agendLbl.text = self.agendaDataDict?.cmd ?? ""
            self.agendaImg.clipsToBounds = true
            self.agendaImg.layer.cornerRadius = self.agendaImg.frame.height/2
            if let imageUrl = self.agendaDataDict?.data?.first?.attendees.first?.image, let url = URL(string: imageUrl) {
                self.agendaImg.sd_setImage(with: url, completed: nil)
            } else {
                self.agendaImg.image = nil
            }
            self.listTableview.reloadData()
        }
    }
    

    
       
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return agendaDataDict?.data?[section].attendees.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let sectionCell = listTableview.dequeueReusableCell(withIdentifier: "AgendaTableViewCell", for: indexPath) as? AgendaTableViewCell
                    else {
                        fatalError("dequeuing issue")
                }
            sectionCell.imageUrls = (agendaDataDict?.data![indexPath.row].attendees)!
            sectionCell.selectionStyle = .none
            sectionCell.headerTitleLbl.text = "\(agendaDataDict?.data?[indexPath.row].name ?? "")"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d"
           //let dateString = dateFormatter.string(from: agendaDataDict?.data![indexPath.item].startDate ?? Date())
            sectionCell.timeTitleLbl.text = "\(convertDateFormatter(date: (agendaDataDict?.data![indexPath.item].startDate)!)) -  \(convertDateFormatter(date: (agendaDataDict?.data![indexPath.item].endDate)!)) "
           
            return sectionCell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        home.modalPresentationStyle = .fullScreen
        home.passID = "\(agendaDataDict?.data?[indexPath.row].id ?? 0)"
        present(home, animated: true)
    }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return dates.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClockCollectionViewCell", for: indexPath) as! ClockCollectionViewCell
            
            // Configure the cell with the date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d"
            let dateString = dateFormatter.string(from: dates[indexPath.item])
            cell.dateLbl.text = dateString
            return cell
        }
        
    }

extension UIViewController{
    
    public func convertDateFormatter(date: String) -> String {

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    //dateFormatter.locale = Locale(identifier: "your_loc_id")
    let convertedDate = dateFormatter.date(from: date)

    guard dateFormatter.date(from: date) != nil else {
        assert(false, "no date from string")
        return ""
    }
    dateFormatter.dateFormat = "HH:mm a"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let timeStamp = dateFormatter.string(from: convertedDate!)
    print(timeStamp)
    return timeStamp
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    func postContent<T>(path: URL, modelType: T.Type, params: [String: Any] = [:],method:String, completion: @escaping (_ : T, _ : HTTPURLResponse) -> Void) where T : Decodable {
        request(path: path, method: method, bodyData: params) { (data, httpResponse) in
            do {
                //                     self.data = data
                let decodedResponse = try JSONDecoder().decode(modelType, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse, httpResponse)
                }
            }
            catch {
                print("Error for URL: \(httpResponse.url?.absoluteString ?? "") in decoding the response: ", error)
                print(httpResponse)
                if let httpResponse = httpResponse as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    let statusMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    
                    print("Status Code: \(statusCode)")
                    print("Status Message: \(statusMessage)")
                    
                }
                
            }
        }
    }
    
    func request(path: URL, method: String, bodyData: [String: Any] = [:], completionHandler: @escaping (_: Data, _: HTTPURLResponse) -> Void) {
        guard let url = URL(string: path.absoluteString) else { return }
        
        // TODO: Set IsInCanada flag
        // request.setValue(1, forHTTPHeaderField: "x-canada-filter")
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if !bodyData.isEmpty {
            let jsonData = try? JSONSerialization.data(withJSONObject: bodyData)
            request.httpBody = jsonData
        }
        print(request)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Client Error: \(error.localizedDescription)")
                // CustomLoader.shared.hide()
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                // CustomLoader.shared.hide()
                print("Response Error: \(response!)")
                return
            }
            guard let data = data else { return }
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            if path.absoluteString.contains("/api/job/create-payment-intent") {
                // paymentIntent = data
            }
            completionHandler(data, httpResponse)
            
        }.resume()
        
    }
    
    func requestGET(path: URL, method: String,  completionHandler: @escaping (_: Data, _: HTTPURLResponse) -> Void) {
        guard let url = URL(string: path.absoluteString) else { return }
        
      
        
        // TODO: Set IsInCanada flag
        // request.setValue(1, forHTTPHeaderField: "x-canada-filter")
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        print(request)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Client Error: \(error.localizedDescription)")
                // CustomLoader.shared.hide()
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                // CustomLoader.shared.hide()
                print("Response Error: \(response!)")
                return
            }
            guard let data = data else { return }
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            if path.absoluteString.contains("/api/job/create-payment-intent") {
                // paymentIntent = data
            }
            completionHandler(data, httpResponse)
            
        }.resume()
        
    }
    
   
    
     func getServicesData<T>(generalType: T.Type,apiEndPoint:URL, method:String,  completionHandler:  @escaping (_ : T, _ : HTTPURLResponse) -> Void) where T : Decodable {
        requestGET(path: apiEndPoint, method: method) { (data, httpResponse) in
            do {
                //                     self.data = data
                let decodedResponse = try JSONDecoder().decode(generalType, from: data)
                DispatchQueue.main.async {
                    completionHandler(decodedResponse, httpResponse)
                }
            }
            catch {
                print("Error for URL: \(httpResponse.url?.absoluteString ?? "") in decoding the response: ", error)
                print(httpResponse)
                if let httpResponse = httpResponse as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    let statusMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    
                    print("Status Code: \(statusCode)")
                    print("Status Message: \(statusMessage)")
                    
                }
                
            }
        }
    }
    
        
    
    
    
}


