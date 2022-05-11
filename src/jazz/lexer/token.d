module jazz.lexer.token;

import std.algorithm;

import jazz.lexer.location;

/**
 * A token in the source code.
 *
 * This is produced by the lexer and it's the minimal unit the parser works with.
 */
immutable struct Token
{
    /// The kind of token.
    Kind kind;

    /// The location of the token in the source code.
    Location location;

    /// Represents the kind of token.
    immutable struct Kind
    {
        private ubyte value;

        private this(ubyte value) pure
        {
            this.value = value;
        }

        private static enum operators = [
            "+",
            "-"
        ];

        private static enum tokens = operators;

        static assert(operators.length < value.max);
    }
}

/**
 * Creates a Token.Kind based on the given token symbol.
 *
 * Params:
 *  tokenText = the textual representation of the token
 */
template tokenKind(string tokenText)
{
    enum value = Token.Kind.tokens.countUntil(tokenText) + 1;
    enum tokenKind = Token.Kind(value);
}

///
unittest
{
    auto kind = tokenKind!"+";
}
