
import 'package:flutter/material.dart';
import 'package:trying_database_php/real_app/help/constants.dart';
import 'package:http/http.dart' as http;
import 'package:trying_database_php/real_app/rendezVous/en_attente.dart';
import '../library.dart' as global;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class EnvoyeRaison extends StatefulWidget {
  const EnvoyeRaison({Key? key}) : super(key: key);

  @override
  _EnvoyeRaisonState createState() => _EnvoyeRaisonState();
}

class _EnvoyeRaisonState extends State<EnvoyeRaison> {
  late TextEditingController  sujetctrl, descctrl;
  final _formKey = GlobalKey<FormState>();
  String buttonText = "Confirmer";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sujetctrl =  TextEditingController();
    descctrl =  TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 248, 248, 1),
      appBar: AppBar(
        title: Text(
          "Rendez-vous",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: ContainerDeco,
                  height: 100,
                  child: Text(
                    "pourqoui voulez vous fair \nun rendez vous ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color.fromRGBO(63, 61, 86, 1), fontSize: 23,fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: ContainerDeco,
                  height: 440,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        SizedBox(height: 8,),
                        Align(
                          alignment : Alignment.topLeft ,
                          child: Text(
                            "  Sujet",
                            style: TextStyle(color: Color.fromRGBO(63, 61, 86, 1), fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 5,),
                        TextFormField(
                          controller: sujetctrl,
                          validator: (val) => val!.isEmpty ? 'Veuillez saisir le sujet' :  null  ,
                          style: TextStyle(color: Color.fromRGBO(63, 61, 86, 1),fontSize: 17,fontWeight: FontWeight.w600),
                          decoration: inputTrans,
                        ),
                        SizedBox(height: 8,),
                        Align(
                          alignment : Alignment.topLeft ,
                          child: Text(
                            "  Description",
                            style: TextStyle(color: Color.fromRGBO(63, 61, 86, 1), fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextFormField(
                          controller: descctrl,
                          maxLines: 8,
                          validator: (val) => val!.isEmpty ? 'Veuillez saisir la description' :  null  ,
                          style: TextStyle(color: Color.fromRGBO(63, 61, 86, 1),fontSize: 17,fontWeight: FontWeight.w600),
                          decoration: inputTrans,
                        ),
                        SizedBox(height: 15,),
                        ElevatedButton(
                          onPressed: (){
                            if(buttonText == "Confirmer"){
                              if (_formKey.currentState!.validate()){
                                sendReason();
                              }
                            }else{
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                  EnAttente()), (Route<dynamic> route) => false);
                            }

                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),)
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                          ),
                          child:  Padding(
                            padding:  EdgeInsets.fromLTRB(30, 13, 30, 13),
                            child: Text(
                              "${buttonText}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ) ,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void sendReason() async{
    var url = "http://${global.localhost}/php_project/web-flutter/raison_client.php";
    var data = {
      "sujet" : sujetctrl.text,
      "desc" : descctrl.text,
      "code" : global.client_id,
    };
    var res = await http.post(Uri.parse(url),body: data);
      if(jsonDecode(res.body) == "true"){
        Fluttertoast.showToast(msg: "raison envoy??",toastLength: Toast.LENGTH_SHORT);
        setState(() {
          buttonText = "voir mes rendez-vous";
        });
      }else{
        Fluttertoast.showToast(msg: "Error",toastLength: Toast.LENGTH_SHORT);
      }

  }

}


