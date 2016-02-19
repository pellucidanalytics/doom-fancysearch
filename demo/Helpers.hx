import doom.fs.FancySearch;
import doom.fs.FancySearchApi;
import Doom.*;

class Helpers {
  public static function createFancySearch(suggestions : Array<String>) {
    return new FancySearch({}, {
      suggestions : suggestions
    });
  }
}
