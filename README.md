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
const pad           = paddy(4, '👻');
const simplePhrase  = `${pad}I love simple tabs!`;
const complexPhrase = `${pad}I love ghost tabs!`;

console.log(simplePhrase);  // "    I love simple tabs!"
console.log(complexPhrase); // "👻👻👻👻I love ghost tabs!"
```

// Code... TEMP!

function paddy(padLength, padEntity){
  // Create a sting padding of desired length and set the desired entity (or default to ' ').
  return new Array((padLength || 0) + 1).join(padEntity || ' ');
}
