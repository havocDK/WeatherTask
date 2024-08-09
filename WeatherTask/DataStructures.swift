//
//  DataStructures.swift
//  WeatherTask
//
//  Created by Dimitar Kolev on 9.08.24.
//

import Foundation

struct CityData: Hashable, Equatable {
    var cityName: String
    var weatherDataURL: String
    var weatherData:LocationWeatherData?
    static func == (lhs: CityData, rhs: CityData) -> Bool {
        lhs.cityName == rhs.cityName
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(cityName)
        hasher.combine(weatherDataURL)
    }
}
struct LocationWeatherData {
    var latitude: Float
    var longitude: Float
    var timezone: String
    var elevation: Float
    var temperatureUnits: String
    var speedUnits: String
    var hourly: [HourlyWeatherData]
    
    init() {
        self.latitude = 0.0;
        self.longitude = 0.0;
        self.timezone = "GMT";
        self.elevation = 0.0;
        self.temperatureUnits = "°C";
        self.speedUnits = "km/h";
        self.hourly = [];
    }
    
    init(dataDict: [String: Any]) {
        var weatherDataDict:LocationWeatherData? = nil;
        weatherDataDict = LocationWeatherData();
        if let latitude = dataDict["latitude"] as? Float {
            weatherDataDict?.latitude = latitude;
        }
        if let longitude = dataDict["longitude"] as? Float {
            weatherDataDict?.longitude = longitude;
        }
        if let timezone = dataDict["timezone_abbreviation"] as? String {
            weatherDataDict?.timezone = timezone;
        }
        if let elevation = dataDict["elevation"] as? Float {
            weatherDataDict?.elevation = elevation;
        }
        if let hourlyUnits = dataDict["hourly_units"] as? [String: Any] {
            if let temperatureUnits = hourlyUnits["temperature_2m"] as? String {
                weatherDataDict?.temperatureUnits = temperatureUnits;
            }
            if let speedUnits = hourlyUnits["windspeed_10m"] as? String {
                weatherDataDict?.speedUnits = speedUnits;
            }
        }
        if let hourly = dataDict["hourly"] as? [String:Any] {
            let timeArray:[String] = hourly["time"] as? [String] ?? [];
            let temperatureArray:[Double] = hourly["temperature_2m"] as? [Double] ?? [];
            let windspeedArray:[Double] = hourly["windspeed_10m"] as? [Double] ?? [];
            let weathercodeArray:[Int] = hourly["weathercode"] as? [Int] ?? [];
            if timeArray.count == temperatureArray.count && timeArray.count == windspeedArray.count && timeArray.count == weathercodeArray.count {
                var hourlyArray:[HourlyWeatherData] = [];
                let length = timeArray.count;
                let dateFormatter = DateFormatter();
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm";
                for i in 0...length-1 {
                    var currentHourly = HourlyWeatherData();
                    if let time = dateFormatter.date(from: timeArray[i]){
                        currentHourly.time = time;
                    }
                    currentHourly.temperature = temperatureArray[i];
                    currentHourly.windspeed = windspeedArray[i];
                    currentHourly.weathercode = weathercodeArray[i];
                    hourlyArray.append(currentHourly);
                }
                weatherDataDict?.hourly = hourlyArray;
            }
        }
        if nil != weatherDataDict {
            self = weatherDataDict!;
        }
        else {
            self.init();
        }
    }
}
    
struct HourlyWeatherData {
    var time: Date
    var temperature: Double
    var windspeed: Double
    var weathercode: Int
    
    init() {
        time = Date.now;
        temperature = 0.0;
        windspeed = 0.0;
        weathercode = 0;
    }
}

struct RowData: Identifiable , Codable, Comparable{
    var dateString: String
    var infoString: String
    var id: UUID
    
    init(dateString: String, infoString: String) {
        self.dateString = dateString;
        self.infoString = infoString;
        self.id = UUID();
    }
    
    static func < (lhs: RowData, rhs: RowData) -> Bool {
        lhs.dateString < rhs.dateString;
    }
}

