package io.bistmithy.netto;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.net.TrafficStats;
import android.os.Bundle;
import android.os.Handler;
import android.widget.TextView;

public class Netto extends CordovaPlugin {
    private Handler mHandler = new Handler();

    @Override
    public boolean execute(String action, JSONArray initialBytes, CallbackContext callbackContext) throws JSONException {
        if (action.equals("traffic")) {
            this.traffic(initialBytes, callbackContext);
            return true;
        }
        return false;
    }

    private void traffic(JSONArray initialBytes, CallbackContext callbackContext) {
        try{
            long initialRxBytes    = Long.parseLong(initialBytes.getString(0));
            long initialTxBytes    = Long.parseLong(initialBytes.getString(1));
            long initialTotalBytes = Long.parseLong(initialBytes.getString(2));

            long rawRxBytes    = TrafficStats.getTotalRxBytes(); // Raw received bytes
            long rawTxBytes    = TrafficStats.getTotalTxBytes(); // Raw transmitted bytes
            long rawTotalBytes = rawRxBytes + rawTxBytes;        // Raw total bytes

            long rxBytes    = rawRxBytes    - initialRxBytes;    // Raw received bytes minus initial received bytes
            long txBytes    = rawTxBytes    - initialTxBytes;    // Raw transmitted bytes minus initial transmitted bytes
            long totalBytes = rawTotalBytes - initialTotalBytes; // Raw total bytes minus initial total bytes

            JSONObject trafficStats = new JSONObject();
            trafficStats.put("receivedBytes", Long.toString(rxBytes));
            trafficStats.put("transmittedBytes", Long.toString(txBytes));
            trafficStats.put("totalBytes", Long.toString(totalBytes));
            callbackContext.success(trafficStats);
        } catch (JSONException e){
            // callbackContext.error(e);
        }
    }
}