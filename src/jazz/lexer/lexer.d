module jazz.lexer.lexer;

import std.stdio;

import jazz.lexer.location;
import jazz.lexer.token;

pure nothrow @nogc:

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

pure nothrow @nogc @safe:

    this(ConstString sourceCode)
    in
    {
        const end = sourceCode.trusted[sourceCode.length -1];
        assert(end == Entity.null_ || end == Entity.substitute,
            `source code needs to end with \0`);
    }
    do
    {
        this.sourceCode = sourceCode;
        token.kind = tokenKind!"invalid";
    }

    void popFront()
    {
        token.location.start = index;

        if (lexShebangLine())
            return;

        while (true)
        {
            switch (current)
            {
                case '\0':
                case Entity.substitute:
                    recordToken(tokenKind!"endOfFile");
                    // Intentionally not advancing `index`, such that subsequent
                    // calls keep returning tokenKind!"endOfFile".
                    return;

                case ' ':
                    index++;
                    if (current == ' ')
                        continue;
                    recordToken(tokenKind!" ");
                    return;

                case '\t':
                    index++;
                    if (current != '\t')
                    {
                        recordToken(tokenKind!"\t");
                        return;
                    }
                    continue;

                default: assert(false);
            }
        }
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

    bool empty() const => token.kind == tokenKind!"endOfFile";

private:

    bool lexShebangLine()
    {
        if (peek(0, 2) != "#!")
            return false;

        index += 2;

        while (true)
        {
            switch (next)
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

    void recordToken(Token.Kind kind)
    {
        token.location.end = index;
        token.kind = kind;
    }

    auto current() => sourceCode.trusted[index];
    auto next() => sourceCode.trusted[index++];
    auto peek(size_t codeUnits = 1) => sourceCode.trusted[index + codeUnits];
    auto peek(size_t start, size_t end) => sourceCode.trusted[start .. end];
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

struct TrustedString
{
    private const(char)* value;

pure nothrow @nogc:

    private this(const(char)* value)
    {
        this.value = value;
    }

const:

    ConstString opSlice(size_t start, size_t end) @trusted
    {
        return value[start .. end];
    }

    char opIndex(size_t index) @trusted
    {
        return value[index];
    }
}

TrustedString trusted(ConstString value) @trusted
{
    return TrustedString(value.ptr);
}
