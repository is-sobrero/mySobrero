package edu.mysobrero;

import androidx.annotation.Nullable;

import java.io.Serializable;
import java.util.List;

import com.google.gson.annotations.SerializedName;

public class REAPIResponse implements Serializable {
    @Nullable
    @SerializedName("version")
     String version;
    @Nullable
    @SerializedName("authenticationHeader")
     AuthenticationHeader authenticationHeader;
    @Nullable
    @SerializedName("status")
     Status status;
    @Nullable
    @SerializedName("user")
     User user;
    @Nullable
    @SerializedName("docenti")
     List<Docenti> docenti;
    @Nullable
    @SerializedName("regclasse")
     List<Regclasse> regclasse;
    @Nullable
    @SerializedName("comunicazioni")
     List<Comunicazioni> comunicazioni;
    @Nullable
    @SerializedName("voti")
    List<Voti> voti;
    @Nullable
    @SerializedName("compiti")
    List<Compiti> compiti;

    class AuthenticationHeader implements Serializable {
        @Nullable
        @SerializedName("antixsrf")
         String antixsrf;
        @Nullable
        @SerializedName("asp_sessionID")
         String aspSessionID;
    }

    class Status implements Serializable {
        @SerializedName("code")
         int code;
        @Nullable
        @SerializedName("description")
         String description;
    }

    class User implements Serializable {
        @Nullable
        @SerializedName("matricola")
         String matricola;
        @Nullable
        @SerializedName("nome")
         String nome;
        @Nullable
        @SerializedName("cognome")
         String cognome;
        @Nullable
        @SerializedName("classe")
         String classe;
        @Nullable
        @SerializedName("sezione")
         String sezione;
        @Nullable
        @SerializedName("corso")
         String corso;
        @Nullable
        @SerializedName("periodo")
         String periodo;
    }

    class Docenti implements Serializable {
        @Nullable
        @SerializedName("docente")
         String docente;
        @Nullable
        @SerializedName("materie")
         List<String> materie;
    }

    class Regclasse implements Serializable {
        @Nullable
        @SerializedName("data")
         String data;
        @Nullable
        @SerializedName("argomenti")
         List<Argomenti> argomenti;
    }

    class Argomenti implements Serializable{
        @Nullable
        @SerializedName("materia")
         String materia;
        @Nullable
        @SerializedName("descrizione")
         String descrizione;
    }

    class Comunicazioni implements Serializable{
        @Nullable
        @SerializedName("data")
         String data;
        @Nullable
        @SerializedName("mittente")
         String mittente;
        @Nullable
        @SerializedName("contenuto")
         String contenuto;
    }

    class Voti implements Serializable{
        @Nullable
        @SerializedName("data")
         String data;
        @Nullable
        @SerializedName("materia")
         String materia;
        @Nullable
        @SerializedName("tipologia")
         String tipologia;
        @Nullable
        @SerializedName("voto")
         String voto;
        @Nullable
        @SerializedName("commento")
         String commento;
        @Nullable
        @SerializedName("docente")
         String docente;
    }

    class Compiti implements Serializable{
        @Nullable
        @SerializedName("materia")
         String materia;
        @Nullable
        @SerializedName("compito")
         String compito;
        @Nullable
        @SerializedName("data")
         String data;
    }
}

