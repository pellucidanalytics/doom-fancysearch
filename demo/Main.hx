import Helpers.*;
import haxe.ds.Option;

class Main {
  static function main() {

    var defaults = options();

    var fancySearch = new doom.fs.FancySearch({
      suggestions: defaults.suggestions,
      suggestionToString : defaults.suggestionToString,
      onChooseSelection: defaults.onChooseSelection,
      placeholder : defaults.placeholder
    });

    // TODO: add stuff to get macro to create .with() method
    // var fs = doom.fs.FancySearch.with({}, {
    //   suggestions : suggestions
    // });

    Doom.browser.mount(fancySearch, js.Browser.document.getElementById("fs-container"));
  }

  static function options() {
    return {
      suggestions : [
        { name : "Bill", value : 99 },
        { name : "Bob", value : 100 }
      ],
      suggestionToString : function(item : SampleItem) {
        return item.name;
      },
      onChooseSelection : function(suggestionToString : SampleItem -> String, e : js.html.InputElement, value : Option<SampleItem>) {

        switch value {
          case Some(item): e.value = suggestionToString(item); trace(item);
          case None: trace("no value");
        }
      },
      placeholder : "placeholder text"
    };
  }

}

typedef SampleItem = {
  name : String,
  value : Int
}
