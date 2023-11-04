import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class TermsOfServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Termes et Conditions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''Vos termes et conditions vont ici. Assurez-vous de les rédiger 
          avec l'aide d'un professionnel du droit pour garantir qu'ils sont 
          juridiquement contraignants et appropriés à votre application ou service.
          
          ...
          
          D'autres termes et conditions...
          ''',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
