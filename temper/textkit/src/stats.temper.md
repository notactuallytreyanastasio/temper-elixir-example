# Statistics

    @imu export class Stats(
      public words: Int,
      public sentences: Int,
      public characters: Int,
      /** At 238 words a minute, a common figure for adults reading prose. */
      public readingSeconds: Int,
    ) {}

A sentence ends at `.`, `!` or `?` followed by space or the end of the text.

    /** Counts for one draft. */
    export let stats(text: String): Stats {
      var words = 0;
      for (let t of tokens(text)) {
        if (!isSpace(t[String.begin])) { words += 1; }
      }
      var sentences = 0;
      var characters = 0;
      var i = String.begin;
      while (text.hasIndex(i)) {
        let c = text[i];
        characters += 1;
        let next = text.next(i);
        if ((c == 46 || c == 33 || c == 63) && (!text.hasIndex(next) || isSpace(text[next]))) {
          sentences += 1;
        }
        i = next;
      }
      new Stats(words, sentences, characters, words * 60 / 238)
    }
