package edu.mysobrero;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.widget.NestedScrollView;
import androidx.preference.PreferenceManager;
import androidx.viewpager.widget.ViewPager;

import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.os.Bundle;

import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;

import com.google.android.material.appbar.AppBarLayout;
import com.google.android.material.bottomnavigation.BottomNavigationView;

public class MainActivity extends AppCompatActivity {
    REAPIResponse response;
    FeedClass feed;
    Evento evento;

    NestedScrollView scrollView;
    AppBarLayout appBarLayout;

    Button settings;

    private ViewPager viewPager;
    BottomNavigationView navigation;

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
        setContentView(R.layout.activity_main);
        Intent intent = getIntent();
        response = (REAPIResponse) intent.getSerializableExtra("reapi");
        evento = (Evento) intent.getSerializableExtra("event");
        feed = (FeedClass) intent.getSerializableExtra("feed");
        settings = findViewById(R.id.settingsButton);
        scrollView = findViewById(R.id.nestedScrollView);
        appBarLayout = findViewById(R.id.appBar);
        navigation = findViewById(R.id.bottom_navigation);
        viewPager = findViewById(R.id.viewpager);

        scrollView.setOnScrollChangeListener(new NestedScrollView.OnScrollChangeListener() {
            @Override
            public void onScrollChange(NestedScrollView nestedScrollView, int scrollX, int scrollY, int oldScrollX, int oldScrollY) {
                if (scrollY > 0) {
                    appBarLayout.setElevation(10);
                } else {
                    appBarLayout.setElevation(0);
                }
            }
        });

        settings.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v){
                Intent intent = new Intent(MainActivity.this, SettingsActivity.class);
                startActivity(intent);
            }
        });

        viewPager.setOffscreenPageLimit(3);
        CustomFPA adapterFrag = new CustomFPA(getSupportFragmentManager());
        viewPager.setAdapter(adapterFrag);

        navigation.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem menuItem) {
                switch (menuItem.getItemId()) {
                    case R.id.action_home:
                        viewPager.setCurrentItem(0, true);
                        //scrollView.scrollTo(0,0);
                        return true;
                    case R.id.action_voti:
                        viewPager.setCurrentItem(1, true);
                        //scrollView.scrollTo(0,0);
                        return true;
                    case R.id.action_comunicazioni:
                        viewPager.setCurrentItem(2, true);
                        return true;
                    case R.id.action_argomenti:
                        viewPager.setCurrentItem(3, true);
                        return true;
                }
                return false;
            }
        });
    }

    @Override
    public void onBackPressed() {

        if (viewPager.getCurrentItem() != 0) {
            viewPager.setCurrentItem(0,true);
            navigation.setSelectedItemId(R.id.action_home);
        }else{
            finish();
        }

    }

    public void SwitchView(int id){
        navigation.setSelectedItemId(id);
    }
}
