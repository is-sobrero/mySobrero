package edu.mysobrero;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

public class AdapterVoto extends ArrayAdapter<REAPIResponse.Voti> implements Filterable {
    public AdapterVoto(Context context, int textViewResourceId,
                       List<REAPIResponse.Voti> objects, EventListener listener) {
        super(context, textViewResourceId, objects);
        this.listener = listener;
        this.voti = objects;
        this.votiOriginali = objects;
    }
    List<REAPIResponse.Voti> voti;
    List<REAPIResponse.Voti> votiOriginali;
    public EventListener listener;

    public interface EventListener {
        void onEvent(List<REAPIResponse.Voti> votiUpdated);
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
            }
        });
        REAPIResponse.Voti c = voti.get(position);
        voto.setText(c.voto);
        materia.setText(c.materia);
        tipo.setText(c.tipologia);
        data.setText(c.data);
        if (c.commento.length() > 0) commento.setText(c.commento);
        return convertView;
    }

    @Override
    public int getCount() {
        return voti.size();
    }

    @Override
    public Filter getFilter() {

        Filter filter = new Filter() {

            @SuppressWarnings("unchecked")
            @Override
            protected void publishResults(CharSequence constraint, FilterResults results) {

                voti = (List<REAPIResponse.Voti>) results.values;
                listener.onEvent(voti);
                notifyDataSetChanged();
            }

            @Override
            protected FilterResults performFiltering(CharSequence constraint) {
                FilterResults results = new FilterResults();
                ArrayList<REAPIResponse.Voti> FilteredArrayNames = new ArrayList<>();
                constraint = constraint.toString().toLowerCase();
                for (int i = 0; i < votiOriginali.size(); i++) {
                    String dataNames = votiOriginali.get(i).materia;
                    if (dataNames.toLowerCase().startsWith(constraint.toString()))  {
                        FilteredArrayNames.add(votiOriginali.get(i));
                    }
                }
                Log.i("OK", constraint.toString());
                if (constraint.toString().equals("tutte le materie")){
                    results.values = votiOriginali;
                    results.count = votiOriginali.size();
                } else {
                    results.values = FilteredArrayNames;
                    results.count = FilteredArrayNames.size();
                }
                return results;
            }
        };

        return filter;
    }
}