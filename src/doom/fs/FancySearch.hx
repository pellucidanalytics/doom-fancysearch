package doom.fs;

import haxe.ds.Option;
import doom.html.Html.*;
import fancy.search.defaults.AutocompleteDefaults;

class FancySearch<T> extends doom.html.Component<FancySearchProps<T>> {
  var fancySearch: fancy.Search<T, String, StringOrValue<T>>;

  public static function with<T>(value: Null<T>, suggestions: Array<T>, suggestionToString: T -> String, onChooseSelection: SelectionChooseFunction<T>, placeholder: String) {
    return new doom.fs.FancySearch<T>({
      value : value,
      suggestions : suggestions,
      suggestionToString : suggestionToString,
      onChooseSelection : onChooseSelection,
      placeholder : placeholder
    });
  }

  override function render() {
    return doom.fs.renderer.Autocomplete.render({
      state: fancySearch.store.get(),
      cfg: {
        classes: fancy.search.defaults.ClassNameDefaults.defaults,
        keys: fancy.search.defaults.KeyboardDefaults.defaults,
        elements: {
          clearButton: None, // TODO
          failedCondition: None,
          loading: None,
          noResults: Some(() -> span(["class" => "fs-suggestion-message"], "No suggestions match your search")),
          failed: None
        },
        renderSuggestion: (sug: T, search) -> {
          var pattern = new EReg("(" + thx.ERegs.escape(search) + ")", "i");
          span(raw(pattern.map(props.suggestionToString(sug), e -> '<b>${e.matched(1)}</b>')));
        }
      },
      placeholder: props.placeholder,
      dispatch: (act) -> fancySearch.store.dispatch(act)
    });
  }

  function ensureFancySearch() {
    if (this.fancySearch == null) {
      fancySearch = new fancy.Search(AutocompleteDefaults.sync({
        sugEq: (a, b) -> props.suggestionToString(a) == props.suggestionToString(b),
        minLength: 1,
        alwaysHighlight: false,
        initValue: props.value,
        suggestions: props.suggestions,
        filter: (sug, search) -> thx.Strings.caseInsensitiveContains(props.suggestionToString(sug), search),
        limit: 25
      }));
    }
  }

  override function willMount() {
    ensureFancySearch();
  }

  override function didMount() {
    ensureFancySearch();
    fancySearch.store.stream().next(_ -> update(props)).run();
    fancySearch.values.next(val -> {
      var input: js.html.InputElement = cast element.querySelector("input");
      switch val {
        case Raw(_): props.onChooseSelection(input, None);
        case Value(v):
          input.value = props.suggestionToString(v);
          props.onChooseSelection(input, Some(v));
      }
    }).run();
  }

  override function willUnmount() {
    fancySearch = null;
    element.innerHTML = "";
  }
}

typedef SelectionChooseFunction<T> = js.html.InputElement -> Option<T> -> Void;

typedef FancySearchProps<T> = {
  ?value: Null<T>, // initial
  suggestions: Array<T>, // converted into sync filterer
  suggestionToString: T -> String,
  ?placeholder: String,
  ?onChooseSelection: SelectionChooseFunction<T>,
};
