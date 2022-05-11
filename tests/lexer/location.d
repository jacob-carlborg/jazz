module tests.lexer.location;

import jazz.lexer.location;

@("Location()")
unittest
{
    auto location = Location(1, 2);

    assert(location.start == 1);
    assert(location.end == 2);
}
