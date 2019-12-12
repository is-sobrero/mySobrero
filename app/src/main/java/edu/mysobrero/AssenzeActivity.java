package edu.mysobrero;

import androidx.appcompat.app.AppCompatActivity;
import androidx.preference.PreferenceManager;

import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.View;
import android.widget.ListView;
import android.widget.TextView;

import com.google.android.material.appbar.MaterialToolbar;

public class AssenzeActivity extends AppCompatActivity {
    REAPIResponse response;

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
        setContentView(R.layout.activity_assenze);
        ListView assG = findViewById(R.id.listaAssenzeG);
        ListView assN = findViewById(R.id.listaAssenzeNG);
        TextView emptyG = findViewById(R.id.emptyAssG);
        TextView emptyN = findViewById(R.id.emptyAssN);
        assG.setEmptyView(emptyG);
        assN.setEmptyView(emptyN);
        MaterialToolbar toolbar = findViewById(R.id.assenzeToolbar);
        Intent intent = getIntent();
        response = (REAPIResponse) intent.getSerializableExtra("reapi");
        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        AdapterAssenze adapterG = new AdapterAssenze(this, R.layout.adapter_assenza, response.assenze.giustificate);
        AdapterAssenze adapterN = new AdapterAssenze(this, R.layout.adapter_assenza, response.assenze.nongiustificate);
        assG.setAdapter(adapterG);
        assN.setAdapter(adapterN);
    }
}
