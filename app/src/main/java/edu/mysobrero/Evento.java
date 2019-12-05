package edu.mysobrero;

import androidx.annotation.Nullable;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

public class Evento implements Serializable {
    @Nullable
    @SerializedName("giorno")
    String giorno;
    @Nullable
    @SerializedName("mese")
    String mese;
    @Nullable
    @SerializedName("evento")
    String evento;
}
