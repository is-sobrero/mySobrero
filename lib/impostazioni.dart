import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImpostazioniView extends StatefulWidget {
  @override
  _ImpostazioniState createState() => _ImpostazioniState();
}

class _ImpostazioniState extends State<ImpostazioniView> {

  @override
  void initState() {
    super.initState();
    _configuraSalvate();
  }

  _configuraSalvate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool bio = await prefs.getBool("biometric_auth") ?? false;
    setState(() {
      bioAuth = bio;
    });
  }

  bool bioAuth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Impostazioni"),
      ),
      body: Center(
        child: SettingsList(
          sections: [
            SettingsSection(
              title: 'Sicurezza',
              tiles: [
                SettingsTile.switchTile(
                  title: 'Accedi a mySobrero tramite autenticazione biometrica',
                  leading: Icon(Icons.fingerprint),
                  switchValue: bioAuth,
                  onToggle: (bool value) {
                    _impostaBool("biometric_auth", value);
                    setState(() {
                      bioAuth = value;
                    });
                  },
                ),
                SettingsTile(
                  title: 'Esegui il logout',
                  leading: Icon(Icons.exit_to_app),
                  onTap: () {
                    _impostaBool("savedCredentials", false);
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Generali',
              tiles: [
                SettingsTile(
                  title: 'Invia un feedback',
                  leading: Icon(Icons.send),
                  onTap: () {},
                ),
                SettingsTile(
                  title: 'Informazioni su mySobrero',
                  leading: Icon(Icons.info_outline),
                  onTap: () {},
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

  _impostaBool(String key, bool value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}
