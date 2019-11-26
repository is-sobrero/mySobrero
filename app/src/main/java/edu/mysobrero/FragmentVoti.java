package edu.mysobrero;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

public class FragmentVoti extends Fragment implements AdapterVoto.EventListener {
    REAPIResponse response;
    ListView listView;
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
        AdapterVoto adapter = new AdapterVoto(getContext(), R.layout.adapter_voti, response.voti, this);

        listView.setAdapter(adapter);
    }

    public void onEvent() {
        listView.invalidate();
        Log.i("LW", "ONLAYOUT");
    }
}
