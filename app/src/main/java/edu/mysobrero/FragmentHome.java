package edu.mysobrero;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsIntent;
import androidx.fragment.app.Fragment;

import com.google.android.material.card.MaterialCardView;
import com.squareup.picasso.Picasso;

import saschpe.android.customtabs.CustomTabsHelper;
import saschpe.android.customtabs.WebViewFallback;

public class FragmentHome extends Fragment implements View.OnClickListener{
    REAPIResponse response;
    FeedClass feed;

    TextView welcome, info, mittComm, dataComm, comm, art1Titolo, art2Titolo, art3Titolo, lastVoto, lastVotoDesc, compitiCont;
    ImageView art1Img, art2Img, art3Img;

    Button not1, not2, not3;
    MaterialCardView openVoti, openCompiti, openComunicazioni;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_home, container, false);
        MainActivity mainActivity = (MainActivity) getActivity();
        this.response = mainActivity.response;
        this.feed = mainActivity.feed;
        return view;
    }

    @Override
    public void onClick(View v) {
        if (v == not1 || v == not2 || v == not3){
            String url = "";
            if (v == not1) url = this.feed.articoli.get(0).link;
            if (v == not2) url = this.feed.articoli.get(1).link;
            if (v == not3) url = this.feed.articoli.get(2).link;
            CustomTabsIntent customTabsIntent = new CustomTabsIntent.Builder()
                    .addDefaultShareMenuItem()
                    .setShowTitle(true)
                    .build();

            CustomTabsHelper.addKeepAliveExtra(getContext(), customTabsIntent.intent);

            CustomTabsHelper.openCustomTab(getContext(), customTabsIntent,
                    Uri.parse(url),
                    new WebViewFallback());
        }

        MainActivity mainActivity = (MainActivity) getActivity();
        if (v == openVoti) mainActivity.SwitchView(R.id.action_voti);
        if (v == openComunicazioni) mainActivity.SwitchView(R.id.action_comunicazioni);
        if (v == openCompiti){
            Intent intent = new Intent(getActivity(), CompitiActivity.class);
            intent.putExtra("reapi", response);
            startActivity(intent);
        }

    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        welcome = getView().findViewById(R.id.welcomeStud);
        info = getView().findViewById(R.id.studentInfo);
        art1Titolo = getView().findViewById(R.id.art1_titolo);
        art2Titolo = getView().findViewById(R.id.art2_titolo);
        art3Titolo = getView().findViewById(R.id.art3_titolo);
        art1Img = getView().findViewById(R.id.art1_img);
        art2Img = getView().findViewById(R.id.art2_img);
        art3Img = getView().findViewById(R.id.art3_img);
        lastVoto = getView().findViewById(R.id.lastVoto);
        lastVotoDesc = getView().findViewById(R.id.lastVotoDesc);
        compitiCont = getView().findViewById(R.id.compitiCount);
        mittComm = getView().findViewById(R.id.mittenteComm);
        comm = getView().findViewById(R.id.testoComm);
        not1 = getView().findViewById(R.id.art1_btn);
        not2 = getView().findViewById(R.id.art2_btn);
        not3 = getView().findViewById(R.id.art3_btn);
        openVoti = getView().findViewById(R.id.votiCard);
        openCompiti = getView().findViewById(R.id.compitiCard);
        openComunicazioni = getView().findViewById(R.id.comunicazioniCard);

        welcome.setText("Ciao " + this.response.user.nome + "!");
        info.setText(String.format("Classe %s %s - %s", this.response.user.classe, this.response.user.sezione, this.response.user.corso));
        final REAPIResponse.Comunicazioni ultimaComunicazione = response.comunicazioni.get(0);
        mittComm.setText("Ultima comunicazione da " + ultimaComunicazione.mittente);
        comm.setText(ultimaComunicazione.contenuto);
        if (ultimaComunicazione.contenuto.length() > 100)
            comm.setText(ultimaComunicazione.contenuto.substring(0, 100) + "...");
        compitiCont.setText(String.format("%d", this.response.compiti.size()));
        lastVoto.setText(this.response.voti.get(0).voto);
        lastVotoDesc.setText("Ultimo voto preso di " + this.response.voti.get(0).materia);
        art1Titolo.setText(this.feed.articoli.get(0).titolo);
        Picasso.get().load(this.feed.articoli.get(0).urlImmagine).into(art1Img);
        art2Titolo.setText(this.feed.articoli.get(1).titolo);
        Picasso.get().load(this.feed.articoli.get(1).urlImmagine).into(art2Img);
        art3Titolo.setText(this.feed.articoli.get(2).titolo);
        Picasso.get().load(this.feed.articoli.get(2).urlImmagine).into(art3Img);

        openVoti.setOnClickListener(this);
        openCompiti.setOnClickListener(this);
        openComunicazioni.setOnClickListener(this);
        not1.setOnClickListener(this);
        not2.setOnClickListener(this);
        not3.setOnClickListener(this);
    }
}
