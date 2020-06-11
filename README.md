<h1 align="center">mySobrero 2.0</h1>

<div align="center">
<img widht="256" height="256" src="assets/icon/ic_launcher_ios.png">
</div>

<br />

<div align="center">
    <!-- Latest Release -->
    <a href="https://github.com/federunco/mySobrero/releases">
      <img alt="GitHub release (latest SemVer)"
      src="https://img.shields.io/github/v/release/federunco/mySobrero">
    </a>
    <a href="https://travis-ci.org/federunco/mySobrero">
      <img alt="Travis CI Status"
      src="https://travis-ci.org/federunco/mySobrero.svg?branch=flutter">
    </a>
</div>

# Tabella dei contenuti

- [Introduzione](#introduzione)
- [Per gli studenti del Sobrero](#per-gli-studenti-del-sobrero)
- [Installazione](#installazione)
  - [Framework Flutter](#framework-flutter)
  - [Clonazione del repository](#clonazione-del-repository)
  - [Compilazione app](#compilazione-app)
  - [Servizi cloud](#servizi-cloud)
- [Statistiche in-app](#statisiche-in-app)
- [Licenza](#licenza)
  - [Autori / Copyright](#autori--copyright)
  - [Licenze componenti di terze parti](##componenti-terze-parti)
  - [Dettagli licenza](#dettagli-licenza)


# Introduzione

Questa repo contiene il codice sorgente del mySobrero 2.0 - Una rivistazione dell'originale mySobrero rilasciato nel 2015, e oramai non più funzionante.

A differenza del mySobrero originale, compatibile solo con Android, il nuovo mySobrero è compatibile con la maggioranza delle piattaforme attuali: Android ed iOS come piattaforme mobile, Windows, macOS e Linux come piattaforme desktop e Web per le rimanenti piattaforme.
La compatibilità cross-platform è garantita da Flutter, framework open-source sviluppato da Google per permettere l'esecuzione della stessa app, dalla stessa base di codice, su molteplici piattaforme.

mySobrero oltre ad essere stato completamente riprogettato da zero, è dotato delle ultime tecnologie per lo sviluppo di app: l'utente non è più limitato al solo registro elettronico, ma le sue credenziali gli danno accesso a tutti i servizi digitali che l'applicazione offre.
Se prima era solo una alternativa al registro elettronico, mySobrero adesso è diventato il centro della vita studentesca: oltre a visualizzare i voti, esso permette di leggere le ultime notizie della scuola, partecipare a sondaggi e pubblicare i propri annunci in una bacheca virtuale (Resell@Sobrero).

Tutti i dati vengono salvati su cloud, garantendo oltre alla coerenza dei dati tra dispositivi diversi loggati con lo stesso account, anche la sicurezza degli stessi, essendo salvati su Firebase di Google, piattaforma di eccellenza per lo sviluppo di app cloud.

# Per gli studenti del Sobrero
mySobrero è un progetto enorme, in continua evoluzione dal 2015, e come aumentano gli studenti frequentanti il Sobrero di anno in anno, anche le esigenze aumentano. La varietà degli studenti del Sobrero non assicura la perfetta compatiblità con mySobrero, è per questo che la segnalazione degli errori al team di sviluppo è fondamentale per mantenere elevata l'esperienza utente.

Se si è verificato un errore nell'applicazione oppure si ha qualche idea per l'applicazione, è disponibile il form di supporto a questo link: https://forms.gle/tDt4RZD1XWK5kkH39 (compilabile solo con account @sobrero)

# Installazione
L'installazione di mySobrero prevede diversi step, sia per preparare l'ambiente di sviluppo che per preparare il dispositivo di destinazione.

## Framework Flutter
mySobrero è basato completamente sul framework Flutter, per procedere con la compilazione dell'applicazione bisogna preparare l'ambiente di sviluppo Flutter nel computer.

L'ambiente Flutter è compatibile con la maggior parte dei sistemi operativi desktop: Windows, macOS, Linux e Chrome OS.

Predisporre l'ambiente di sviluppo secondo le guide linea descritte dalla guida ufficiale: https://flutter.dev/docs/get-started/install

Verificare che l'ambiente di sviluppo sia configurato correttamente lanciando il comando

    flutter doctor

da terminale, se il programma segnala errori, utilizzare le guide ufficiali di Google per risolverli.

## Clonazione del repository
Assicurarsi che git sia installato sul computer.

Avviare una finestra di terminale (o CMD se su Windows), collocarsi nella cartella dove si vuole che venga clonato il repository e lanciare il seguente comando:

    git clone https://github.com/federunco/mySobrero.git mysobrero-repo

Dopo che il comando ha clonato tutto il repository, esso sarà disponibile nella directory "mysobrero-repo".

## Compilazione app
Indipendentemente dal sistema operativo di destinazione, è consigliabile utilizzare Android Studio come ambiente di sviluppo, essendo attualmente l'IDE supportato maggiormente per lo sviluppo Flutter.
Bisognerà inoltre installare il plugin Flutter e Dart per Android Studio.

In base al sistema operativo di destinazione, bisognerà installare diversi strumenti:

- Android
  - Android SDK (incluso in Android Studio)
  - Dispositivo Android con le impostazioni da sviluppatore abilitate
  - Java JDK
- iOS
  - Xcode 11 (da App Store, disponibile solo su macOS)
  - CocoaPods


Se si sta compilando mySobrero su macOS, dopo aver installato Xcode 11 eseguire i seguenti comandi da terminale:

    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    sudo xcodebuild -runFirstLaunch
    sudo xcodebuild -license

Testare la configurazione di macOS lanciando il seguente comando (avvio del simulatore)

    open -a Simulator

Una volta configurato l'ambiente di sviluppo, aprire il progetto con Android Studio, aprire il file pubspeck.yaml e cliccare "Packages get", qui Android Studio sincronizzerà il progetto con le dipendenze richieste.
Se si ha a disposizione il file reapi3.dart (non ancora open-source), spostarlo nella cartella lib.

Ora è possibile compilare l'applicazione: selezionare nel menù in alto a destra il dispositivo di destinazione, dopo averlo collegato al computer, e cliccare dal menù "Run" l'opzione "Flutter run main.dart in Release mode".
Il processo di compilazione è lungo, soprattutto la prima volta, attendere col dispositivo di destinazione collegato al computer per tutta la durata dell'operazione.

## Servizi cloud
mySobrero è strettamente dipendente da Firebase, anche se è in sviluppo un server backend privato, attualmente è la scelta migliore per gestire il cloud dell'applicazione.
Essendo una scelta temporanea Firebase (temporaneità dettata anche dalla incompatibilità con i dispositivi Huawei di nuova generazione) non è stato creato nessun file di configurazione per l'accesso a Firebase, rendendo difficoltosa la modifica del pool di applicazione predefinito.  
E' consigliabile non modificare il pool di applicazioni, essendo configurato per la raccolta dei dati sul pool principale, garantendo statistiche ottimali.

# Statisiche in-app
mySobrero raccoglie statistiche anonime riguardo l'utilizzo dell'app, la frequenza di apertura, gli orari e le schermate aperte. Inoltre viene registrata la classe di appartenenza per effetturare statistiche a livello di istituto riguardo l'utilizzo dell'applicazione.
I dati raccolti sono compatibili con il regolamento GDPR dell'istituto, installando l'applicazione si accetta il trattamento dei dati.

# Licenza
## Autori / Copyright
Copyright 2020 (c) I.S. "A. Sobrero" / Federico Runco
## Dettagli licenza
Il codice sorgente è rilasciato in licenza secondo GNU General Public License v3.0, che garantisce le quattro regole fondamentali del software libero anche sui fork dell'applicazione.
Per maggiori dettagli riguardo la licenza, consultare il file [LICENSE](LICENSE).