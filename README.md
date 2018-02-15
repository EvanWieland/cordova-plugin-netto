# 🌙🦉 Cordova Netto Plugin
Cordova plugin for keeping a watchful eye on network usage stats.

## Purpose

Netto returns an app's data usage (in bytes) since it was first launched. Data usage statistics will be reset when the app is killed.

## Installation

    cordova plugin add cordova-netto-plugin

## Supported Platforms

- Android
- iOS
    
## Properties

- Netto.traffic

### Example

```js
Netto.traffic(
    function(traffic){
        // traffic returns: 
        // {
        // receivedBytes: 103424, 
        // transmittedBytes: 6144, 
        // totalBytes: 109568
        // }
    },
    function(error){
        console.error(error); // Returns error
    }
);
```
