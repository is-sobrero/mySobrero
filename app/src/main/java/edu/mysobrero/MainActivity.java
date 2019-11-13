package edu.mysobrero;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.widget.NestedScrollView;
import androidx.viewpager.widget.ViewPager;

import android.content.Intent;
import android.os.Bundle;

import android.view.MenuItem;
import com.google.android.material.appbar.AppBarLayout;
import com.google.android.material.bottomnavigation.BottomNavigationView;


public class MainActivity extends AppCompatActivity {
    REAPIResponse response;
    FeedClass feed;

    NestedScrollView scrollView;
    AppBarLayout appBarLayout;

    /*FragmentHome frag1 = new FragmentHome();
    FragmentVoti frag2 = new FragmentVoti();
    FragmentComm frag3 = new FragmentComm();*/

    private ViewPager viewPager;
    BottomNavigationView navigation;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Intent intent = getIntent();
        response = (REAPIResponse) intent.getSerializableExtra("reapi");
        feed = (FeedClass) intent.getSerializableExtra("feed");

        scrollView = findViewById(R.id.nestedScrollView);
        appBarLayout = findViewById(R.id.appBar);
        navigation = findViewById(R.id.bottom_navigation);
        viewPager = findViewById(R.id.viewpager);



        scrollView.setOnScrollChangeListener(new NestedScrollView.OnScrollChangeListener() {
            @Override
            public void onScrollChange(NestedScrollView nestedScrollView,int scrollX, int scrollY, int oldScrollX, int oldScrollY) {
                if (scrollY > 0){
                    appBarLayout.setElevation(10);
                } else {
                    appBarLayout.setElevation(0);
                }
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
                        viewPager.setCurrentItem(0);
                        //scrollView.scrollTo(0,0);
                        return true;
                    case R.id.action_voti:
                        viewPager.setCurrentItem(1);
                        //scrollView.scrollTo(0,0);
                        return true;
                    case R.id.action_comunicazioni:
                        viewPager.setCurrentItem(2);
                        return true;
                }
                return false;
            }
        });
    }



}
