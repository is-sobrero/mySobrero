package edu.mysobrero;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;

import cat.ereza.customactivityoncrash.CustomActivityOnCrash;

public class CrashHandler extends AppCompatActivity {
TextView crashCause;
Button restartApp;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_crash);
        CustomActivityOnCrash.getStackTraceFromIntent(getIntent());
        crashCause = findViewById(R.id.crashCause);
        restartApp = findViewById(R.id.restartApp);
        String cause = CustomActivityOnCrash.getStackTraceFromIntent(getIntent()).split("at")[0];
        crashCause.setText(cause);
    }
}
