import Helpers.*;
import haxe.ds.Option;
import doom.html.Html.*;

class Main {
  static function main() {


    // TODO: add stuff to get macro to create .with() method
    // var fs = doom.fs.FancySearch.with({}, {
    //   suggestions : suggestions
    // });

    Doom.browser.mount(new MyComponent(thx.Unit.unit), js.Browser.document.getElementById("fs-container"));
  }


}

class MyComponent extends doom.html.Component<thx.Unit> {
  var defaults = options();
  static function options() {
    var suggestionToString = function(item : SampleItem) return item.name;
    return {
      suggestions : [
        { name : "Bill", value : 99 },
        { name : "Bob", value : 100 }
      ],
      suggestionToString : suggestionToString,
      onChooseSelection: function(e : js.html.InputElement, value : Option<SampleItem>) {
        switch value {
          case Some(item): e.value = suggestionToString(item); trace(item);
          case None: trace("no value");
        }
      },
      placeholder : "placeholder text"
    };
  }
  function createFancySearch() {
    return new doom.fs.FancySearch({
      suggestions: defaults.suggestions,
      suggestionToString : defaults.suggestionToString,
      onChooseSelection: defaults.onChooseSelection,
      placeholder : defaults.placeholder
    });
  }

  public override function render() {
    return div([
      div(createFancySearch()),
      // div(createFancySearch()),
      button([
        "click" => () -> update(thx.Unit.unit)
      ], "Button")
    ]);
  }
  override function willMount() {
    trace("will mount");
  }

  override function didUpdate() {
    trace("did update");
  }

  override function shouldRender() {
    // trace("should render");
    return super.shouldRender();
  }

  override function willUnmount() {
    trace("will unmount");
  }
}

typedef SampleItem = {
  name : String,
  value : Int
}
