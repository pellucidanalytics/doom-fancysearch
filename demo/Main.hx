import Helpers.*;

class Main {
  static function main() {
    var fancySearch = new doom.fs.FancySearch({}, {
      suggestions: [ "asdf", "xyz0" ]
    });
    Doom.mount(fancySearch, js.Browser.document.getElementById("fs-container"));
  }
}
