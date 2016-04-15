import Helpers.*;
import haxe.ds.Option;

class Main {
  static function main() {
    var suggestionToString = function(item : SampleItem) return item.name;
    var fancySearch = new doom.fs.FancySearch({
      suggestions: [
        { name : "Bill", value : 99 },
        { name : "Bob", value : 100 }
      ],
      suggestionToString : suggestionToString,
      onChooseSelection: function(e : js.html.InputElement, value : Option<SampleItem>) {

        switch value {
          case Some(item): e.value = suggestionToString(item); trace(item);
          case None: trace("no value");
        }
      }
    });
    Doom.browser.mount(fancySearch, js.Browser.document.getElementById("fs-container"));
  }
}

typedef SampleItem = {
  name : String,
  value : Int
}
