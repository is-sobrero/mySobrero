package edu.mysobrero;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.List;

public class AdapterVoto extends ArrayAdapter<REAPIResponse.Voti> {
    public AdapterVoto(Context context, int textViewResourceId,
                       List<REAPIResponse.Voti> objects, EventListener listener) {
        super(context, textViewResourceId, objects);
        this.listener = listener;
    }

    EventListener listener;

    public interface EventListener {
        void onEvent();
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
        TextView commento = convertView.findViewById(R.id.ad_comm);
        Button expand = convertView.findViewById(R.id.ad_expandButton);
        final LinearLayout expandView = convertView.findViewById(R.id.ad_expandView);
        expand.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (expandView.getVisibility() == View.GONE){
                    expandView.setVisibility(View.VISIBLE);
                } else {
                    expandView.setVisibility(View.GONE);
                }
                listener.onEvent();
            }
        });
        REAPIResponse.Voti c = getItem(position);
        voto.setText(c.voto);
        materia.setText(c.materia);
        tipo.setText(c.tipologia);
        data.setText(c.data);
        if (c.commento.length() > 0) commento.setText(c.commento);
        return convertView;
    }
}