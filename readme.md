Two methods which can be added on Object:

Both use `debug_inspector` to do some stuff with Ruby that wouldn't otherwise be possible.

`pass_to` is kind of like a reverse tap. It still works as a "tap" (it returns the caller) but takes arguments differently:

    foo = []
    1.pass_to *%i{ foo.push foo.push }
    puts foo # => [1,1]

The caller is being passed as an argument (serialized using `Marshal.dump`), and the symbols in the list are methods which it is passed to. They are evaluated in the caller context, which is why the local variable `foo` can be referenced.

The above example, if modified like so, wouldn't work:

    foo = []
    1.pass_to :foo.push :foo.push
    puts foo

The reason is that `:foo.push` is a `SyntaxError`. It needs to be written as `:"foo.push"`, which the `%i{ array.of symbols }` shorthand would do automatically.

The second method is `chain_to`, which is perhaps the 'functional programming' alternative to `pass_to` (and `tap`, which it's based on). It works similarly:

    foo = []
    [1].chain_to *%i{[0].concat [2].concat}
    puts foo # => [0,1,2]

Only the first symbol (`:"[].concat"`) gets the original argument, `[1]`, passed when evaluated. The next symbol `:"[2].concat"` gets the first evaluation's result (`[0, 1]`) passed.