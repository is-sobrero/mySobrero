package edu.mysobrero;

import java.io.Serializable;
import java.util.List;

public class FeedClass implements Serializable {
    List<Articolo> articoli;
    class Articolo implements Serializable {
        String titolo;
        String urlImmagine;
        String link;
    }
}
