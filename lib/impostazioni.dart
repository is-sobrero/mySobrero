import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class ImpostazioniView extends StatelessWidget {
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
                  switchValue: true,
                  onToggle: (bool value) {},
                ),
                SettingsTile(
                  title: 'Esegui il logout',
                  leading: Icon(Icons.exit_to_app),
                  onTap: () {},
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
}
