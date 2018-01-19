/**
 * Netto module provides a traffic statistics function
 * @module traffic
 * @main traffic
 */

var exec      = require('cordova/exec');
var argscheck = require('cordova/argscheck');
var channel   = require('cordova/channel');

/**
 * Netto module provides a traffic statistics function (Android, iOS)
 * @class Netto
 * @platform Android iOS
 */
var Netto = function () {
    this.constructor._InitialReceivedBytes    = 0;
    this.constructor._InitialTransmittedBytes = 0;
    this.constructor._InitialTotalBytes       = 0;

    channel.onCordovaReady.subscribe(function () {
        this.traffic(
            function (traffic) {
                Netto._InitialReceivedBytes    = Number(traffic['receivedBytes']);
                Netto._InitialTransmittedBytes = Number(traffic['transmittedBytes']);
                Netto._InitialTotalBytes       = Number(traffic['totalBytes']);
                console.log('ran');
            }.bind(this),
            function (error) {
                console.log(error);
            }
        );
    }.bind(this));

};

/**
 * Get network usage stats.
 @example
 Netto.traffic(
 function(traffic){
              alert(traffic);
          },
 function(error){
              alert(error);
          }
 );
 * @method traffic
 * @param {Function} successCallback Successful callback function
 * @param {Object} successCallback.traffic Network traffic, measured in bytes
 * @param {Function} errorCallback Failed callback function
 * @platform Android iOS
 * @since 3.0.0
 */
Netto.prototype.traffic = function (successCallback, errorCallback) {
    exec(successCallback,
        errorCallback,
        'Netto',
        'traffic',
        [
            Netto._InitialReceivedBytes,
            Netto._InitialTransmittedBytes,
            Netto._InitialTotalBytes
        ]
    );
};

module.exports = new Netto();