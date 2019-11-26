package edu.mysobrero;

import android.content.Context;
import android.graphics.Canvas;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.ListView;

public class WrappedListView extends ListView {
    private int prevCount = 0;
    private android.view.ViewGroup.LayoutParams params;

    public WrappedListView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public WrappedListView(Context context) {
        super(context);
    }

    public WrappedListView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    public void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2,
                MeasureSpec.AT_MOST);
        super.onMeasure(widthMeasureSpec, expandSpec);
        Log.i("LW", "ONLAYOUT2");
    }

    @Override
    protected void onDraw(Canvas canvas)
    {
        if (getCount() != prevCount)
        {
            int height = getChildAt(0).getHeight() + 1 ;
            prevCount = getCount();
            params = getLayoutParams();
            params.height = getCount() * height;
            setLayoutParams(params);
        }

        super.onDraw(canvas);
    }



}