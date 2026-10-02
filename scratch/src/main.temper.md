# Try anything here

Change this file and run `make run`. `make run BACKEND=js` runs the same
program as JavaScript.

    class Counter {
      public var count: Int = 0;
      public bump(): Void { count += 1; }
    }

    let fib(n: Int): Int {
      var a = 0;
      var b = 1;
      for (var i = 0; i < n; ++i) {
        let c = a + b;
        a = b;
        b = c;
      }
      a
    }

    let c = new Counter();
    c.bump();
    c.bump();
    console.log("count=${c.count} fib(30)=${fib(30)} half=${1.0 / 2.0}");
