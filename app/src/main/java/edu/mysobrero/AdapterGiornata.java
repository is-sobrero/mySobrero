package edu.mysobrero;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class AdapterGiornata extends ArrayAdapter<REAPIResponse.Regclasse> {

    public AdapterGiornata(Context context, int textViewResourceId,
                                List<REAPIResponse.Regclasse> objects) {
        super(context, textViewResourceId, objects);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) getContext()
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        convertView = inflater.inflate(R.layout.adapter_giornata, null);
        TextView data = convertView.findViewById(R.id.giornataData);
        REAPIResponse.Regclasse c = getItem(position);
        try {
            Date dataFormattata = new SimpleDateFormat("dd/MM/yyyy").parse(c.data.substring(0, 9));
            DateFormat dateFormat = new SimpleDateFormat("dd MMMM", Locale.ITALY);
            String strDate = dateFormat.format(dataFormattata);
            data.setText(strDate);
        } catch (Exception e){
            e.printStackTrace();
        }


        ListView listView = convertView.findViewById(R.id.listaGiornata);
        AdapterArgomenti adapter = new AdapterArgomenti(getContext(), R.layout.adapter_argomenti, c.argomenti);
        listView.setAdapter(adapter);
        return convertView;
    }
}