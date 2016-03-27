package doom.fs;

import thx.Dynamics;
import js.html.Element;
import doom.html.Html.*;
import haxe.Constraints.Function;
import haxe.ds.Option;
using thx.Objects;

class FancySearch<T> extends doom.html.Component<FancySearchProps<T>> {
  public static function with<T>(suggestions : Array<T>, suggestionToString : T -> String, onChooseSelection : SelectionChooseFunction<T>) {
    return new doom.fs.FancySearch<T>({
      suggestions : suggestions,
      suggestionToString : suggestionToString,
      onChooseSelection : onChooseSelection
    });
  }

  var fancySearch : fancy.Search<T>;

  override function render()
    return div([ "class" => "doom-fancysearch" ], [
      input([ "type" => "text", "class" => "fancysearch-input" ])
    ]);

  override function didMount() {
    fancySearch = fancy.Search.createFromContainer(element, {
      suggestionOptions : {
        suggestions : props.suggestions,
        suggestionToString : props.suggestionToString,
        onChooseSelection : props.onChooseSelection
      }
    });
    if(null != props.mount)
      props.mount(fancySearch);
  }

  override function willUnmount() {
    if(null != props.unmount)
      props.unmount(fancySearch);
    fancySearch = null;
    element.innerHTML = "";
  }
}

typedef SelectionChooseFunction<T> = (T -> String) -> js.html.InputElement -> Option<T> -> Void;

typedef FancySearchProps<T> = {
  suggestions : Array<T>,
  suggestionToString : T -> String,
  ?mount : fancy.Search<T> -> Void,
  ?unmount : fancy.Search<T> -> Void,
  ?onChooseSelection : SelectionChooseFunction<T>
};
