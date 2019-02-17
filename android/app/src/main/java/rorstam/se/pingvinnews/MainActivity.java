package rorstam.se.pingvinnews;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.Color;

class NotificationUtils extends ContextWrapper {

    private NotificationManager mManager;
    public static final String NEWS_CHANNEL_ID = "rorstam.se.pingvinnews.NEWS";
    public static final String NEWS_CHANNEL_NAME = "Nyheter";

    public NotificationUtils(Context base) {
        super(base);
        createChannels();
    }

    public void createChannels() {

        // create android channel
        NotificationChannel newsChannel = new NotificationChannel(NEWS_CHANNEL_ID,
                NEWS_CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT);
        // Sets whether notifications posted to this channel should display notification lights
        newsChannel.enableLights(true);
        // Sets whether notification posted to this channel should vibrate.
        newsChannel.enableVibration(true);
        // Sets the notification light color for notifications posted to this channel
        newsChannel.setLightColor(Color.GREEN);
        // Sets whether notifications posted to this channel appear on the lockscreen or not
        newsChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);

        getManager().createNotificationChannel(newsChannel);
    }

    private NotificationManager getManager() {
        if (mManager == null) {
            mManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        }
        return mManager;
    }
}

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new NotificationUtils(this);
    }
}
