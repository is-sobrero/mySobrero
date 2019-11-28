package edu.mysobrero;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

public class AdapterCompiti extends ArrayAdapter<REAPIResponse.Compiti> {
    public AdapterCompiti(Context context, int textViewResourceId,
                                List<REAPIResponse.Compiti> objects) {
        super(context, textViewResourceId, objects);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) getContext()
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        convertView = inflater.inflate(R.layout.adapter_compiti, null);
        TextView data = convertView.findViewById(R.id.dataCompito);
        TextView materia = convertView.findViewById(R.id.materiaCompito);
        TextView contenuto = convertView.findViewById(R.id.descCompito);
        REAPIResponse.Compiti c = getItem(position);
        data.setText(c.data);
        contenuto.setText(c.compito);
        materia.setText(c.materia);
        return convertView;
    }
}
