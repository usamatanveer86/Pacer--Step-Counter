import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

bool loading = true;
var maindata;
var wetherdata;
var sys_data;
getweather(var lat, var long) async {
  loading = true;
  Map<dynamic, dynamic> data;

  var url =
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=3f1ab21d58a9212e587b41875d318987";
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    data = jsonDecode(response.body);
    maindata = data["main"];
    wetherdata = data["weather"];
    sys_data = data["sys"];

    loading = false;
    log(maindata.toString());
    log(sys_data.toString());
    // log(data.toString());
  }
}
