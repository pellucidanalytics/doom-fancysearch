package doom.fs;

import thx.Dynamics;
import js.html.Element;
import Doom.*;
import doom.html.Html.*;
import doom.core.VNodes;
import haxe.Constraints.Function;
using thx.Objects;

class FancySearch<T> extends doom.html.Component<FancySearchProps<T>> {

  public static function with<T>(items : Array<T>, suggestionToString : T -> String) {
    return (
      new doom.fs.FancySearch<T>({
        suggestions : items,
        suggestionToString : suggestionToString
      }).asNode()
    );
  }

  //static var optionNames = [ "mode" ];
  //static var eventNames = [ "changes" ];

  var fancySearch : fancy.Search<T>;
  //var events : Map<String, haxe.Constraints.Function>;

  override function render()
    return div([ "class" => "doom-fancysearch" ], [
      input([ "type" => "text", "class" => "fancysearch-input" ])
    ]);

  override function didMount() {
    fancySearch = fancy.Search.createFromContainer(element, {
      suggestionOptions : {
        suggestions : props.suggestions,
        suggestionToString : props.suggestionToString
      }
    });
    //setupEvents();
    if(null != props.mount)
      props.mount(fancySearch);
  }

  // function setupEvents() {
  //   events = new Map();
  //   for(name in eventNames) {
  //     var f = Reflect.field(api, name);
  //     if(null == f) continue;
  //     events.set(name, f);
  //   }
  // }

  function clearEvents() {
    //if(null == events)
      //return;
    //for(name in events.keys()) {
      //editor.off(name, events.get(name));
    //}
  }
/*
  override function didRefresh() {
    if(null == editor) return;
    for(field in optionNames) {
      var current = editor.getOption(field),
          value = Reflect.field(state, field);
      if(null == value)
        value = Reflect.field(codemirror.CodeMirror.defaults, field);
      if(current != value) {
        editor.setOption(field, value);
      }
    }
    editor.setValue(state.value);
    if(null != api.refresh)
      api.refresh(editor);
  }
*/

  override function didUnmount() {
    clearEvents();
    element.innerHTML = "";
  }

  function migrate(old : FancySearch<T>) {
    if(null == old.fancySearch) return;
    old.clearEvents();
    fancySearch = old.fancySearch;
    //setupEvents();
  }
}

typedef FancySearchProps<T> = {
  suggestions : Array<T>,
  suggestionToString : T -> String,
  ?mount : fancy.Search<T> -> Void
};
