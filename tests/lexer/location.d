module tests.lexer.location;

import fluent.asserts;

import jazz.lexer.location;

@("Location()")
unittest
{
    auto location = Location(1, 2);

    expect(location.start).to.equal(1);
    expect(location.end).to.equal(2);
}
