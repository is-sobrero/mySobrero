package edu.mysobrero;

import androidx.appcompat.app.AppCompatActivity;
import androidx.preference.PreferenceManager;

import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;

import cat.ereza.customactivityoncrash.CustomActivityOnCrash;

public class CrashHandler extends AppCompatActivity {
TextView crashCause;
Button restartApp;
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
        setContentView(R.layout.activity_crash);
        CustomActivityOnCrash.getStackTraceFromIntent(getIntent());
        crashCause = findViewById(R.id.crashCause);
        restartApp = findViewById(R.id.restartApp);
        String cause = CustomActivityOnCrash.getStackTraceFromIntent(getIntent()).split("at")[0];
        crashCause.setText(cause);
    }
}
