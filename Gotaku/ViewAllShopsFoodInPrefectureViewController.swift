//
//  ViewAllShopsFoodInPrefectureViewController.swift
//  Gotaku
//
//  Created by Mac on 6/20/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import MapKit

class ViewAllShopsFoodInPrefectureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var locations : [Location] = []
    
    var prefecture = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = locations[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewLocationSegue", sender: indexPath.row)
    }

    @IBAction func mapTapped(_ sender: Any) {
        performSegue(withIdentifier: "viewMapSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewLocationSegue"{
        let nextVC = segue.destination as! ViewLocationViewController
        nextVC.loc = locations[sender as! Int]
        } else if segue.identifier == "viewMapSegue"{
         let nextVC = segue.destination as! MapViewController
         nextVC.locations = locations
            if prefecture == "Hokkaido"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 43.2324, longitude: 142.5706)
                nextVC.regionInfo["width"] = 570000.0
                nextVC.regionInfo["height"] = 570000.0
            } else if prefecture == "Akita"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 39.7641, longitude: 140.4348)
                nextVC.regionInfo["width"] = 150000.0
                nextVC.regionInfo["height"] = 150000.0
            } else if prefecture == "Aomori"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 40.7019, longitude: 140.9206)
                nextVC.regionInfo["width"] = 125000.0
                nextVC.regionInfo["height"] = 125000.0
            } else if prefecture == "Fukushima"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 37.4254, longitude: 140.2497)
                nextVC.regionInfo["width"] = 180000.0
                nextVC.regionInfo["height"] = 180000.0
            } else if prefecture == "Iwate"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 39.6244, longitude: 141.4094)
                nextVC.regionInfo["width"] = 180000.0
                nextVC.regionInfo["height"] = 180000.0
            } else if prefecture == "Miyagi"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 38.3517, longitude: 141.0451)
                nextVC.regionInfo["width"] = 130000.0
                nextVC.regionInfo["height"] = 130000.0
            } else if prefecture == "Yamagata"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 38.4597, longitude: 140.1092)
                nextVC.regionInfo["width"] = 130000.0
                nextVC.regionInfo["height"] = 130000.0
            } else if prefecture == "Chiba"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.5128, longitude: 140.3227)
                nextVC.regionInfo["width"] = 120000.0
                nextVC.regionInfo["height"] = 120000.0
            }else if prefecture == "Gunma"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 36.5239, longitude: 139.0402)
                nextVC.regionInfo["width"] = 130000.0
                nextVC.regionInfo["height"] = 130000.0
            }else if prefecture == "Ibaraki"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 36.2668, longitude: 140.3056)
                nextVC.regionInfo["width"] = 130000.0
                nextVC.regionInfo["height"] = 130000.0
            }else if prefecture == "Kanagawa"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.4018, longitude: 139.3930)
                nextVC.regionInfo["width"] = 80000.0
                nextVC.regionInfo["height"] = 80000.0
            }else if prefecture == "Saitama"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 36.0230, longitude: 139.4058)
                nextVC.regionInfo["width"] = 110000.0
                nextVC.regionInfo["height"] = 110000.0
            }else if prefecture == "Tochigi"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 36.7029, longitude: 139.8274)
                nextVC.regionInfo["width"] = 100000.0
                nextVC.regionInfo["height"] = 100000.0
            }else if prefecture == "Tokyo"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.6912, longitude: 139.4460)
                nextVC.regionInfo["width"] = 100000.0
                nextVC.regionInfo["height"] = 100000.0
            }else if prefecture == "Aichi"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.0532, longitude: 137.2091)
                nextVC.regionInfo["width"] = 110000.0
                nextVC.regionInfo["height"] = 110000.0
            }else if prefecture == "Fukui"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.7349, longitude: 136.1340)
                nextVC.regionInfo["width"] = 130000.0
                nextVC.regionInfo["height"] = 130000.0
            }else if prefecture == "Gifu"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.8194, longitude: 137.0648)
                nextVC.regionInfo["width"] = 110000.0
                nextVC.regionInfo["height"] = 110000.0
            }else if prefecture == "Ishikawa"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 36.7799, longitude: 136.7621)
                nextVC.regionInfo["width"] = 110000.0
                nextVC.regionInfo["height"] = 110000.0
            }else if prefecture == "Nagano"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 36.1011, longitude: 138.0733)
                nextVC.regionInfo["width"] = 135000.0
                nextVC.regionInfo["height"] = 135000.0
            }else if prefecture == "Niigata"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 37.7017, longitude: 138.7811)
                nextVC.regionInfo["width"] = 160000.0
                nextVC.regionInfo["height"] = 160000.0
            }else if prefecture == "Shizuoka"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.0753, longitude: 138.4255)
                nextVC.regionInfo["width"] = 160000.0
                nextVC.regionInfo["height"] = 160000.0
            }else if prefecture == "Toyama"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 36.5961, longitude: 137.3002)
                nextVC.regionInfo["width"] = 140000.0
                nextVC.regionInfo["height"] = 140000.0
            }else if prefecture == "Yamanashi"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.5947, longitude: 138.6800)
                nextVC.regionInfo["width"] = 130000.0
                nextVC.regionInfo["height"] = 130000.0
            }else if prefecture == "Hyogo"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.1132, longitude: 134.8950)
                nextVC.regionInfo["width"] = 130000.0
                nextVC.regionInfo["height"] = 130000.0
            }else if prefecture == "Kyoto"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.2112, longitude: 135.4992)
                nextVC.regionInfo["width"] = 130000.0
                nextVC.regionInfo["height"] = 130000.0
            }else if prefecture == "Mie"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 34.4856, longitude: 136.4382)
                nextVC.regionInfo["width"] = 130000.0
                nextVC.regionInfo["height"] = 130000.0
            }else if prefecture == "Nara"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 34.3317, longitude: 135.8889)
                nextVC.regionInfo["width"] = 100000.0
                nextVC.regionInfo["height"] = 100000.0
            }else if prefecture == "Osaka"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 34.6173, longitude: 135.4049)
                nextVC.regionInfo["width"] = 80000.0
                nextVC.regionInfo["height"] = 80000.0
            }else if prefecture == "Shiga"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.2404, longitude: 136.1327)
                nextVC.regionInfo["width"] = 80000.0
                nextVC.regionInfo["height"] = 80000.0
            }else if prefecture == "Wakayama"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 33.9338, longitude: 135.5736)
                nextVC.regionInfo["width"] = 100000.0
                nextVC.regionInfo["height"] = 100000.0
            }else if prefecture == "Hiroshima"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 34.6738, longitude: 132.8070)
                nextVC.regionInfo["width"] = 130000.0
                nextVC.regionInfo["height"] = 130000.0
            }else if prefecture == "Okayama"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 34.9360, longitude: 133.8524)
                nextVC.regionInfo["width"] = 110000.0
                nextVC.regionInfo["height"] = 110000.0
            }else if prefecture == "Shimane"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.0105, longitude: 132.5081)
                nextVC.regionInfo["width"] = 160000.0
                nextVC.regionInfo["height"] = 160000.0
            } else if prefecture == "Tottori"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.3450, longitude: 133.8486)
                nextVC.regionInfo["width"] = 130000.0
                nextVC.regionInfo["height"] = 130000.0
            }else if prefecture == "Yamaguchi"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 34.2624, longitude: 131.5689)
                nextVC.regionInfo["width"] = 150000.0
                nextVC.regionInfo["height"] = 150000.0
            }else if prefecture == "Ehime"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 33.5540, longitude: 133.0326)
                nextVC.regionInfo["width"] = 160000.0
                nextVC.regionInfo["height"] = 160000.0
            } else if prefecture == "Kagawa"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 34.2977, longitude: 134.0192)
                nextVC.regionInfo["width"] = 90000.0
                nextVC.regionInfo["height"] = 90000.0
            } else if prefecture == "Kochi"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 33.2836, longitude: 133.5387)
                nextVC.regionInfo["width"] = 180000.0
                nextVC.regionInfo["height"] = 180000.0
            } else if prefecture == "Tokushima"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 33.9369, longitude: 134.2398)
                nextVC.regionInfo["width"] = 120000.0
                nextVC.regionInfo["height"] = 120000.0
            } else if prefecture == "Fukuoka"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 33.4764, longitude: 130.6700)
                nextVC.regionInfo["width"] = 130000.0
                nextVC.regionInfo["height"] = 130000.0
            } else if prefecture == "Kagoshima"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 29.2905, longitude: 129.6412)
                nextVC.regionInfo["width"] = 400000.0
                nextVC.regionInfo["height"] = 400000.0
            } else if prefecture == "Kumamoto"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 32.6474, longitude: 130.6501)
                nextVC.regionInfo["width"] = 120000.0
                nextVC.regionInfo["height"] = 120000.0
            } else if prefecture == "Miyazaki"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 32.2044, longitude: 131.3288)
                nextVC.regionInfo["width"] = 140000.0
                nextVC.regionInfo["height"] = 140000.0
            } else if prefecture == "Nagasaki"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 33.2080, longitude: 129.5922)
                nextVC.regionInfo["width"] = 200000.0
                nextVC.regionInfo["height"] = 200000.0
            } else if prefecture == "Oita"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 33.2320, longitude: 131.5057)
                nextVC.regionInfo["width"] = 135000.0
                nextVC.regionInfo["height"] = 135000.0
            } else if prefecture == "Saga"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 33.2813, longitude: 130.1500)
                nextVC.regionInfo["width"] = 80000.0
                nextVC.regionInfo["height"] = 80000.0
            } else if prefecture == "Okinawa"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 26.6906, longitude: 127.8423)
                nextVC.regionInfo["width"] = 150000.0
                nextVC.regionInfo["height"] = 150000.0
            } else if prefecture == "China"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 35.4230, longitude: 103.8285)
                nextVC.regionInfo["width"] = 6000000.0
                nextVC.regionInfo["height"] = 6000000.0
            } else if prefecture == "Hong Kong"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 22.3921, longitude: 114.1394)
                nextVC.regionInfo["width"] = 70000.0
                nextVC.regionInfo["height"] = 70000.0
            } else if prefecture == "Taiwan"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 23.7877, longitude: 120.9907)
                nextVC.regionInfo["width"] = 260000.0
                nextVC.regionInfo["height"] = 260000.0
            } else if prefecture == "Thailand"{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 13.5523, longitude: 100.9847)
                nextVC.regionInfo["width"] = 1100000.0
                nextVC.regionInfo["height"] = 1100000.0
            } else if prefecture == "U.S."{
                nextVC.regionInfo["coordinate"] = CLLocationCoordinate2D(latitude: 40.5335, longitude: -93.2480)
                nextVC.regionInfo["width"] = 5700000.0
                nextVC.regionInfo["height"] = 5700000.0
            } else if prefecture == "Other"{
                nextVC.regionInfo["region"] = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0.0000, 0.0000) , MKCoordinateSpanMake(180, 360) )
            }
        }
}
}
