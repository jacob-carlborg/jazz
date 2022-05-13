module jazz.lexer.lexer;

import std.stdio;

import jazz.lexer.location;
import jazz.lexer.token;

struct Lexer
{
    private
    {
        // The source code to lex.
        ConstString sourceCode;

        // The current index into `sourceCode`.
        uint index;

        MutableToken token;
    }

pure @nogc:

    this(ConstString sourceCode) @trusted
    in
    {
        const end = sourceCode.ptr[sourceCode.length - 1];
        assert(end == Entity.null_ || end == Entity.substitute);
    }
    do
    {
        this.sourceCode = sourceCode;
        token.kind = tokenKind!"endOfFile";
    }

@safe

    void popFront()
    {
        token.location.start = index;

        if (lexShebangLine())
            return;
    }

    Token front()
    {
        Token result = {
            kind: token.kind,
            location: {
                start: token.location.start,
                end: token.location.end
            }
        };

        return result;
    }

private:

    bool lexShebangLine() @trusted pure
    {
        if (sourceCode.ptr[0 .. 2] != "#!")
            return false;

        index += 2;

        while (true)
        {
            switch (sourceCode.ptr[index++])
            {
                case Entity.null_:
                case Entity.substitute:
                    index--;
                    goto case;
                case Entity.lineFeed:
                    index--;
                    break;
                default:
                    continue;
            }

            recordToken(tokenKind!"#!");
            return true;
        }

        assert(false);
    }

    void recordToken(Token.Kind)
    {
        token.location.end = index;
        token.kind = tokenKind!"#!";
    }
}

private:

alias ConstString = const(char)[];

enum Entity : dchar
{
    null_ = '\u0000',

    substitute = '\u001A',

    carriageReturn = '\u000D',
    lineFeed = '\u000A',
    lineSeparator = '\u2028',
    paragraphSeparator = '\u2029'
}

// Mutable version of jazz.lexer.location.Location
struct MutableLocation
{
    uint start;
    uint end;
}

static assert(MutableLocation.sizeof == Location.sizeof);

// Mutable version of jazz.lexer.token.Token
struct MutableToken
{
    Token.Kind kind;
    MutableLocation location;
}

static assert(MutableToken.sizeof == Token.sizeof);
