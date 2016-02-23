import Helpers.*;

class Main {
  static function main() {
    var fancySearch = new doom.fs.FancySearch({
      suggestions: [
        { name : "Bill", value : 99 },
        { name : "Bob", value : 100 }
      ],
      suggestionToString : function(item : { name : String, value : Int }) {
        return item.name;
      }
    });
    Doom.browser.mount(fancySearch, js.Browser.document.getElementById("fs-container"));
  }
}
