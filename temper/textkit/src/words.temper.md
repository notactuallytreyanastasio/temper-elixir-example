# Words

A draft is cut into tokens: each word, and each run of space between words.
Keeping the spaces as tokens means joining every token of a diff gives the
text back exactly.

    let isSpace(c: Int): Boolean { c == 32 || (c >= 9 && c <= 13) }

    /** The text cut into words and the runs of space between them, in order. */
    export let tokens(text: String): List<String> {
      let out = new ListBuilder<String>();
      var start = String.begin;
      var i = String.begin;
      while (text.hasIndex(i)) {
        let space = isSpace(text[i]);
        var j = text.next(i);
        while (text.hasIndex(j) && isSpace(text[j]) == space) { j = text.next(j); }
        out.add(text.slice(i, j));
        i = j;
      }
      out.toList()
    }

## The diff

A piece of a diff is text that both versions share, or that only the old
one has, or only the new one.

    /** `kind` is "same", "removed" or "added". */
    @imu export class Piece(public kind: String, public text: String) {}

The diff is the longest common subsequence of the two token lists. `table`
holds, for each pair of suffixes, the length of theirs; walking it from the
start picks a shared token whenever that keeps the longest one.

    /** What changed between `before` and `after`, as pieces that rebuild either text. */
    export let diff(before: String, after: String): List<Piece> {
      let a = tokens(before);
      let b = tokens(after);
      let width = b.length + 1;
      let table = new ListBuilder<Int>();
      for (var k = 0; k < (a.length + 1) * width; ++k) { table.add(0); }
      for (var i = a.length - 1; i >= 0; --i) {
        for (var j = b.length - 1; j >= 0; --j) {
          if (a[i] == b[j]) {
            table.set(i * width + j, table[(i + 1) * width + j + 1] + 1);
          } else {
            let down = table[(i + 1) * width + j];
            let right = table[i * width + j + 1];
            table.set(i * width + j, if (down >= right) { down } else { right });
          }
        }
      }
      let out = new ListBuilder<Piece>();
      var i = 0;
      var j = 0;
      while (i < a.length || j < b.length) {
        if (i < a.length && j < b.length && a[i] == b[j]) {
          out.add(new Piece("same", a[i]));
          i += 1;
          j += 1;
        } else if (i < a.length && (j >= b.length || table[(i + 1) * width + j] >= table[i * width + j + 1])) {
          // on a tie, what went comes before what came, as a reader expects
          out.add(new Piece("removed", a[i]));
          i += 1;
        } else {
          out.add(new Piece("added", b[j]));
          j += 1;
        }
      }
      merged(out.toList())
    }

Neighbouring pieces of one kind read better as one.

    let merged(pieces: List<Piece>): List<Piece> {
      let out = new ListBuilder<Piece>();
      for (let p of pieces) {
        if (out.length > 0 && out[out.length - 1].kind == p.kind) {
          let last = out.removeLast();
          out.add(new Piece(p.kind, "${last.text}${p.text}"));
        } else {
          out.add(p);
        }
      }
      out.toList()
    }
