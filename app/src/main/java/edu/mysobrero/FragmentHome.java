package edu.mysobrero;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.squareup.picasso.Picasso;

public class FragmentHome extends Fragment {
    REAPIResponse response;
    FeedClass feed;

    TextView welcome, info, mittComm, dataComm, comm, art1Titolo, art2Titolo, art3Titolo, lastVoto, lastVotoDesc, compitiCont;
    ImageView art1Img, art2Img, art3Img;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_home, container, false);
        MainActivity mainActivity = (MainActivity) getActivity();
        this.response = mainActivity.response;
        this.feed = mainActivity.feed;
        return view;
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


    }
}
