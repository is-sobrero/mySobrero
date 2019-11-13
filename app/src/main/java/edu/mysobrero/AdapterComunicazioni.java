package edu.mysobrero;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

public class AdapterComunicazioni extends ArrayAdapter<REAPIResponse.Comunicazioni> {

    public AdapterComunicazioni(Context context, int textViewResourceId,
                       List<REAPIResponse.Comunicazioni> objects) {
        super(context, textViewResourceId, objects);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) getContext()
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        convertView = inflater.inflate(R.layout.adapter_comunicazioni, null);
        TextView mittente = convertView.findViewById(R.id.comunicazioneMittente);
        TextView contenuto = convertView.findViewById(R.id.comunicazioneContenuto);
        REAPIResponse.Comunicazioni c = getItem(position);
        mittente.setText(c.mittente);
        contenuto.setText(c.contenuto);
        return convertView;
    }
}