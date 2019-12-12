package edu.mysobrero;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.preference.PreferenceManager;

import android.os.Handler;
import android.os.StrictMode;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ProgressBar;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cat.ereza.customactivityoncrash.config.CaocConfig;
import okhttp3.HttpUrl;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import com.google.android.material.dialog.MaterialAlertDialogBuilder;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.SetOptions;
import com.google.gson.Gson;
import com.itkacher.okhttpprofiler.OkHttpProfilerInterceptor;
import com.prof.rssparser.Article;
import com.prof.rssparser.Parser;

public class login extends AppCompatActivity {


    EditText username, password;
    Button login;
    ProgressBar progressBar;
    LinearLayout layout;
    SharedPreferences sharedPref;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        int currentNightMode = getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK;
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this);
        String app_theme = sharedPreferences.getString("app_theme", "system");
        switch (app_theme){
            case "system":
                if (currentNightMode == Configuration.UI_MODE_NIGHT_YES) setTheme(R.style.AppTheme_Night);
                break;
            case "dark":
                setTheme(R.style.AppTheme_Night);
                break;
            default:
                setTheme(R.style.AppTheme);
                break;
        }

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        CaocConfig.Builder.create()
                .backgroundMode(CaocConfig.BACKGROUND_MODE_SILENT)
                .minTimeBetweenCrashesMs(0)
                .errorActivity(CrashHandler.class)
                .apply();



        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder()
                .permitAll().build();
        StrictMode.setThreadPolicy(policy);

        login = findViewById(R.id.login);
        username = findViewById(R.id.studentid);
        password = findViewById(R.id.password);
        progressBar = findViewById(R.id.progressBar);

        Context context = this;
        sharedPref = context.getSharedPreferences(getString(R.string.preferencesIdentifier), Context.MODE_PRIVATE);


        layout = findViewById(R.id.layout);

        Handler handler = new Handler();

        handler.postDelayed(new Runnable() {

            @Override
            public void run() {
                if (sharedPref.getString("savedCredentials", "NO").compareTo("yes") == 0){
                    progressBar.setVisibility(View.VISIBLE);
                    login(
                            sharedPref.getString("username", "NO"),
                            sharedPref.getString("password", "NO")
                    );
                } else {
                    layout.setVisibility(View.VISIBLE);
                }
            }
        }, 1000L);



        login.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                login(username.getText().toString(), password.getText().toString());
            }
        });
    }

    void login(final String username, final String password){
        String urlString = "https://www.sobrero.edu.it/?feed=rss2";
        Parser parser = new Parser();
        parser.execute(urlString);
        progressBar.setVisibility(View.VISIBLE);
        layout.setVisibility(View.GONE);
        parser.onFinish(new Parser.OnTaskCompleted() {
            @Override
            public void onTaskCompleted(ArrayList<Article> list) {
                try {
                    String endp = getString(R.string.endpointURI);
                    FeedClass f = new FeedClass();
                    List<FeedClass.Articolo> listaArticoli = new ArrayList<>();
                    for (Article a : list){
                        FeedClass.Articolo temp = new FeedClass().new Articolo();
                        temp.link = a.getLink();
                        temp.titolo = a.getTitle();
                        temp.urlImmagine = a.getImage();
                        listaArticoli.add(temp);
                    }
                    f.articoli = listaArticoli;
                    HttpUrl.Builder urlBuilder = HttpUrl.parse(endp).newBuilder();
                    urlBuilder.addQueryParameter("uname", username);
                    urlBuilder.addQueryParameter("password", password);
                    String finalUrl = urlBuilder.build().toString();
                    REAPIResponse response = getAPI(finalUrl);
                    if (response.status.code == 1){
                        progressBar.setVisibility(View.GONE);
                        layout.setVisibility(View.VISIBLE);
                        new MaterialAlertDialogBuilder(login.this)
                                .setTitle("Errore nel login!")
                                .setMessage("ID Studente o Password sbagliati!")
                                .setPositiveButton("Ok", null)
                                .show();
                    }
                    if (response.status.code == 0){
                        Evento e = getEvento(getString(R.string.eventsEP));
                        Intent i = new Intent(login.this, MainActivity.class);
                        i.putExtra("reapi", response);
                        i.putExtra("feed", f);
                        i.putExtra("event", e);
                        SharedPreferences.Editor editor = sharedPref.edit();
                        editor.putString("username", username);
                        editor.putString("password", password);
                        editor.putString("savedCredentials", "yes");
                        editor.commit();

                        FirebaseFirestore db = FirebaseFirestore.getInstance();
                        Date currentTime = Calendar.getInstance().getTime();

                        Map<String, Object> user = new HashMap<>();
                        user.put("nome", response.user.nome);
                        user.put("cognome", response.user.cognome);
                        user.put("classe", response.user.classe + " " + response.user.sezione);
                        user.put("ultimo accesso", currentTime.toString());

                        db.collection("utenti").document(username)
                                .set(user, SetOptions.merge());

                        startActivity(i);
                        finish();
                    }
                } catch (Exception e){
                    new MaterialAlertDialogBuilder(login.this)
                            .setTitle("Errore nel login!")
                            .setMessage("Errore sconosciuto: " + e.getLocalizedMessage())
                            .setPositiveButton("Ok", null)
                            .show();
                    progressBar.setVisibility(View.GONE);
                    layout.setVisibility(View.VISIBLE);
                    e.printStackTrace();
                }
            }
            @Override
            public void onError() {
                new MaterialAlertDialogBuilder(login.this)
                        .setTitle("Errore nel login!")
                        .setMessage("Errore durante il download del feed!")
                        .setPositiveButton("Ok", null)
                        .show();
                progressBar.setVisibility(View.GONE);
                layout.setVisibility(View.VISIBLE);
            }
        });
    }

    REAPIResponse getAPI(String url) throws IOException {
        OkHttpClient.Builder builder = new OkHttpClient.Builder();
        if (BuildConfig.DEBUG) {
            builder.addInterceptor(new OkHttpProfilerInterceptor());
        }
        OkHttpClient client = builder.build();
        Request request = new Request.Builder()
                .url(url)
                .build();

        try (Response response = client.newCall(request).execute()) {
            Gson gson = new Gson();
            REAPIResponse resp = gson.fromJson(response.body().charStream(), REAPIResponse.class);
            return resp;
        }
    }

    Evento getEvento(String url) throws IOException {
        OkHttpClient.Builder builder = new OkHttpClient.Builder();
        if (BuildConfig.DEBUG) {
            builder.addInterceptor(new OkHttpProfilerInterceptor());
        }
        OkHttpClient client = builder.build();
        Request request = new Request.Builder()
                .url(url)
                .build();

        try (Response response = client.newCall(request).execute()) {
            Gson gson = new Gson();
            Evento resp = gson.fromJson(response.body().charStream(), Evento.class);
            return resp;
        }
    }

}
