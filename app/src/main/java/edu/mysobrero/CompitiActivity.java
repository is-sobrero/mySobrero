package edu.mysobrero;

import androidx.appcompat.app.AppCompatActivity;
import androidx.preference.PreferenceManager;

import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ListView;

import com.google.android.material.appbar.MaterialToolbar;

public class CompitiActivity extends AppCompatActivity {
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
        setContentView(R.layout.activity_compiti);

        MaterialToolbar toolbar = findViewById(R.id.compitiToolbar);
        Intent intent = getIntent();
        response = (REAPIResponse) intent.getSerializableExtra("reapi");
        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        ListView listView =findViewById(R.id.listaCompiti);
        AdapterCompiti adapter = new AdapterCompiti(this, R.layout.adapter_compiti, response.compiti);
        listView.setAdapter(adapter);
    }
}
