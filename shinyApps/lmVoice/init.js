var initVoice = function() {
if (annyang) {
  Shiny.onInputChange('DV', "salary");
  Shiny.onInputChange('IV', "years since phd");
  Shiny.onInputChange('contrast', "dummy");
  
  var commands = {
    'dependent variable *DV': function(DV) {
      Shiny.onInputChange("DV", DV);
    },
    'DV *DV': function(DV) {
      Shiny.onInputChange("DV", DV);
    },
    'independent variable *IV': function(IV) {
      Shiny.onInputChange("IV", IV);
    },
    'IV *IV': function(IV) {
      Shiny.onInputChange("IV", IV);
    },
    'contrast *contrast': function(contrast){
      Shiny.onInputChange("contrast", contrast);
    }
  };
  
  annyang.addCommands(commands);
  annyang.start();
  }
};

$(function() {
  setTimeout(initVoice, 10);
});