//
//  ContentView.swift
//  WeatherTask
//
//  Created by Dimitar Kolev on 9.08.24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var citiesData: Set<CityData>;
    @State private var selectedCity: CityData?;
    @State private var savedSelectedCityName: String;
    @State private var previousCityName: String?;
    @State private var nextCityName: String?;
    
    init() {
        self.citiesData = Set<CityData>();
        //fetching last viewed city name
        let name = UserDefaults.standard.string(forKey: "cityName")
        if name == nil {
            self.savedSelectedCityName = "Sofia";
            UserDefaults.standard.set(self.savedSelectedCityName, forKey: "cityName")
        }
        else {
            self.savedSelectedCityName = name!;
        }
    }
    private func fetchRemoteData(cityName: String, urlString: String) {
        let url = URL(string: urlString)!;
        var request = URLRequest(url: url);
        request.httpMethod = "GET";
        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                print("Error while fetching data:", error);
                return;
            }

            guard let data = data else {
                return;
            }

            do {
                let decodedData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any];
                var locationWeatherData:LocationWeatherData? = nil;
                if decodedData != nil {
                    locationWeatherData = LocationWeatherData(dataDict: decodedData!);
                }
                let cityData = CityData(cityName: cityName, weatherDataURL: urlString, weatherData: locationWeatherData)
                if !self.citiesData.isEmpty {
                    for city in self.citiesData {
                        if city == cityData {
                            //remove duplicate data if need be
                            citiesData.remove(city);
                        }
                    }
                }
                self.citiesData.insert(cityData);
                if cityName == self.savedSelectedCityName {
                    self.selectedCity = cityData;
                }
                if self.selectedCity != nil {
                    self.refreshCityList();
                }
            } catch let jsonError {
                print("Failed to decode json", jsonError);
            }
        }
        task.resume();
    }
    //recalculating previous and next city for button names (not necissary with 3 cities)
    private func refreshCityList() {
        var cityNames:[String] = [];
        for city in self.citiesData {
            cityNames.append(city.cityName);
        }
        if cityNames.count > 1 {
            //first case where previous is last element
            var previousName = cityNames[cityNames.count-1];
            var nextName = cityNames[1];
            for i in 0...cityNames.count-1 {
                let name = cityNames[i];
                if self.selectedCity?.cityName == name {
                    self.previousCityName = previousName;
                    self.nextCityName = nextName;
                    return
                }
                else {
                    previousName = name
                    //if next element is the last
                    if i+1 >= cityNames.count-1 {
                        nextName = cityNames[0];
                    }
                    else {
                        nextName = cityNames[i+2];
                    }
                }
            }
        }
        else {
            self.previousCityName = nil;
            self.nextCityName = nil;
        }
    }
    var body: some View {
        
        VStack {
            HStack{
                Spacer()
                Button {
                    for city in citiesData {
                        if city.cityName == self.previousCityName {
                            self.selectedCity = city;
                            self.savedSelectedCityName = city.cityName;
                            UserDefaults.standard.set(self.savedSelectedCityName, forKey: "cityName");
                            self.refreshCityList();
                            return;
                        }
                    }
                } 
                label: {
                    Text(self.previousCityName ?? "Back");
                }
                Spacer()
                .contentShape(Rectangle())
                Text(self.savedSelectedCityName)
                    .font(.system(size: 36,weight: .medium))
                    .foregroundStyle(.blue)
                    .padding()
                Spacer()
                Button {
                    for city in citiesData {
                        if city.cityName == self.nextCityName {
                            self.selectedCity = city;
                            self.savedSelectedCityName = city.cityName;
                            UserDefaults.standard.set(self.savedSelectedCityName, forKey: "cityName");
                            self.refreshCityList();
                            return;
                        }
                    }
                } 
                label: {
                    Text(self.nextCityName ?? "Next")
                }
                Spacer()
            }
            Text("Latitude: \(selectedCity?.weatherData?.latitude ?? 0.0) \n" +
                 "Longtitude: \(selectedCity?.weatherData?.longitude ?? 0.0)")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.blue)
            WeatherList(hourlyDataArray: selectedCity?.weatherData?.hourly ?? [],temperatureUnit: selectedCity?.weatherData?.temperatureUnits ?? "",speedUnit: selectedCity?.weatherData?.speedUnits ?? "");
        }.onAppear(){
            self.fetchRemoteData(cityName: "Sofia", urlString: "https://api.open-meteo.com/v1/forecast?latitude=42.70&longitude=23.32&hourly=temperature_2m,weathercode,windspeed_10m");
            self.fetchRemoteData(cityName: "Plovdiv", urlString: "https://api.open-meteo.com/v1/forecast?latitude=42.15&longitude=24.75&hourly=temperature_2m,weathercode,windspeed_10m");
            self.fetchRemoteData(cityName: "Burgas", urlString: "https://api.open-meteo.com/v1/forecast?latitude=42.51&longitude=27.47&hourly=temperature_2m,weathercode,windspeed_10m");
        }
        Spacer ()
    }
}

#Preview {
    ContentView()
}

