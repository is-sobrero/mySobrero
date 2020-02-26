# Installare da computer (sideload) il mySobrero su iOS
Tutte le applicazioni per essere eseguite su un dispositivo, qualsiasi
sia il suo sistema operativo, devono essere "firmate" (codesigning) per
assicurare l'origine dell'applicazione e mantenere la sicurezza del
sistema nel massimo della sua integrità. Su Android una volta firmato il
file eseguibile dell'applicazione (file apk) esso può essere installato
su qualsiasi terminale. iOS è bloccato di default (a meno che siano
state eseguite procedure di sblocco es. Jailbreaking) per non permettere
l'installazione di applicazioni da fonti che non siano l'App Store,
tranne se si deve testare l'applicazione durante la procedura di
sviluppo (debug). Xcode, lo strumento di sviluppo per dispositivi Apple,
gestisce questa procedura automaticamente, ma lo strumento è disponibile
solo per Mac. 

# Prerequisiti
- Un computer macOS 
- Tanta pazienza 
- Xcode 10 installato da Mac App Store

# Collegamento del telefono al PC
Collega l'iPhone al PC e assicurati di aver autorizzato il telefono, se
non compare un popup di autorizzazione sul telefono prova a
ricollegarlo, anche con cavi diversi

# Installazione dell'app da terminale
Aprire almeno una volta Xcode e accettare tutte le condizioni che
vengono proposte. Una volta fatto ciò, aprire una finestra di terminale
e digitare (seguiti dal tasto invio) i seguenti comandi:
```bash
mkdir ~/Desktop/mySobrero-source && cd ~/Desktop/mySobrero-source
```
```bash
nano install.sh
```
Dovrebbe apparire una finestra simile a questa:

Copiare (con il tasto Cmd+C) e incollare (con il tasto Cmd+V) il
seguente testo: 
```bash

```
Salvare il file premendo i tasti Control+O e Control+X in seccessione e
digitare i seguenti comandi:
```bash
chmod +x ./install.sh
```
```bash
./install.sh
```
Lo script ora starà scaricando e installando i componenti necessari per
compilare mySobrero. Ad un certo punto si aprirà Xcode, eseguire i
seguenti passaggi:

1. Cliccare due volte su "Runner"
2. Aggiungere un account sviluppatore e in seguito cliccare "Fix it"
3. Se Xcode non riesce a firmare l'app, cambiare il "bundle identifier"
   con una stringa a proprio piacimento.
4. Se compare una schermata simile a questa, chiudere Xcode, ritornare
   su terminale e premere "Invio"

Una volta premuto invio, e se i passaggi sono stati eseguiti
correttamente, dopo che il computer avrà compilato l'applicazione
(dipende dalla velocità del PC, può variare da 10 minuti ad un'ora per
la prima volta) comparirà l'app mySobrero sull'iPhone

# Autorizzazione dell'app
Come qualsiasi app non da App Store, è da autorizzare dalle impostazioni
del telefono. Una volta autorizzata l'app potrà essere usata per i
prossimi 7 giorni, dopo di che è da rifare la procedura da capo.