package edu.mysobrero;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

public class AdapterAssenze extends ArrayAdapter<REAPIResponse.Assenza> {
    public AdapterAssenze(Context context, int textViewResourceId,
                          List<REAPIResponse.Assenza> objects) {
        super(context, textViewResourceId, objects);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) getContext()
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        convertView = inflater.inflate(R.layout.adapter_assenza, null);
        TextView desc = convertView.findViewById(R.id.typeAssenza);
        TextView motivo = convertView.findViewById(R.id.motivoAssenza);
        REAPIResponse.Assenza c = getItem(position);
        if (c.tipologia == "Assenza") desc.setText("Assenza del " + c.data);
        else desc.setText(c.tipologia + " alle ore " + c.orario + " del " + c.data );
        motivo.setText("Motivazione: " + c.motivazione);
        return convertView;
    }
}
