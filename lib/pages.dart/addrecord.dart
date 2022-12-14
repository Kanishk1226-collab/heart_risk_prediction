import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heart_rate/bloc/auth_bloc.dart';
import 'package:heart_rate/bloc/bottomNavBar.dart';

class AddMedicalRecord extends StatefulWidget {
  const AddMedicalRecord({Key? key}) : super(key: key);

  @override
  _AddMedicalRecordState createState() => _AddMedicalRecordState();
}

class _AddMedicalRecordState extends State<AddMedicalRecord> {
  final TextEditingController age = TextEditingController();
  final TextEditingController restingBP = TextEditingController();
  final TextEditingController cholestrol = TextEditingController();
  final TextEditingController fastingBS = TextEditingController();
  final TextEditingController oldpeak = TextEditingController();
  int maxHR = 153;
  String gender = '';
  String chestPainType = 'Select';
  String restingECG = 'Select';
  String exerciseAngina = 'Select';
  String st_slope = 'Select';
  bool openCalculatorScreen = false;

  void onSubmitData() async {
    try {
      final authToken = Provider.of<AuthenticationBloc>(context, listen: false)
          .authData['user']
          .accessToken;
      Dio dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${authToken}";

      Map<String, dynamic> data = {
        "age": int.parse(age.text),
        "restingBP": int.parse(restingBP.text),
        "cholestrol": int.parse(cholestrol.text),
        "fastingBS": int.parse(fastingBS.text),
        "maxHR": maxHR,
        "oldpeak": oldpeak.text,
        "sex": gender,
        "chestPainType": chestPainType,
        "restingECG": restingECG,
        "exerciseAngina": exerciseAngina,
        "st_slope": st_slope
      };

      print(data);

      await dio
          .post("https://heartrisk-api.herokuapp.com/rate-prediction",
              data: data)
          .then((value) {
        print("response from post , ${value.data}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                // '${value.data["heartDisease"] == 1 ? 'You have to immediately go to Dr. for checkup.' : "Congratulations! You have no risk of heart failure yet."}'),
                '${value.data["heartDisease"] == 1 ? 'You have to immediately go to Dr. for checkup.' : "Congratulations! You have no risk of heart failure yet."}'),
            duration: const Duration(milliseconds: 2000),
            width: 320.0, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0, // Inner padding for SnackBar content.
              vertical: 12.0,
            ),
            backgroundColor: value.data["heartDisease"] == 1
                ? Colors.red.shade600
                : Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        );
      });
    } on DioError catch (err) {
      if (err.response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${err.response?.data["detail"]}'),
            duration: const Duration(milliseconds: 2000),
            width: 320.0, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0, // Inner padding for SnackBar content.
              vertical: 12.0,
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 96, 0, 144),
          title: const Text(
            "Add Medical Record",
            style: TextStyle(fontFamily: "Comfortaa", fontSize: 16),
          ),
          elevation: 4,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color(0xFFffffff),
        bottomNavigationBar:
            Consumer<BottomNavBarBloc>(builder: (context, provider, child) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_rounded),
                label: 'Heart Risk',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assistant),
                label: 'ChatBot',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Logout',
              ),
            ],
            currentIndex: provider.currentIndex,
            selectedItemColor: Color.fromARGB(255, 96, 0, 144),
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.normal,
                fontSize: 12),
            unselectedLabelStyle: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.normal,
                fontSize: 12),
            onTap: (int index) {
              if (index != provider.currentIndex) {
                provider.setIndex(index);
                if (index == 0) {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                }
                if (index == 2) {
                  Navigator.pushReplacementNamed(context, '/chatbot');
                }
                if (index == 3) {
                  final authProvider =
                      Provider.of<AuthenticationBloc>(context, listen: false);
                  if (authProvider.authDetails['isAuthenticated'] &&
                      authProvider.authDetails['loading']) {
                    authProvider.logout_user();
                    Navigator.pushReplacementNamed(context, '/auth');
                  }
                }
              }
            },
          );
        }),
        body: SingleChildScrollView(
          child: SafeArea(
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Select Gender",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Comfortaa",
                              )),
                          ListTile(
                            focusColor: Color.fromARGB(255, 96, 0, 144),
                            title: const Text('Male',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Comfortaa",
                                )),
                            leading: Radio(
                              activeColor: Color.fromARGB(255, 96, 0, 144),
                              value: "M",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = "M";
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Female',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "Comfortaa",
                                )),
                            focusColor: Color.fromARGB(255, 96, 0, 144),
                            leading: Radio(
                              activeColor: Color.fromARGB(255, 96, 0, 144),
                              value: 'F',
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = 'F';
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: age,

                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: "Comfortaa",
                            ),
                            // decoration: InputDecoration(
                            //     enabledBorder: UnderlineInputBorder(
                            //         borderSide: BorderSide(
                            //             color: Color.fromARGB(255, 96, 0, 144),
                            //             width: 1.5)),
                            //     contentPadding:
                            //         EdgeInsets.fromLTRB(0, 15, 15, 3),
                            //     border: UnderlineInputBorder(
                            //         borderSide: BorderSide(
                            //             color: Color.fromARGB(255, 96, 0, 144),
                            //             width: 2)),
                            //     hintText: 'Enter your Age',
                            //     labelText: "Age"),
                            cursorColor: Color.fromARGB(255, 96, 0, 144),

                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding:
                                    EdgeInsets.only(top: 15, left: 20),
                                // labelText: 'Enter Email ID',
                                labelText: 'Age',
                                hintText: 'Enter your Age',
                                labelStyle: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.0,
                                    color: Colors.black),
                                // focusedBorder: UnderlineInputBorder(
                                //     borderSide: BorderSide(color: Colors.red.shade400))
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 96, 0, 144),
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: chestPainType,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: "Comfortaa"),
                            underline: Container(
                              height: 1.5,
                              color: Color.fromARGB(255, 96, 0, 144),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                chestPainType = newValue!;
                              });
                            },
                            hint: Text("Select Chest pain type"),
                            items: [
                              DropdownMenuItem(
                                  enabled: false,
                                  child: Text("Select Chest pain type"),
                                  value: 'Select'),
                              DropdownMenuItem(
                                  child: Text("Typical Angina"), value: 'TA'),
                              DropdownMenuItem(
                                  child: Text("ATypical Angina"), value: 'ATA'),
                              DropdownMenuItem(
                                  child: Text("Non-Anginal Pain"),
                                  value: 'NAP'),
                              DropdownMenuItem(
                                  child: Text("Asymptomatic"), value: 'ASY'),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: restingBP,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(fontSize: 13),
                            // decoration: const InputDecoration(
                            //     enabledBorder: UnderlineInputBorder(
                            //         borderSide: BorderSide(
                            //             color: Colors.red, width: 1.5)),
                            //     contentPadding:
                            //         EdgeInsets.fromLTRB(0, 15, 15, 3),
                            //     border: UnderlineInputBorder(
                            //         borderSide: BorderSide(
                            //             color: Colors.red, width: 2)),
                            //     hintText: 'Enter you Blood Pressure',
                            //     labelText: "Blood Pressure"),
                            cursorColor: Color.fromARGB(255, 96, 0, 144),

                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding:
                                    EdgeInsets.only(top: 15, left: 20),
                                // labelText: 'Enter Email ID',
                                labelText: 'Blood Pressure',
                                hintText: 'Enter you Blood Pressure',
                                labelStyle: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.0,
                                    color: Colors.black),
                                // focusedBorder: UnderlineInputBorder(
                                //     borderSide: BorderSide(color: Colors.red.shade400))
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 96, 0, 144),
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: cholestrol,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(fontSize: 13),
                            // decoration: const InputDecoration(
                            //     enabledBorder: UnderlineInputBorder(
                            //         borderSide: BorderSide(
                            //             color: Colors.red, width: 1.5)),
                            //     contentPadding:
                            //         EdgeInsets.fromLTRB(0, 15, 15, 3),
                            //     border: UnderlineInputBorder(
                            //         borderSide: BorderSide(
                            //             color: Colors.red, width: 2)),
                            //     hintText: 'Enter your Cholestrol',
                            //     labelText: "Cholestrol"),
                            cursorColor: Color.fromARGB(255, 96, 0, 144),

                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding:
                                    EdgeInsets.only(top: 15, left: 20),
                                // labelText: 'Enter Email ID',
                                labelText: 'Cholestrol',
                                hintText: 'Enter your Cholestrol',
                                labelStyle: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.0,
                                    color: Colors.black),
                                // focusedBorder: UnderlineInputBorder(
                                //     borderSide: BorderSide(color: Colors.red.shade400))
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 96, 0, 144),
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: fastingBS,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(fontSize: 13),
                            // decoration: const InputDecoration(
                            //     enabledBorder: UnderlineInputBorder(
                            //         borderSide: BorderSide(
                            //             color: Colors.red, width: 1.5)),
                            //     contentPadding:
                            //         EdgeInsets.fromLTRB(0, 15, 15, 3),
                            //     border: UnderlineInputBorder(
                            //         borderSide: BorderSide(
                            //             color: Colors.red, width: 2)),
                            //     hintText: 'Enter your Fasting Blood Sugar',
                            //     labelText: "Sugar"),
                            cursorColor: Color.fromARGB(255, 96, 0, 144),

                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding:
                                    EdgeInsets.only(top: 15, left: 20),
                                // labelText: 'Enter Email ID',
                                labelText: 'Sugar',
                                hintText: 'Enter your Fasting Blood Sugar',
                                labelStyle: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.0,
                                    color: Colors.black),
                                // focusedBorder: UnderlineInputBorder(
                                //     borderSide: BorderSide(color: Colors.red.shade400))
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 96, 0, 144),
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: oldpeak,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 13),
                            // decoration: const InputDecoration(
                            //     enabledBorder: UnderlineInputBorder(
                            //         borderSide: BorderSide(
                            //             color: Colors.red, width: 1.5)),
                            //     contentPadding:
                            //         EdgeInsets.fromLTRB(0, 15, 15, 3),
                            //     border: UnderlineInputBorder(
                            //         borderSide: BorderSide(
                            //             color: Colors.red, width: 2)),
                            //     hintText: 'Enter your Old Peak',
                            //     labelText: "Old peak"),
                            cursorColor: Color.fromARGB(255, 96, 0, 144),

                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                contentPadding:
                                    EdgeInsets.only(top: 15, left: 20),
                                // labelText: 'Enter Email ID',
                                labelText: 'Old peak',
                                hintText: 'Enter your Old Peak',
                                labelStyle: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.0,
                                    color: Colors.black),
                                // focusedBorder: UnderlineInputBorder(
                                //     borderSide: BorderSide(color: Colors.red.shade400))
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 96, 0, 144),
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: restingECG,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: "Comfortaa"),
                            underline: Container(
                              height: 1.5,
                              color: Color.fromARGB(255, 96, 0, 144),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                restingECG = newValue!;
                              });
                            },
                            hint: Text("Select"),
                            items: [
                              DropdownMenuItem(
                                  enabled: false,
                                  child:
                                      Text("Select ElectroCardiogram Results"),
                                  value: 'Select'),
                              DropdownMenuItem(
                                  child: Text("Normal"), value: 'Normal'),
                              DropdownMenuItem(
                                  child: Text("ST-T wave abnormality"),
                                  value: 'ST'),
                              DropdownMenuItem(
                                  child: Text(
                                      "Definite Left ventricular Hypertrophy"),
                                  value: 'LVH'),
                            ],
                          ),
                          SizedBox(height: 20),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: exerciseAngina,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: "Comfortaa"),
                            underline: Container(
                              height: 1.5,
                              color: Color.fromARGB(255, 96, 0, 144),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                exerciseAngina = newValue!;
                              });
                            },
                            hint: Text("Select"),
                            items: [
                              DropdownMenuItem(
                                  enabled: false,
                                  child: Text("Select Exercise Induced Angina"),
                                  value: 'Select'),
                              DropdownMenuItem(child: Text("Yes"), value: 'Y'),
                              DropdownMenuItem(child: Text("No"), value: 'N'),
                            ],
                          ),
                          SizedBox(height: 20),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: st_slope,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: "Comfortaa"),
                            underline: Container(
                              height: 1.5,
                              color: Color.fromARGB(255, 96, 0, 144),
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                st_slope = newValue!;
                              });
                            },
                            hint: Text("Select"),
                            items: [
                              DropdownMenuItem(
                                  enabled: false,
                                  child: Text("Select Slope of peak exercise"),
                                  value: 'Select'),
                              DropdownMenuItem(
                                  child: Text("Up sloping"), value: 'Up'),
                              DropdownMenuItem(
                                  child: Text("Flat"), value: 'Flat'),
                              DropdownMenuItem(
                                  child: Text("Down sloping"), value: 'down'),
                            ],
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            child: Center(
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(255, 96, 0, 144))),
                                  onPressed: () async {
                                    var beat = await Navigator.pushNamed(
                                        context, '/heart_rate');
                                    setState(() {
                                      maxHR = int.parse("${beat}");
                                      openCalculatorScreen = true;
                                    });
                                  },
                                  child: Text(
                                    '${openCalculatorScreen ? 'Calculated beat is ${maxHR} bpm' : 'Calculate Heart Rate'}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Comfortaa"),
                                  )),
                            ),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  onSubmitData();
                                },
                                child: Text(
                                  "Save Medical Record",
                                  style: TextStyle(fontFamily: "Comfortaa"),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromARGB(255, 96, 0, 144)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3.0),
                                            side: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 96, 0, 144),
                                            ))))),
                          )
                        ],
                      )))),
        ));
  }
}
