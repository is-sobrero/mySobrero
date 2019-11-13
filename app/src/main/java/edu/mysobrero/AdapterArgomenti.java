package edu.mysobrero;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

public class AdapterArgomenti extends ArrayAdapter<REAPIResponse.Argomenti> {

    public AdapterArgomenti(Context context, int textViewResourceId,
                                List<REAPIResponse.Argomenti> objects) {
        super(context, textViewResourceId, objects);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) getContext()
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        convertView = inflater.inflate(R.layout.adapter_argomenti, null);
        TextView materia = convertView.findViewById(R.id.argomentoMateria);
        TextView descrizione = convertView.findViewById(R.id.argomentoDesc);
        REAPIResponse.Argomenti c = getItem(position);
        materia.setText(c.materia);
        descrizione.setText(c.descrizione);
        return convertView;
    }
}