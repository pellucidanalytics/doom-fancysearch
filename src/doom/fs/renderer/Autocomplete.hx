package doom.fs.renderer;

import haxe.ds.Option;
import js.html.InputElement;
import doom.html.Html.*;
import doom.core.VNode;
using thx.Arrays;
using thx.Options;

import fancy.Search;
import fancy.search.Action;
import fancy.search.State;
import fancy.search.config.RendererConfig;

typedef Props<Sug, Value> = {
  state: State<Sug, String, Value>,
  cfg: RendererConfig<Sug, String, VNode>,
  dispatch: Action<Sug, String, Value> -> Void
};

class Autocomplete {
  public static function render<Sug, Value>(props: Props<Sug, Value>) {
    return div([
      renderInput(props.cfg.keys, props.cfg.classes, props.dispatch, props.state.filter),
      renderMenu(props.cfg, props.dispatch, props.state)
    ]);
  }

  static function renderInput(keys: KeyboardConfig, classes: ClassNameConfig, dispatch, value: String) {
    return input([
      "class" => "fancify " + classes.input,
      "type" => "text",
      "placeholder" => "Search for Something",
      "value" => value,
      "focus" => function (el, _) {
        var inpt: InputElement = cast el;
        dispatch(SetFilter(inpt.value));
        dispatch(OpenMenu);
      },
      "blur" => function () dispatch(CloseMenu),
      "input" => function (el, _) {
        var inpt: InputElement = cast el;
        dispatch(SetFilter(inpt.value));
      },
      "keydown" => function (_, e: js.html.KeyboardEvent) {

        e.stopPropagation();
        var code = e.which != null ? e.which : e.keyCode;

        if (keys.highlightUp.contains(code)) {
          e.preventDefault();
          dispatch(ChangeHighlight(Move(Up)));
        } else if (keys.highlightDown.contains(code)) {
          e.preventDefault();
          dispatch(ChangeHighlight(Move(Down)));
        } else if (keys.choose.contains(code)) {
          e.preventDefault();
          dispatch(ChooseCurrent);
        }
      }
    ]);
  }

  // returns space-separated classes, like `"class-one class-two"`
  static function getContainerClassesForState<Sug>(classes: ClassNameConfig, state: MenuState<Sug>): String {
    var classArr: Array<String> = [classes.container].append(switch state {
      case Closed(Inactive): classes.containerClosed;
      case Closed(FailedCondition(_)): classes.containerNotAllowed;
      case Open(Loading, _): classes.containerLoading;
      case Open(NoResults, _): classes.containerNoResults;
      case Open(Failed, _): classes.containerFailed;
      case Open(Results(_), _): classes.containerOpen;
    });

    return classArr.join(" ");
  }

  static function renderMenu<Sug, Val>(cfg: RendererConfig<Sug, String, VNode>, dispatch, state: State<Sug, String, Val>) {
    var cls = getContainerClassesForState(cfg.classes, state.menu);

    return switch state.menu {
      case Closed(_): div(["class" => cls ]);
      case Open(Results(suggs), highlighted):
        div([ "class" => cls ], [
          ul([
            "class" => cfg.classes.list
          ], suggs.toArray().map(renderMenuItem.bind(state.config.sugEq, cfg, state.filter, dispatch, highlighted)))
        ]);
      case Open(_): div(["class" => cls ]);
    }
  }

  static function renderMenuItem<Sug>(eq, cfg: RendererConfig<Sug, String, VNode>, filter: String, dispatch, highlighted: Option<Sug>, item: Sug): VNode {
    var highlightClass = highlighted.cata("", function (h) {
      return eq(item, h) ? cfg.classes.itemHighlighted : "";
    });

    return li([
      "class" => cfg.classes.item + " " + highlightClass,
      "mouseover" => () -> dispatch(ChangeHighlight(Specific(item))),
      "mousedown" => () -> dispatch(ChooseCurrent)
    ], cfg.renderSuggestion(item, filter));
  }
}