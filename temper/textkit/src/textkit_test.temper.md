# Tests

Each check runs inside a helper that takes the `test`: a test of constants
alone would be evaluated by the compiler, not by the generated code.

    let diffIs(test: Test, before: String, after: String, want: String): Void {
      let got = diff(before, after).join("|") { (p): String => "${p.kind}:${p.text}" };
      assert(got == want) { "got ${got}" }
    }

    test("an unchanged text is one piece") { test =>
      diffIs(test, "the cat sat", "the cat sat", "same:the cat sat");
    }

    test("a changed word is removed, then added") { test =>
      diffIs(test, "the cat sat", "the dog sat", "same:the |removed:cat|added:dog|same: sat");
    }

    test("words added at the end") { test =>
      diffIs(test, "hello", "hello there", "same:hello|added: there");
    }

    let statsAre(test: Test, text: String, words: Int, sentences: Int): Void {
      let s = stats(text);
      assert(s.words == words && s.sentences == sentences) { "got ${s.words} words, ${s.sentences} sentences" }
    }

    test("words and sentences are counted") { test =>
      statsAre(test, "One two. Three? Four!", 4, 3);
    }

    test("a period inside a number ends no sentence") { test =>
      statsAre(test, "Pi is 3.14 roughly", 4, 0);
    }
