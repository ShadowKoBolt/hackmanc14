package net.llamadigital.dotb.beacons;

import android.util.Log;

import com.estimote.sdk.Beacon;

import java.util.HashMap;
import java.util.InputMismatchException;
import java.util.List;

public class Processor {

    private static final String LOG_TAG = Processor.class.getName();

    public Integer mClosestBeaconMajor;

    public Integer getBestBeaconMajorInList(List<Beacon> beacons) {
        for (Beacon beacon : beacons) {
            Log.d(LOG_TAG, "" + beacon.getMajor());
        }
        Beacon bestBeacon = beacons.get(0);
        if (bestBeacon != null && bestBeacon.getMajor() < 5) {
            return beacons.get(0).getMajor();
        }
        else {
            return null;
        }
    }
}
