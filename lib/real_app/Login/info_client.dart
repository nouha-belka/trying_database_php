import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trying_database_php/real_app/Login/confirmer_inscription.dart';
import 'package:trying_database_php/real_app/help/constants.dart';
import 'package:http/http.dart' as http;
import '../library.dart' as global;

class infoClientForm extends StatefulWidget {
  const infoClientForm({Key? key}) : super(key: key);

  @override
  _infoClientFormState createState() => _infoClientFormState();
}

class _infoClientFormState extends State<infoClientForm> {
  late TextEditingController  nomCtrl, prenomCtrl,dateCtrl,telCtrl,emailCtrl;
  final _formKey = GlobalKey<FormState>();
  String? code;
  bool processing = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nomCtrl =  TextEditingController();
    prenomCtrl =  TextEditingController();
    dateCtrl =  TextEditingController();
    telCtrl =  TextEditingController();
    emailCtrl =  TextEditingController();
  }
  void generateId() async{
    setState(() {
      processing = true;
    });
    // while(true){
    //   code = random.nextInt(100000) + 10;
    //   print(code.toString());
    //   var url = "http://192.168.56.1/php_project/web-flutter/check_code.php";
    //   var data = {
    //     "code" : code.toString(),
    //   };
    //   var res = await http.post(Uri.parse(url),body: data);
    //   if(jsonDecode(res.body) == "false"){
    //     break;
    //   }
    // }
    var url = "http://${global.localhost}/php_project/web-flutter/check_code.php";
    var res = await http.get(Uri.parse(url));
    // print(jsonDecode(res.body));
    String response = jsonDecode(res.body);
    if(response != "false"){
      code = response.toString();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  Confirmer(code: code!,nom: nomCtrl.text,prenom: prenomCtrl.text,date: dateCtrl.text,tel: telCtrl.text,email: emailCtrl.text)),
      );
    }


    setState(() {
      processing = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: mainColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        containerShadow
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 30),
                    child: Column(
                      children: [
                        SizedBox(height: 30 ,),
                        TextFormField(
                            controller: nomCtrl,
                            validator: (val) => val!.isEmpty ? 'Veuillez saisir le nom' : RegExp(r"^[a-zA-Z ,.'-]{2,}").hasMatch(val) ? null : 'Nom invalide' ,
                            decoration: textInputDeco.copyWith(labelText: "Nom",hintText: 'Nom', prefixIcon: Icon(
                              Icons.account_circle,
                              color: Colors.grey[600],
                            ),)
                        ),
                        SizedBox(height: 15 ,),
                        TextFormField(
                            controller: prenomCtrl,
                            validator: (val) => val!.isEmpty ? 'Veuillez saisir le pr??nom' : RegExp(r"^[a-zA-Z ,.'-]{2,}").hasMatch(val) ? null : 'Pr??nom invalide' ,
                            decoration: textInputDeco.copyWith(labelText: "Pr??nom",hintText: 'Pr??nom' , prefixIcon: Icon(
                              Icons.account_circle,
                              color: Colors.grey[600],
                            ),)
                        ),
                        SizedBox(height: 15 ,),
                        TextFormField(
                            controller: dateCtrl,
                            validator: (val) => val!.isEmpty ? 'Veuillez saisir la date' :  null  ,
                            decoration: textInputDeco.copyWith(labelText: "Date de naissance",hintText: 'Date de naissance' , prefixIcon: Icon(
                              Icons.calendar_today_sharp,
                              color: Colors.grey[600],
                            ),),
                          readOnly: true,  //set it true, so that user will not able to edit text
                          onTap: () async {
                             var  date = await datePick( context);
                            setState(() {
                              dateCtrl.text = date;
                            });

                          },
                        ),
                        SizedBox(height: 15 ,),
                        TextFormField(
                            controller: telCtrl,
                            keyboardType: TextInputType. number,
                            validator: (val) => val!.isEmpty ? 'Veuillez saisir le num??ro de t??l??phone' : RegExp(r"^(0)(2|5|6|7)[0-9]{8}").hasMatch(val) ? null : 'Num??ro invalide' ,
                            decoration: textInputDeco.copyWith(labelText: "Num??ro de T??l??phone",hintText: 'Num??ro de T??l??phone' , prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.grey[600],
                            ),)
                        ),
                        SizedBox(height: 15 ,),
                        TextFormField(
                            controller: emailCtrl,
                            validator: (val) => val!.isEmpty ? 'Veuillez saisir l\'email' : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#%&'*+-/=?^_{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : 'Email invalide' ,
                            decoration: textInputDeco.copyWith(labelText: "Email",hintText: 'Email' , prefixIcon: Icon(
                              Icons.email,
                              color: Colors.grey[600],
                            ),)
                        ),
                        SizedBox(height: 50 ,),
                        ElevatedButton(
                          onPressed: (){
                            if (_formKey.currentState!.validate()){
                              generateId();
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
                            child: processing == false ? Text(
                              "Cre??r compte",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ) : spinkit,
                          ),
                        ),
                        SizedBox(height: 20 ,),

                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
