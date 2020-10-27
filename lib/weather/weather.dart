// Copyright 2020 I.S. "A. Sobrero". All rights reserved.
// Use of this source code is governed by the GPL 3.0 license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mySobrero/weather/weather_model.dart';

class OWMProvider {
  OWMProvider._internal();
  static final OWMProvider instance = OWMProvider._internal();

  final String _apiKey = "be79f5f7b2cf364f61f49ecd9317b204";
  WeatherModel _cache;

  Future<WeatherModel> getWeather () async {
    if (_cache != null)
      return _cache;
    String _reqUrl = "https://api.openweathermap.org/data/2.5/onecall?lat=45.1334&lon=8.4571&exclude=minutely,hourly,daily,alerts&appid=$_apiKey&units=metric&lang=it";
    var _res = await http.get(_reqUrl);
    if (_res.statusCode != 200)
      throw new Exception("OpenWeatherMap error");
    final String _response = _res.body;
    final _json = jsonDecode(_response);
    _cache = WeatherModel.fromJson(_json);
    return _cache;
  }
}