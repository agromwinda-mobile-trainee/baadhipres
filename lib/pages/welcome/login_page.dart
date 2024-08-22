

import 'dart:developer';

import 'package:baadhi_pres/Home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String erreur ="";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      log("login ${_emailController.text} - ${_emailController.text}");
      if (userCredential.user != null) {
        // userCredential.user.
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      }
    } catch (e) {
      erreur ="votre mot de passe ou adresse mail n'est pas (ne sont pas) correct(s)";
      print("$e il y a une erreur"); // Gérer les erreurs d'authentification
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Logo
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 200,
                      ),
                    ),
                    // Texte d'introduction
                  const  Text(
                      'Bienvenu(e)',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(erreur,style: const TextStyle(
                    color: Colors.red
                  ),),
                  const  SizedBox(height: 16),
                    // Champ numéro de téléphone
                    TextField(
                   controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Adresse mail',
                        border: OutlineInputBorder(),
                      ),
                    ),
                 const   SizedBox(height: 16),
                    // Champ mot de passe
                    TextField(
                   controller:  _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  const  SizedBox(height: 16),
                    // Bouton de connexion
                    ElevatedButton(
                      onPressed: () {

                        signInWithEmailAndPassword();
                        setState(() {
                          erreur;
                        });
                      },
                      child: Text('Connexion'),
                    ),
                 const   SizedBox(height: 16),
                    // Texte "powered by"
                 const   Text(
                      'Powered by Agromwinda',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
