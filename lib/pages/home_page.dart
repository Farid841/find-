import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:torch_controller/torch_controller.dart';
import 'package:flutter_background_service/flutter_background_service.dart';






// Constantes de couleurs
const kPrimaryColor = Color(0xFFF1F4F8);
const kIconColor = Color(0xFF32597A);
const kTextColor = Color(0xFF14181B);
const kSecondaryTextColor = Color(0xFF6F94AB);
const kBoxShadowColor = Color(0x3416202A);



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}





class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isActivated = false;
  Map<String, bool> switchStates = {};
  // Ajouter ces deux lignes pour la reconnaissance vocale et le contrôleur
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextEditingController _controller = TextEditingController();



  @override
  void dispose() {
    // Assurez-vous de nettoyer après les contrôleurs lorsque le widget est disposé.
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kPrimaryColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }



  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: kIconColor, size: 30),
        onPressed: () => print('IconButton pressed ...'),
      ),
      title: Text(
        'Home',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          color: kTextColor,
          fontSize: 16,
        ),
      ),
      elevation: 0,
    );
  }



  Widget _buildBody() {
    return SafeArea(
      top: true,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildPowerButton(),
          SizedBox(height: 20),
          Text(
            isActivated ? "Désactivé" : "Activé",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        _buildSectionHeader('Actions'),
          _buildListItem(Icons.vibration, 'Vibration'),
          _buildListItem(Icons.flashlight_on, 'Flash'),
          Divider(color: Colors.grey, thickness: 2.0),
          _buildSectionHeader('Mot de detection'),
          _buildMicroTextField(),
        ],
      ),
    );
  }


  Widget _buildPowerButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() => isActivated = !isActivated);
        if (isActivated) {
          _startListening();
        } else {
          _stopListening();
        }
      },
      child: Icon(Icons.power_settings_new_outlined, color: Color(0xff000000)),
      style: ElevatedButton.styleFrom(
        primary: isActivated ? Colors.red : Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        fixedSize: Size(50, 50),
      ),
    );
  }




  void _startListening() async {
    FlutterBackgroundService.initialize(onStart);

    final service = FlutterBackgroundService();


    // Assurez-vous que vous avez déclaré _triggerWord quelque part dans la classe pour stocker le mot déclencheur
    String _triggerWord = ""; // Ou toute autre valeur que vous attendez

    if (!_speech.isListening) {
      bool available = await _speech.initialize();
      if (available) {
        _speech.listen(onResult: (result) {
          // Utilisez une variable locale pour stocker le mot entendu
          _triggerWord = result.recognizedWords;

          // Compare les mots entendus avec le mot déclencheur (ignorer la casse)
          if (_controller.text.toLowerCase() == _triggerWord.toLowerCase()) {
            _performActions();
          }
        });
      }
    }
  }

  void onStart() {
    WidgetsFlutterBinding.ensureInitialized();
    final service = FlutterBackgroundService();

    // La tâche en arrière-plan pour gérer la reconnaissance vocale
    service.onDataReceived.listen((event) {
      if (event!["action"] == "startListening") {
        // Code pour démarrer la reconnaissance vocale
      } else if (event["action"] == "stopListening") {
        // Code pour arrêter la reconnaissance vocale
      }
    });

    service.setAutoStartOnBootMode(true);
  }


  void _stopListening() {
    if (_speech.isListening) {
      _speech.stop();
    }
  }


  void _performActions() {
    if (switchStates['Vibration'] == true) {
      // Ajoutez du code pour faire vibrer le téléphone
    }
    if (switchStates['Flash'] == true) {
      _toggleFlash(true);
    }
    else {
      _toggleFlash(false);
    }
  }


  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          color: kSecondaryTextColor,
          fontSize: 16,
        ),
      ),
    );
  }


  Widget _buildMicroTextField() {
    // Remove the local declaration of TextEditingController.
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13),
      child: Container(
        decoration: _buildBoxDecoration(),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller, // Use the class-level _controller here.
                enabled: false, // Keep this as is if you want to keep the TextField disabled.
                decoration: InputDecoration(
                  hintText: "Parlez maintenant",
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.mic, color: kSecondaryTextColor, size: 26),
              onPressed: _listen, // Use the _listen method as before.
            ),
          ],
        ),
      ),
    );
  }


  void _listen() async {
    if (!_speech.isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('STATUS: $status'),
        onError: (error) => print('ERROR: $error'),
      );
      if (available) {
        _speech.listen(
          onResult: (result) {
            _controller.text = result.recognizedWords;
            print('Mots reconnus: ${result.recognizedWords}');  // Ajout de cette ligne
          },
        );
      }
    } else {
      _speech.stop();
    }
  }


  void _toggleFlash(bool value) async {
    // if (value) {
    //   // Check if the device has a flashlight
    //   hasTorch = await _torchController.toggle(intensity: 1);
    //   if (hasTorch) {
    //     await _torchController.turnOn(); // Turn on the torch
    //   }
    // } else {
    //   await _torchController.turnOff(); // Turn off the torch
    // }
  }


  Widget _buildListItem(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Container(
        height: 60,
        decoration: _buildBoxDecoration(),
        child: Row(
          children: [
            SizedBox(width: 8),
            Icon(icon, color: kSecondaryTextColor, size: 24),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: kTextColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Switch(
              value: switchStates[title] ?? false,
              onChanged: (bool value) {
                setState(() => switchStates[title] = value);
                if (title == 'Flash') {
                  _toggleFlash(value);
                }
              },
              activeColor: kSecondaryTextColor,
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }


  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [BoxShadow(blurRadius: 5, color: kBoxShadowColor, offset: Offset(0, 2))],
      borderRadius: BorderRadius.circular(12),
    );
  }
}




void main() => runApp(MaterialApp(home: HomePage()));
