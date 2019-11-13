package edu.mysobrero;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

public class FragmentArgomenti extends Fragment{
    REAPIResponse response;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_argomenti, container, false);
        MainActivity mainActivity = (MainActivity) getActivity();
        this.response = mainActivity.response;
        return view;
    }
    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        ListView listView = getView().findViewById(R.id.listaArgomenti);
        AdapterGiornata adapter = new AdapterGiornata(getContext(), R.layout.adapter_giornata, response.regclasse);
        listView.setAdapter(adapter);
    }
}

