import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:GoTrail/weather_api.dart';

Widget weatherWidget(double latitude, double longitude) {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  return FutureBuilder<Weather?>(
    future: _wf.currentWeatherByLocation(latitude, longitude),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      Weather? _weather = snapshot.data;

      if (_weather == null) {
        return Center(
          child: Text('Failed to fetch weather data'),
        );
      }

      return _buildUI(context, _weather);
    },
  );
}

Widget _buildUI(BuildContext context, Weather _weather) {
  return 
   Column(
        // mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationHeader(_weather),
          SizedBox(height: 5),
          _dateTimeInfo(_weather),
          SizedBox(height: 5),
          _weatherIcon(_weather),
          SizedBox(height: 5),
          _currentTemp(_weather),
          SizedBox(height: 5),
          _extraInfo(_weather),
        ],
      );
    
}


Widget _locationHeader(Weather _weather) {
  return Text(
    _weather.areaName ?? "",
  );
}

Widget _dateTimeInfo(Weather _weather) {
  DateTime now = _weather.date!;
  return Column(
    children: [
      Text(
        DateFormat("h:mm a").format(now),
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DateFormat("EEEE").format(now),
          ),
          Text(
            "  ${DateFormat("d.m.y").format(now)}",
          ),
        ],
      ),
    ],
  );
}

Widget _weatherIcon(Weather _weather) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: 50, // Adjust height as needed
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "http://openweathermap.org/img/wn/${_weather.weatherIcon}@4x.png",
            ),
          ),
        ),
      ),
      Text(_weather.weatherDescription ?? ""),
    ],
  );
}

Widget _currentTemp(Weather _weather) {
  return Text(
    "${_weather.temperature?.celsius?.toStringAsFixed(0)}° C",
  );
}

Widget _extraInfo(Weather _weather) {
  return Container(
    width: 300, 
    decoration: BoxDecoration(
      color: Colors.deepPurpleAccent,
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Max: ${_weather.tempMax?.celsius?.toStringAsFixed(0)}° C",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            Text(
              "Min: ${_weather.tempMin?.celsius?.toStringAsFixed(0)}° C",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Wind: ${_weather.windSpeed?.toStringAsFixed(0)}m/s",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            Text(
              "Humidity: ${_weather.humidity?.toStringAsFixed(0)}%",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ],
    ),
  );
}
