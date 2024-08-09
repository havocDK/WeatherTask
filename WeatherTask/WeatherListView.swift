//
//  WeatherListView.swift
//  WeatherTask
//
//  Created by Dimitar Kolev on 9.08.24.
//

import SwiftUI

struct WeatherList: View {
    private var dataArray:[RowData];
    
    init(hourlyDataArray: [HourlyWeatherData], temperatureUnit: String, speedUnit: String) {
        var resultArray:[RowData] = [];
        for hourlyData in hourlyDataArray {
            var dateString: String = "";
            var infoString: String = "";
            let date = hourlyData.time;
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm";
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date);
            dateString = "\(components.year ?? 0) - \(components.month ?? 1) - \(components.day ?? 1)";
            infoString = "\(components.hour ?? 0):00 - Temperature: \(hourlyData.temperature) \(temperatureUnit) \n" +
                "Windspeed: \(hourlyData.windspeed) \(speedUnit) \n" +
                "Weather status: \(WeatherCode(rawValue: hourlyData.weathercode)?.description ?? "Unknown weather")";
            let rowData: RowData = RowData(dateString: dateString, infoString: infoString)
            resultArray.append(rowData);
        }
        self.dataArray = resultArray;
        
    }
    
    var groupedByDate: [String: [RowData]] {
        Dictionary(grouping: dataArray, by: {$0.dateString})
    }
    var headers: [String] {
        groupedByDate.map({ $0.key }).sorted()
    }
    var body: some View {
        List(){
            ForEach(headers, id: \.self) { header in
                Section(header: Text(header )) {
                    ForEach(groupedByDate[header] ?? []) { array in
                        Text(array.infoString)
                            .font(.system(size: 20, weight: .light))
                    }
                }
            }
        }
    }
    #Preview {
        WeatherList(hourlyDataArray: [],temperatureUnit: "",speedUnit: "")
    }
}
