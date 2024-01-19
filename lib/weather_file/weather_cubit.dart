import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


import '../api/weather2.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());
  void getWeather(loc) async {
    Dio dio = Dio();
    emit(WeatherLoading());
    try {
      var response = await dio.get("http://api.weatherapi.com/v1/forecast.json?key=402f7b21b363478f84a94851232711&q=${loc}&days=3");
      if(response.statusCode == 200){
        emit(WeatherSuccess(Weather2.fromJson(response.data)));
      } else {
        emit(WeatherError("Xatolik"));
      }} catch (e){
      emit(WeatherError(e.toString()));

      print(e.toString());
    }
  }
}
