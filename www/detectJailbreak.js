const exec = require("cordova/exec");
const SERVICE = "DetectJailbreak";

const DetectJailbreak = {
  detectJailbreak: function(cb, err) {
    exec(cb, err, SERVICE, "detectJailbreak", []);
  },
};

if (typeof module != "undefined" && module.exports) {
  module.exports = DetectJailbreak;
}
