class reAPI {
  String version;
  Status status;
  User user;
  List<Docenti> docenti;
  List<Regclasse> regclasse;
  List<Comunicazioni> comunicazioni;
  List<Voti> voti;
  List<Compito> compiti;
  Assenze assenze;

  reAPI(
      {this.version,
        this.status,
        this.user,
        this.docenti,
        this.regclasse,
        this.comunicazioni,
        this.voti,
        this.compiti,
        this.assenze});

  reAPI.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['docenti'] != null) {
      docenti = new List<Docenti>();
      json['docenti'].forEach((v) {
        docenti.add(new Docenti.fromJson(v));
      });
    }
    if (json['regclasse'] != null) {
      regclasse = new List<Null>();
      json['regclasse'].forEach((v) {
        regclasse.add(new Regclasse.fromJson(v));
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
    if (json['compiti'] != null) {
      compiti = new List<Null>();
      json['compiti'].forEach((v) {
        compiti.add(new Compito.fromJson(v));
      });
    }
    assenze =
    json['assenze'] != null ? new Assenze.fromJson(json['assenze']) : null;
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
    if (this.docenti != null) {
      data['docenti'] = this.docenti.map((v) => v.toJson()).toList();
    }
    if (this.regclasse != null) {
      data['regclasse'] = this.regclasse.map((v) => v.toJson()).toList();
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

class Regclasse {
  String data;
  List<Argomento> argomenti;

  Regclasse({this.data, this.argomenti});

  Regclasse.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    if (json['argomenti'] != null) {
      argomenti = new List<Argomento>();
      json['argomenti'].forEach((v) {
        argomenti.add(new Argomento.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['argomenti'] = this.argomenti;
    return data;
  }
}

class Argomento {
  String materia;
  String descrizione;

  Argomento({this.materia, this.descrizione});

  Argomento.fromJson(Map<String, dynamic> json) {
    materia = json['materia'];
    descrizione = json['descrizione'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['materia'] = this.materia;
    data['descrizione'] = this.descrizione;
    return data;
  }
}

class Compito {
  String materia;
  String compito;
  String data;

  Compito({this.materia, this.compito, this.data});

  Compito.fromJson(Map<String, dynamic> json) {
    materia = json['materia'];
    compito = json['compito'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['materia'] = this.materia;
    data['compito'] = this.compito;
    data['data'] = this.data;
    return data;
  }
}

class User {
  String matricola;
  String nome;
  String cognome;
  String classe;
  String sezione;
  String corso;
  String periodo;

  User(
      {this.matricola,
        this.nome,
        this.cognome,
        this.classe,
        this.sezione,
        this.corso,
        this.periodo});

  User.fromJson(Map<String, dynamic> json) {
    matricola = json['matricola'];
    nome = json['nome'];
    cognome = json['cognome'];
    classe = json['classe'];
    sezione = json['sezione'];
    corso = json['corso'];
    periodo = json['periodo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matricola'] = this.matricola;
    data['nome'] = this.nome;
    data['cognome'] = this.cognome;
    data['classe'] = this.classe;
    data['sezione'] = this.sezione;
    data['corso'] = this.corso;
    data['periodo'] = this.periodo;
    return data;
  }
}

class Docenti {
  String docente;
  List<String> materie;

  Docenti({this.docente, this.materie});

  Docenti.fromJson(Map<String, dynamic> json) {
    docente = json['docente'];
    materie = json['materie'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['docente'] = this.docente;
    data['materie'] = this.materie;
    return data;
  }
}

class Comunicazioni {
  String data;
  String mittente;
  String contenuto;

  Comunicazioni({this.data, this.mittente, this.contenuto});

  Comunicazioni.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    mittente = json['mittente'];
    contenuto = json['contenuto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['mittente'] = this.mittente;
    data['contenuto'] = this.contenuto;
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

  Voti(
      {this.data,
        this.materia,
        this.tipologia,
        this.voto,
        this.commento,
        this.docente});

  Voti.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    materia = json['materia'];
    tipologia = json['tipologia'];
    voto = json['voto'];
    commento = json['commento'];
    docente = json['docente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['materia'] = this.materia;
    data['tipologia'] = this.tipologia;
    data['voto'] = this.voto;
    data['commento'] = this.commento;
    data['docente'] = this.docente;
    return data;
  }
}

class Assenze {
  List<Nongiustificate> nongiustificate;
  List<Nongiustificate> giustificate;

  Assenze({this.nongiustificate, this.giustificate});

  Assenze.fromJson(Map<String, dynamic> json) {
    if (json['nongiustificate'] != null) {
      nongiustificate = new List<Nongiustificate>();
      json['nongiustificate'].forEach((v) {
        nongiustificate.add(new Nongiustificate.fromJson(v));
      });
    }
    if (json['giustificate'] != null) {
      giustificate = new List<Nongiustificate>();
      json['giustificate'].forEach((v) {
        giustificate.add(new Nongiustificate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.nongiustificate != null) {
      data['nongiustificate'] =
          this.nongiustificate.map((v) => v.toJson()).toList();
    }
    if (this.giustificate != null) {
      data['giustificate'] = this.giustificate.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Nongiustificate {
  String data;
  String motivazione;
  String tipologia;
  String orario;

  Nongiustificate({this.data, this.motivazione, this.tipologia, this.orario});

  Nongiustificate.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    motivazione = json['motivazione'];
    tipologia = json['tipologia'];
    orario = json['orario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['motivazione'] = this.motivazione;
    data['tipologia'] = this.tipologia;
    data['orario'] = this.orario;
    return data;
  }
}