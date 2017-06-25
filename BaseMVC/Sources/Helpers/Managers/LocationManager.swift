import UIKit
import CoreLocation

// MARK: - Notification
enum LocationEvent {
    static let didLocationDenied = "didLocationDeniedNotification"
}

class LocationManager: NSObject {

    // MARK: - Varialbes
    fileprivate var locationManager: CLLocationManager?
    fileprivate var getCurrentLocationCallback: ((CLLocation?) -> Void)?
    var currentLocation: CLLocation?
    var accuracy: Double = 0.5

    // MARK: - Singleton
    static let shared = LocationManager()

    // MARK: - Init
    override init() {
        super.init()
    }

    func startLocationServices() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
    }

    // MARK: - Callback
    func getCurrentLocation(completion: ((_ location: CLLocation?) -> Void)?) {
        self.getCurrentLocationCallback = completion
        self.startStandardUpdates()
    }

    func stopGetCurrentLocation() {
        self.getCurrentLocationCallback = nil
        self.locationManager?.stopUpdatingLocation()
    }

    // MARK: - Updating Location
    func startStandardUpdates() {
        if CLLocationManager.locationServicesEnabled() &&
             CLLocationManager.authorizationStatus() != .denied {
            self.locationManager?.pausesLocationUpdatesAutomatically = true
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager?.activityType = CLActivityType.otherNavigation
            self.locationManager?.distanceFilter = 10.0
            self.locationManager?.startUpdatingLocation()
        } else {
            self.startLocationServices()
        }
    }

    func stopStandardUpdates() {
        self.locationManager?.stopUpdatingLocation()
    }

    func startSignificantChangeUpdates() {
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            self.locationManager?.pausesLocationUpdatesAutomatically = true
            self.locationManager?.activityType = CLActivityType.otherNavigation
            self.locationManager?.startMonitoringSignificantLocationChanges()
        }
    }

    func stopMonitoringSignificantLocationChanges () {
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            self.locationManager?.stopMonitoringSignificantLocationChanges()
        }
    }

    // MARK: - Monitoring Regions
    func startMonitoringForRegionBeacon() {
    }

    func requestStateForRegionBeacon() {
        guard let locManager = self.locationManager else {return}

        for region: CLRegion in locManager.monitoredRegions where region is CLBeaconRegion {
                locManager.requestState(for: region)
        }
    }

    func stopMonitoringForRegionBeacon() {
        guard let locManager = self.locationManager else {return}

        for region: CLRegion in locManager.monitoredRegions {
            if let beaconRegion = region as? CLBeaconRegion {
                locManager.stopRangingBeacons(in: beaconRegion)
                locManager.stopMonitoring(for: beaconRegion)
            }
        }
    }

    func startMonitoringForRegionCircular() {
    }

    func requestStateForRegionCircular() {
        guard let locManager = self.locationManager else {return}

        for region: CLRegion in locManager.monitoredRegions where region is CLCircularRegion {
            locManager.requestState(for: region)
        }
    }

    func stopMonitoringForRegionCircular() {
        guard let locManager = self.locationManager else {return}

        for region: CLRegion in locManager.monitoredRegions where region is CLCircularRegion {
                locManager.stopMonitoring(for: region)
        }
    }

    func stopMonitoringAll() {
        self.stopMonitoringForRegionCircular()
        self.stopMonitoringForRegionBeacon()
        self.stopStandardUpdates()
    }

}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        // check status
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            break
        case .restricted:
            break
        case .denied:
            LocationManager.shared.stopGetCurrentLocation()

            // post notification
            NotificationCenter.default.post(name: Notification.Name(LocationEvent.didLocationDenied), object: nil, userInfo: nil)
        case .authorizedAlways:
            LocationManager.shared.getCurrentLocation(completion: { _ in
                LocationManager.shared.stopGetCurrentLocation()
            })
        case .authorizedWhenInUse:
            LocationManager.shared.getCurrentLocation(completion: { _ in
                LocationManager.shared.stopGetCurrentLocation()
            })
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        // get location
        if let latestLocation = locations.last {
            let howRecent = latestLocation.timestamp.timeIntervalSinceNow

            if abs(howRecent) <= accuracy {
                self.currentLocation = latestLocation
                self.getCurrentLocationCallback?(latestLocation)
                self.stopStandardUpdates()
            } else {
                self.startStandardUpdates()
            }
        } else {
            self.startStandardUpdates()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.getCurrentLocationCallback?(nil)
    }

}
