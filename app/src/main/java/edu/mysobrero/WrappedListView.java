package edu.mysobrero;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListAdapter;
import android.widget.ListView;

public class WrappedListView extends ListView {
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
    }

    @Override
    public void setAdapter(ListAdapter adapter) {
        super.setAdapter(adapter);
        setHeightWrapContent();
    }

    public void setHeightWrapContent() {
        ListAdapter listAdapter = getAdapter();
        if (listAdapter == null) {
            return;
        }
        int totalHeight = 0;
        for (int i = 0; i < listAdapter.getCount(); i++) {
            View listItem = listAdapter.getView(i, null, this);
            listItem.measure(0, 0);
            totalHeight += listItem.getMeasuredHeight();
        }

        ViewGroup.LayoutParams params = this.getLayoutParams();

        params.height = totalHeight
                + (this.getDividerHeight() * (listAdapter.getCount() - 1));
        this.setLayoutParams(params);
    }



}