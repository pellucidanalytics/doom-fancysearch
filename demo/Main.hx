import Helpers.*;
import haxe.ds.Option;

class Main {
  static function main() {
    var fancySearch = new doom.fs.FancySearch({
      suggestions: [
        { name : "Bill", value : 99 },
        { name : "Bob", value : 100 }
      ],
      suggestionToString : function(item : SampleItem) {
        return item.name;
      },
      onChooseSelection: function(suggestionToString : SampleItem -> String, e : js.html.InputElement, value : Option<SampleItem>) {

        switch value {
          case Some(item): e.value = suggestionToString(item); trace(item);
          case None: trace("no value");
        }
      },
      placeholder : "this is my placeholder"
    });
    Doom.browser.mount(fancySearch, js.Browser.document.getElementById("fs-container"));
  }
}

typedef SampleItem = {
  name : String,
  value : Int
}
