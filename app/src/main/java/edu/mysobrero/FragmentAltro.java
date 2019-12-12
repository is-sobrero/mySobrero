package edu.mysobrero;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.google.android.material.card.MaterialCardView;


public class FragmentAltro extends Fragment implements View.OnClickListener {
    REAPIResponse response;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_altro, container, false);
        MainActivity mainActivity = (MainActivity) getActivity();
        this.response = mainActivity.response;
        return view;

    }
    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        /*ListView listView = getView().findViewById(R.id.listaComunicazioni);
        AdapterComunicazioni adapter = new AdapterComunicazioni(getContext(), R.layout.adapter_comunicazioni, response.comunicazioni);
        listView.setAdapter(adapter);*/
        MaterialCardView card = getView().findViewById(R.id.assenzeCard);
        card.setOnClickListener(this);
    }

    @Override
    public void onClick(View v){
        Intent intent = new Intent(getActivity(), AssenzeActivity.class);
        intent.putExtra("reapi", response);
        startActivity(intent);
    }
}
