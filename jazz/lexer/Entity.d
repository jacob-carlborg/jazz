/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Jan 29, 2013
 * License: $(LINK2 http:///www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.Entity;

enum Entity : dchar
{
	null_ = '\u0000',

	substitute = '\u001A',

	carriageReturn = '\u000D',
	lineFeed = '\u000A',
	lineSeparator = '\u2028',
	paragraphSeparator = '\u2029'
}