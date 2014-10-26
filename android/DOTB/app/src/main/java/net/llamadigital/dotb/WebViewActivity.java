package net.llamadigital.dotb;

import android.app.Activity;
import android.os.Bundle;
import android.os.RemoteException;
import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

import com.estimote.sdk.Beacon;
import com.estimote.sdk.BeaconManager;
import com.estimote.sdk.Region;

import net.llamadigital.dotb.beacons.Processor;

import java.util.List;


public class WebViewActivity extends Activity {

    private static final boolean RANGING = true;
    private static final String LOG_TAG = WebViewActivity.class.getName();

    private static final String ESTIMOTE_PROXIMITY_UUID = "B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    private static final Region ALL_ESTIMOTE_BEACONS = new Region("regionId", ESTIMOTE_PROXIMITY_UUID, null, null);

    private BeaconManager mBeaconManager = new BeaconManager(this);
    private Processor mProcessor = new Processor();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_web_view);

        // Webview setup
        final WebView webView = (WebView) findViewById(R.id.activity_web_view_web_view);
        webView.setWebViewClient(new WebViewClient() {
            public boolean shouldOverrideUrlLoading(WebView view, String url){
                view.loadUrl(url);
                return false;
            }
        });
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        JSInterface jsInterface = new JSInterface();
        webView.addJavascriptInterface(jsInterface, "android");
        webView.loadUrl(getString(R.string.base_url));

        // Ranging setup
        if (RANGING == true) {
            mBeaconManager.setRangingListener(new BeaconManager.RangingListener() {
                @Override
                public void onBeaconsDiscovered(Region region, List<Beacon> beacons) {
                    Beacon bestBeacon = mProcessor.getBestBeacon(beacons);
                    if (bestBeacon != null) {
                        webView.loadUrl("javascript:test('Beacon " + bestBeacon.getMajor() + " " + bestBeacon.getRssi() + "')");
                        // webView.loadUrl("javascript:game.updateLocation(" + bestBeacon.getMajor() + ")");
                        webView.loadUrl("javascript:test('Hello World')");
                        webView.loadUrl("javascript:doShowMessage('Hello World')");
                    }
                    else {
                        webView.loadUrl("javascript:test('No Beacon')");
                    }
                }
            });
        }
    }

    @Override
    protected void onStart() {
        if (RANGING == true) {
            mBeaconManager.connect(new BeaconManager.ServiceReadyCallback() {
                @Override
                public void onServiceReady() {
                    try {
                        mBeaconManager.startRanging(ALL_ESTIMOTE_BEACONS);
                    } catch (RemoteException e) {
                        Log.e(LOG_TAG, "Cannot start ranging", e);
                    }
                }
            });
        }
        super.onStart();
    }

    @Override
    protected void onStop() {
        if (RANGING == true) {
            try {
                mBeaconManager.stopRanging(ALL_ESTIMOTE_BEACONS);
            } catch (RemoteException e) {
                Log.e(LOG_TAG, "Cannot stop but it does not matter now", e);
            }
        }
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        if (RANGING == true) {
            mBeaconManager.disconnect();
        }
        super.onDestroy();
    }

    public class JSInterface {

        private WebView mAppView;
        public JSInterface  (WebView appView) {
            this.mAppView = appView;
        }

        public JSInterface() {
        }

        public void doShowMessage(String message){
            Toast toast = Toast.makeText(mAppView.getContext(), message, Toast.LENGTH_SHORT);
            toast.show();
        }
    }

}