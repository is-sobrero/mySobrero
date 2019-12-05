package edu.mysobrero;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;

import androidx.appcompat.app.AppCompatActivity;
import androidx.preference.ListPreference;
import androidx.preference.Preference;
import androidx.preference.PreferenceFragmentCompat;

import com.google.android.material.appbar.MaterialToolbar;
import com.google.android.material.snackbar.Snackbar;

public class SettingsActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);

        MaterialToolbar toolbar = findViewById(R.id.settingsToolbar);

        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        getSupportFragmentManager()
                .beginTransaction()
                .replace(R.id.settings, new SettingsFragment())
                .commit();

    }

    public static class SettingsFragment extends PreferenceFragmentCompat {
        @Override
        public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
            setPreferencesFromResource(R.xml.root_preferences, rootKey);
            Preference myPref = (Preference) findPreference("logout");
            ListPreference darkMode = findPreference("app_theme");
            myPref.setOnPreferenceClickListener(new Preference.OnPreferenceClickListener() {
                public boolean onPreferenceClick(Preference preference) {
                    SharedPreferences sharedPref = getContext().getSharedPreferences(getString(R.string.preferencesIdentifier), Context.MODE_PRIVATE);
                    SharedPreferences.Editor editor = sharedPref.edit();
                    editor.putString("savedCredentials", "NO");
                    editor.commit();
                    View contextView = getActivity().findViewById(R.id.context_view);
                    Snackbar.make(contextView, R.string.logoutString, Snackbar.LENGTH_LONG)
                            .show();
                    return true;
                }
            });

            darkMode.setOnPreferenceChangeListener(new Preference.OnPreferenceChangeListener() {
                public boolean onPreferenceChange(Preference preference, Object newValue) {
                    View contextView = getActivity().findViewById(R.id.context_view);
                    Snackbar.make(contextView, R.string.themeChangeString, Snackbar.LENGTH_LONG)
                            .show();

                    return true;
                }
            });
        }

    }
}