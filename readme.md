### Install

`gem install inverse_methods`
`require 'inverse_methods'`

## Accessing methods

There is a single module `InverseMethods` which can be included where it's needed or patched on `Object` for global access.

To load it globally, use `Object.include InverseMethods`. Or use a more specific scope such as `MyClass.include InverseMethods` or `MyClass.extend InverseMethods`.

It can be used as a refinement: `using InverseMethods`.

### Explanation

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
    [1].chain_to *%i{[2].concat [3].concat}
    puts foo # => [3,2,1]

Only the first symbol (`:"[2].concat"`) gets the original argument, `[1]`, passed when evaluated. The next symbol `:"[3].concat"` gets the first evaluation's result (`[2, 1]`) passed.

### Usage

Can be included as a global patch on object:

    Object.include InverseMethods

Or as a refinement:

    using InverseMethods
