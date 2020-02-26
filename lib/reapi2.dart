class reAPI2 {
  String version;
  Status status;
  User user;
  List<Argomenti> argomenti;
  List<Comunicazioni> comunicazioni;
  List<Voti> voti;
  List<Voti> voti1q;
  List<Voti> voti2q;
  List<Compiti> compiti;
  Assenze assenze;
  List<Pagella> pagelle;
  List<MaterialeDocente> materiale;
  String session;

  reAPI2(
      {this.version,
      this.status,
      this.user,
      this.argomenti,
      this.comunicazioni,
      this.voti,
      this.compiti,
      this.assenze,
      this.pagelle});

  reAPI2.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    status = json['status'] != null ? new Status.fromJson(json['status']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['argomenti'] != null) {
      argomenti = new List<Argomenti>();
      json['argomenti'].forEach((v) {
        argomenti.add(new Argomenti.fromJson(v));
      });
    }
    if (json['comunicazioni'] != null) {
      comunicazioni = new List<Comunicazioni>();
      json['comunicazioni'].forEach((v) {
        comunicazioni.add(new Comunicazioni.fromJson(v));
      });
    }
    if (json['voti'] != null) {
      voti = new List<Voti>();
      json['voti'].forEach((v) {
        voti.add(new Voti.fromJson(v));
      });
    }
    if (json['voti1q'] != null) {
      voti1q = new List<Voti>();
      json['voti1q'].forEach((v) {
        voti1q.add(new Voti.fromJson(v));
      });
    }
    if (json['voti2q'] != null) {
      voti2q = new List<Voti>();
      json['voti2q'].forEach((v) {
        voti2q.add(new Voti.fromJson(v));
      });
    }
    if (json['compiti'] != null) {
      compiti = new List<Compiti>();
      json['compiti'].forEach((v) {
        compiti.add(new Compiti.fromJson(v));
      });
    }
    assenze = json['assenze'] != null ? new Assenze.fromJson(json['assenze']) : null;

    if (json['pagelle'] != null) {
      pagelle = new List<Pagella>();
      json['pagelle'].forEach((v) {
        pagelle.add(new Pagella.fromJson(v));
      });
    }
    if (json['materiale'] != null) {
      materiale = new List<MaterialeDocente>();
      json['materiale'].forEach((v) {
        materiale.add(new MaterialeDocente.fromJson(v));
      });
    }
    session = json['session'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.argomenti != null) {
      data['argomenti'] = this.argomenti.map((v) => v.toJson()).toList();
    }
    if (this.comunicazioni != null) {
      data['comunicazioni'] =
          this.comunicazioni.map((v) => v.toJson()).toList();
    }
    if (this.voti != null) {
      data['voti'] = this.voti.map((v) => v.toJson()).toList();
    }
    if (this.compiti != null) {
      data['compiti'] = this.compiti.map((v) => v.toJson()).toList();
    }
    if (this.assenze != null) {
      data['assenze'] = this.assenze.toJson();
    }
    return data;
  }
}

class Status {
  int code;
  String description;

  Status({this.code, this.description});

  Status.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['description'] = this.description;
    return data;
  }
}

class User {
  String matricola;
  String nome;
  String cognome;
  int classe;
  String sezione;
  String corso;
  String livello;
  String anno;
  List<Curriculum> curriculum;

  User(
      {this.matricola,
      this.nome,
      this.cognome,
      this.classe,
      this.sezione,
      this.corso,
      this.livello,
      this.anno,
      this.curriculum});

  User.fromJson(Map<String, dynamic> json) {
    matricola = json['matricola'];
    nome = json['nome'];
    cognome = json['cognome'];
    classe = json['classe'];
    sezione = json['sezione'];
    corso = json['corso'];
    livello = json['livello'];
    anno = json['anno'];
    if (json['curriculum'] != null) {
      curriculum = new List<Curriculum>();
      json['curriculum'].forEach((v) {
        curriculum.add(new Curriculum.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matricola'] = this.matricola;
    data['nome'] = this.nome;
    data['cognome'] = this.cognome;
    data['classe'] = this.classe;
    data['sezione'] = this.sezione;
    data['corso'] = this.corso;
    data['livello'] = this.livello;
    data['anno'] = this.anno;
    if (this.curriculum != null) {
      data['curriculum'] = this.curriculum.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Curriculum {
  int classe;
  String sezione;
  String corso;
  String credito;
  String esito;
  String anno;

  Curriculum(
      {this.classe,
      this.sezione,
      this.corso,
      this.credito,
      this.esito,
      this.anno});

  Curriculum.fromJson(Map<String, dynamic> json) {
    classe = json['classe'];
    sezione = json['sezione'];
    corso = json['corso'];
    credito = json['credito'];
    esito = json['esito'];
    anno = json['anno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classe'] = this.classe;
    data['sezione'] = this.sezione;
    data['corso'] = this.corso;
    data['credito'] = this.credito;
    data['esito'] = this.esito;
    data['anno'] = this.anno;
    return data;
  }
}

class Argomenti {
  String data;
  String materia;
  String descrizione;
  String oreLezione;

  Argomenti({this.data, this.materia, this.descrizione, this.oreLezione});

  Argomenti.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    materia = json['materia'];
    descrizione = json['descrizione'];
    oreLezione = json['oreLezione'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['materia'] = this.materia;
    data['descrizione'] = this.descrizione;
    data['oreLezione'] = this.oreLezione;
    return data;
  }
}

class Comunicazioni {
  String data;
  String mittente;
  String contenuto;
  String letta;
  String titolo;
  List<Allegato> allegati;

  Comunicazioni(
      {this.data, this.mittente, this.contenuto, this.letta, this.titolo});

  Comunicazioni.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    mittente = json['mittente'];
    contenuto = json['contenuto'];
    letta = json['letta'];
    titolo = json['titolo'];
    if (json['allegati'] != null) {
      allegati = new List<Allegato>();
      json['allegati'].forEach((v) {
        allegati.add(new Allegato.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['mittente'] = this.mittente;
    data['contenuto'] = this.contenuto;
    data['letta'] = this.letta;
    data['titolo'] = this.titolo;
    return data;
  }
}

class Voti {
  String data;
  String materia;
  String tipologia;
  String voto;
  String commento;
  String docente;
  String peso;
  String firmato;
  String firmatoUser;

  Voti(
      {this.data,
      this.materia,
      this.tipologia,
      this.voto,
      this.commento,
      this.docente,
      this.peso,
      this.firmato,
      this.firmatoUser});

  Voti.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    materia = json['materia'];
    tipologia = json['tipologia'];
    voto = json['voto'];
    commento = json['commento'];
    docente = json['docente'];
    peso = json['peso'];
    firmato = json['firmato'];
    firmatoUser = json['firmato_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['materia'] = this.materia;
    data['tipologia'] = this.tipologia;
    data['voto'] = this.voto;
    data['commento'] = this.commento;
    data['docente'] = this.docente;
    data['peso'] = this.peso;
    data['firmato'] = this.firmato;
    data['firmato_user'] = this.firmatoUser;
    return data;
  }
}

class Compiti {
  String data;
  String materia;
  String compito;

  Compiti({this.data, this.materia, this.compito});

  Compiti.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    materia = json['materia'];
    compito = json['compito'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['materia'] = this.materia;
    data['compito'] = this.compito;
    return data;
  }
}

class Assenze {
  List<Assenza> nongiustificate;
  List<Assenza> giustificate;

  Assenze({this.nongiustificate, this.giustificate});

  Assenze.fromJson(Map<String, dynamic> json) {
    if (json['nongiustificate'] != null) {
      nongiustificate = new List<Assenza>();
      json['nongiustificate'].forEach((v) {
        nongiustificate.add(new Assenza.fromJson(v));
      });
    }
    if (json['giustificate'] != null) {
      giustificate = new List<Assenza>();
      json['giustificate'].forEach((v) {
        giustificate.add(new Assenza.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nongiustificate'] =
        this.nongiustificate.map((v) => v.toJson()).toList();
    if (this.giustificate != null) {
      data['giustificate'] = this.giustificate.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Assenza {
  String data;
  String motivazione;
  String tipologia;
  String orario;
  String calcolo;

  Assenza(
      {this.data, this.motivazione, this.tipologia, this.orario, this.calcolo});

  Assenza.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    motivazione = json['motivazione'];
    tipologia = json['tipologia'];
    orario = json['orario'];
    calcolo = json['calcolo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['motivazione'] = this.motivazione;
    data['tipologia'] = this.tipologia;
    data['orario'] = this.orario;
    data['calcolo'] = this.calcolo;
    return data;
  }
}

class Pagella {
  String periodo;
  String esito;
  String giudizio;
  double media;
  List<VotoPagella> materie;

  Pagella({
    this.periodo,
    this.esito,
    this.giudizio,
    this.media,
    this.materie
  });

  Pagella.fromJson(Map<String, dynamic> json) {
    periodo = json['periodo'];
    esito = json['esito'];
    giudizio = json['giudizio'];
    media = json['media'];
    if (json['materie'] != null) {
      materie = new List<VotoPagella>();
      json['materie'].forEach((v) {
        materie.add(new VotoPagella.fromJson(v));
      });
    }
  }

/*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['description'] = this.description;
    return data;
  }*/
}

class Allegato {
  String url;
  String nome;

  Allegato({
    this.url,
    this.nome,
  });

  Allegato.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    nome = json['nome'];
  }
}


class VotoPagella {
  String materia;
  int assenze;
  int voto;

  VotoPagella({
    this.materia,
    this.assenze,
    this.voto,
  });

  VotoPagella.fromJson(Map<String, dynamic> json) {
    materia = json['materia'];
    assenze = json['assenze'];
    voto = json['voto'];
  }
}

class MaterialeDocente {
  String docente;
  String id;
  List<Cartella> cartelle;
  MaterialeDocente.fromJson(Map<String, dynamic> json){
    if (json['cartelle'] != null) {
      id = json['id'];
      docente = json['docente'];
      cartelle = new List<Cartella>();
      json['cartelle'].forEach((v) {
        cartelle.add(new Cartella.fromJson(v));
      });
    }
  }
}

class Cartella {
  int id;
  String descrizione;
  Cartella.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descrizione = json['descrizione'];
  }
}

class File {
  String nome;
  String url;
  String filename;
  File.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    url = json['url'];
    filename = json['filename'];
  }
}