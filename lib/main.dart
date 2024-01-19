import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_apinew/errorPackge.dart';
import 'package:weather_apinew/weather_file/weather_cubit.dart';

void main(){
  runApp(MaterialApp(
    home: BlocProvider(
      create: (context) => WeatherCubit(),
      child: MyApp(),
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  TextEditingController joylashuvtxt = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(joylashuvtxt.text == ""){
      joylashuvtxt=TextEditingController(text: "Fergana");
      print(joylashuvtxt.text);
    }
    BlocProvider.of<WeatherCubit>(context).getWeather(joylashuvtxt.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ob-Havo"),
      actions: [
      ],),
      body: BlocConsumer<WeatherCubit, WeatherState>(
        listener: (context , state){
          if(state is WeatherError){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ErrorApp()));
          }
        },
        builder: (context, state) {
          if (state is WeatherInitial) {
            return SizedBox();
          } else if (state is WeatherLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WeatherSuccess) {
            return ListView(
              scrollDirection: Axis.vertical,
              children: [Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  Container(margin: EdgeInsets.only(left: 5, right: 5), padding: EdgeInsets.only(left: 10), width: MediaQuery.of(context).size.width-120, height: 60, decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 2, color: Colors.black)
                  ),
                    child: TextField(
                      style: TextStyle(fontSize: 22),
                      controller: joylashuvtxt,
                      decoration: InputDecoration(hintText: "Shaxar nomi Ingliz tilida",),
                    ),
                  ),
                  Container(margin: EdgeInsets.only(left: 5, right: 5),height: 60, width: 100, decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 2, color: Colors.black)
                  ),
                    child: MaterialButton(
                      onPressed: (){
                        BlocProvider.of<WeatherCubit>(context).getWeather(joylashuvtxt.text);
                      },
                      child: Text("Saqlash"),
                    ),
                  ),
                ],),
                Center(
                    child: Column(children: [
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                      child: Text(
                    state.weather.current?.lastUpdated?.toString() ?? "Nomalum",
                    style: TextStyle(fontSize: 30),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center ,children: [
                    Text(
                      state.weather.location?.region ?? "Nomalum",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      state.weather.location?.name.toString() ?? "Nomalum",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(width: 15,),
                    Center(child: Image.network("https:${state.weather.current?.condition?.icon}"),),
                  ],),
                  //pasdagi Row haroratni korsatadigan block,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.weather.current?.tempC.toString() ?? "Nomalum",
                        style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent),
                      ),
                      Text("o",
                          style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyanAccent)),
                      Text("C",
                          style: TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyanAccent)),
                    ],
                  ),
                ])),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 5),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          border: Border.all(width: 1, color: Colors.white24),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "${state.weather.current?.humidity?.toString() ?? "Nomalum"}%",
                                style: TextStyle(
                                    fontSize: 60, fontWeight: FontWeight.bold)),
                            Text(
                              "Namlik foizi",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10, left: 5),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          border: Border.all(width: 1, color: Colors.white24),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.weather.current?.gustKph?.toString() ??
                                  "Nomalum",
                              style: TextStyle(
                                  fontSize: 60, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Shamol km/h ",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  margin: EdgeInsets.only(right: 10, left: 10, top: 10),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    border: Border.all(width: 1, color: Colors.white24),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "His qilinishi : ${state.weather.current?.feelslikeC.toString() ?? "Nomalum"}⁰",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: state.weather.forecast?.forecastday?.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(20),
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green[200]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.weather.forecast?.forecastday?[index].date
                                    ?.toString() ??
                                "0"),
                            Image.network(
                                "https:${state.weather.forecast?.forecastday?[index].day?.condition?.icon}"),
                            Text(
                              "${state.weather.forecast?.forecastday?[index].day?.avgtempC} °C",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ]),
              ]
            );
          } else if (state is WeatherError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Center(
              child: Text("Nomalum xatolik"),
            );
          }
        },
      ),
    );
  }
}
