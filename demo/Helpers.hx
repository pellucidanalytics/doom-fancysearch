import doom.fs.FancySearch;
//import doom.fs.FancySearchApi;
import Doom.*;

class Helpers {
  public static function createFancySearch(suggestions : Array<{ name : String, value : Int }>) {
    return new FancySearch({
      suggestions : suggestions,
      suggestionToString : function(item : { name : String, value : Int }) {
        return item.name;
      }
    });
  }
}
