package edu.mysobrero;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

public class AdapterVoto extends ArrayAdapter<REAPIResponse.Voti> {

    public AdapterVoto(Context context, int textViewResourceId,
                       List<REAPIResponse.Voti> objects) {
        super(context, textViewResourceId, objects);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) getContext()
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        convertView = inflater.inflate(R.layout.adapter_voti, null);
        TextView voto = convertView.findViewById(R.id.ad_voto);
        TextView materia = convertView.findViewById(R.id.ad_materia);
        TextView data = convertView.findViewById(R.id.ad_data);
        TextView tipo = convertView.findViewById(R.id.ad_tipo);
        REAPIResponse.Voti c = getItem(position);
        voto.setText(c.voto);
        materia.setText(c.materia);
        tipo.setText(c.tipologia);
        data.setText(c.data);
        return convertView;
    }
}