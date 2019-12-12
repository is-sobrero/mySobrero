package edu.mysobrero;

import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;
import androidx.preference.PreferenceManager;

import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

public class FragmentVoti extends Fragment implements AdapterVoto.EventListener {
    REAPIResponse response;
    ListView listView;
    AutoCompleteTextView listaMaterie;
    AdapterVoto adapter;
    List<REAPIResponse.Voti> voti;
    List<String> materie;
    List<Float> votiFloat;
    TextView mediaView;
    LineChart chart;
    LinearLayout listaVoti;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_voti, container, false);
        MainActivity mainActivity = (MainActivity) getActivity();
        this.response = mainActivity.response;
        return view;

    }
    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        listView = getView().findViewById(R.id.listaVoti);
        TextView periodo = getView().findViewById(R.id.periodoVoti);
        periodo.setText(response.user.periodo);
        chart =  getView().findViewById(R.id.graficoVoti);
        listaMaterie = getView().findViewById(R.id.listaMaterie);
        listaVoti = getView().findViewById(R.id.newListaVoti);
        mediaView = getView().findViewById(R.id.mediaVoti);
        materie = new ArrayList<> ();
        voti = new ArrayList<>();
        materie.add("Tutte le materie");
        for (REAPIResponse.Voti voto: response.voti){
            String materia = voto.materia;
            if (!materie.contains(materia)) materie.add(materia);
        }
        //mediaView.setText("Media attuale:" + calcolaMedia(response.voti));
        listaMaterie.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                FragmentVoti.this.adapter.getFilter().filter(materie.get(position));
            }
        });
        voti = response.voti;
        votiFloat = new ArrayList<>();
        adapter = new AdapterVoto(getContext(), R.layout.adapter_voti, voti, this);
        ArrayAdapter<String> matAdapter = new ArrayAdapter<>(
                getContext(),
                R.layout.dropdown_item,
                materie
        );
        listaMaterie.setAdapter(matAdapter);
        listView.setAdapter(adapter);
        final int adapterCount = adapter.getCount();
        for (int i = 0; i < adapterCount; i++) {
            View item = adapter.getView(i, null, null);
            listaVoti.addView(item);
        }

        FragmentVoti.this.mediaView.setText("Media attuale: " + calcolaMedia(response.voti));
    }

    String calcolaMedia(List<REAPIResponse.Voti> listaVoti){
        votiFloat.clear();
        float media = 0;
        for (REAPIResponse.Voti votoA: listaVoti){
            float votoF = Float.parseFloat(votoA.voto.replace(",", "."));
            media += votoF;
            votiFloat.add(0, votoF);
        }
        media /= listaVoti.size();
        DecimalFormat decimalFormat = new DecimalFormat("#.00");
        String numberAsString = decimalFormat.format(media).replace(".", ",");
        List<Entry> entries = new ArrayList<Entry>();
        for (int i = 0; i < votiFloat.size(); i++) {
            entries.add(new Entry(i, votiFloat.get(i)));
        }
        LineDataSet dataSet = new LineDataSet(entries, "");
        chart.getAxisRight().setEnabled(false);
        chart.getXAxis().setEnabled(false);
        chart.getLegend().setEnabled(false);
        chart.getDescription().setEnabled(false);
        int currentNightMode = getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK;
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(getContext());
        String app_theme = sharedPreferences.getString("app_theme", "system");
        switch (app_theme){
            case "system":
                if (currentNightMode == Configuration.UI_MODE_NIGHT_YES) chart.getAxisLeft().setTextColor(Color.WHITE);
                break;
            case "dark":
                chart.getAxisLeft().setTextColor(Color.WHITE);
                break;
            default:
                break;
        }
        dataSet.setColor(ContextCompat.getColor(getContext(), R.color.colorPrimary));
        dataSet.setCircleColor(ContextCompat.getColor(getContext(), R.color.colorPrimary));
        dataSet.setLineWidth(3);
        dataSet.setDrawValues(false);
        LineData lineData = new LineData(dataSet);
        chart.setData(lineData);
        chart.invalidate();
        return numberAsString;

    }

    public void onEvent(List<REAPIResponse.Voti> votiUpdated) {
        Log.i("REAPI", "Voti filtrati ricevuti");
        FragmentVoti.this.mediaView.setText("Media attuale: " + calcolaMedia(votiUpdated));
    }
}
