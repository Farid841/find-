import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void _shareApp() {
    final String message = "Découvrez cette incroyable application! [lien de votre application]";
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    _setSystemUIOverlayStyle(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF1F4F8),
        appBar: _buildAppBar(),
        body: SafeArea(
          top: true,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildSectionHeader('Account'),
              _buildListItem(Icons.notifications_none, 'Alarm choice'),
              _buildSectionHeader('General'),
              _buildListItem(Icons.privacy_tip_rounded, 'Terms of Service'),
              _buildListItem(Icons.ios_share, 'Invite Friends', onTap: _shareApp),
              _buildListItem(Icons.star, 'Rate us'),
            ],
          ),
        ),
      ),
    );
  }

  void _setSystemUIOverlayStyle(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
        ),
      );
    }
  }

  AppBar _buildAppBar() => AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    leading: IconButton(
      icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF14181B), size: 30),
      onPressed: () => print('IconButton pressed ...'),
    ),
    title: _buildStyledText('Settings'),
    actions: [],
    centerTitle: false,
    elevation: 0,
  );

  Text _buildStyledText(String title) => Text(
    title,
    style: TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      color: Color(0xFF14181B),
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
  );

  Widget _buildSectionHeader(String title) => Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: _buildStyledText(title),
  );

  Widget _buildListItem(IconData icon, String title, {VoidCallback? onTap}) => Padding(
    padding: EdgeInsets.symmetric(vertical: 12),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Color(0x3416202A),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(width: 8),
            Icon(icon, color: Color(0xFF57636C), size: 24),
            Expanded(child: Padding(padding: EdgeInsets.only(left: 12), child: _buildStyledText(title))),
            Icon(Icons.arrow_forward_ios, color: Color(0xFF57636C), size: 18),
            SizedBox(width: 8),
          ],
        ),
      ),
    ),
  );
}
