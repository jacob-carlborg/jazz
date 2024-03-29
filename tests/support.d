module tests.support;

pure @safe:

string dcode(string code) => code.stripDelimited ~ "\0\0\0\0";

private:

/**
 * Strips indentation and extra newlines in delimited strings.
 *
 * This is indented to be used on delimited string literals. It will strip the
 * indentation and remove the first and the last newlines.
 *
 * Params:
 *  str = the delimited string to strip
 *
 * Return: the stripped string
 */
string stripDelimited(string str)
{
    import std.string : chomp, outdent;

    return str
        .stripLeadingLineTerminator
        .outdent
        .chomp;
}

/**
 * Strips one leading line terminator of the given string.
 *
 * The following are what the Unicode standard considers as line terminators:
 *
 * | Name                | D Escape Sequence | Unicode Code Point |
 * |---------------------|-------------------|--------------------|
 * | Line feed           | `\n`              | `U+000A`           |
 * | Line tabulation     | `\v`              | `U+000B`           |
 * | Form feed           | `\f`              | `U+000C`           |
 * | Carriage return     | `\r`              | `U+000D`           |
 * | Next line           |                   | `U+0085`           |
 * | Line separator      |                   | `U+2028`           |
 * | Paragraph separator |                   | `U+2029`           |
 *
 * This function will also strip `\r\n`.
 */
string stripLeadingLineTerminator(string str) nothrow @nogc
{
    enum nextLine = "\xC2\x85";
    enum lineSeparator = "\xE2\x80\xA8";
    enum paragraphSeparator = "\xE2\x80\xA9";

    static assert(lineSeparator.length == paragraphSeparator.length);

    if (str.length == 0)
        return str;

    switch (str[0])
    {
        case '\r':
        {
            if (str.length >= 2 && str[1] == '\n')
                return str[2 .. $];
            goto case;
        }
        case '\v', '\f', '\n': return str[1 .. $];

        case nextLine[0]:
        {
            if (str.length >= 2 && str[0 .. 2] == nextLine)
                return str[2 .. $];

            return str;
        }

        case lineSeparator[0]:
        {
            if (str.length >= lineSeparator.length)
            {
                const prefix = str[0 .. lineSeparator.length];

                if (prefix == lineSeparator || prefix == paragraphSeparator)
                    return str[lineSeparator.length .. $];
            }

            return str;
        }

        default: return str;
    }
}

unittest
{
    assert("".stripLeadingLineTerminator == "");
    assert("foo".stripLeadingLineTerminator == "foo");
    assert("\xC2foo".stripLeadingLineTerminator == "\xC2foo");
    assert("\xE2foo".stripLeadingLineTerminator == "\xE2foo");
    assert("\nfoo".stripLeadingLineTerminator == "foo");
    assert("\vfoo".stripLeadingLineTerminator == "foo");
    assert("\ffoo".stripLeadingLineTerminator == "foo");
    assert("\rfoo".stripLeadingLineTerminator == "foo");
    assert("\u0085foo".stripLeadingLineTerminator == "foo");
    assert("\u2028foo".stripLeadingLineTerminator == "foo");
    assert("\u2029foo".stripLeadingLineTerminator == "foo");
    assert("\n\rfoo".stripLeadingLineTerminator == "\rfoo");
    assert("\r\nfoo".stripLeadingLineTerminator == "foo");
}
