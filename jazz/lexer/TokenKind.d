/**
 * Copyright: Copyright (c) 2013 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Jan 27, 2013
 * License: $(LINK2 http:///www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module jazz.lexer.TokenKind;

/// The kind of token
enum TokenKind : ushort
{
	invalid = 0,						/// Invalid

	// Identifiers
	identifier,							/// identifier, foo
	keyword,							/// keyword, int

	// Literals
	characterLiteral,					/// character literal, 'a'
	stringLiteral,						/// string literal, "foo"
    floatLiteral,						/// floating point literal, 1.0f
    integerLiteral,						/// integer literal, 1

	// Operators
	slash,								/// /
	slashEqual,							/// /=
	dot,								/// .
	doubleDot,							/// ..
	tripleDot,							/// ...
	ampersand,							/// &
	ampersandEqual,						/// &=
	doubleAmpersand,					/// &&
	pipe,								/// |
	pipeEqual,							/// |=
	doublePipe,							/// ||
	minus,								/// -
	minusEqual,							/// -=
	plus,								/// +
	plusEqual,							/// +=
	doublePlus,							/// ++
	less,								/// <
	lessEqual,							/// <=
	doubleLess,							/// <<
	greater,							/// >
	greaterEqual,						/// >=
	doubleGreaterEqual,					/// >>=
	tripleGreaterEqual,					/// >>>=
	doubleGreater,						/// >>
	tripleGreater,						/// >>>
	bang,								/// !
	bangEqual,							/// !=
	equal,								/// =
	doubleEqual,						/// ==
	percent,							/// %
	percentEuqal,						/// %=
	caret,								/// ^
	caretEqual,							/// ^=
	doubleCaret,						/// ^^
	doubleCaretEqual,					/// ^^=
	tilde,								/// ~
	tildeEqual,							/// ~=

	// Floating point operators
	lessGreater,						/// <>
	lessGreaterEqual,					/// <>=
	bangLessGreater,					/// !<>
	bangLessGreaterEqual,				/// !<>=
	bangLess,							/// !<
	bangLessEqual,						/// !<=
	bangGreater,						/// !>
	bangGreaterEqual,					/// !>=

	// Brackets
	openParenthesis,					/// (
	closeParenthesis,					/// )
	openBracket,						/// [
	closeBracket,						/// ]
	openBrace,							/// {
	closeBrace,							/// }

	//
	question,							/// ?
	comma,								/// ,
	semicolon,							/// ;
	colon,								/// :
	dollar,								/// $
	at,									/// @
	equalGreater,						/// =>
	hash,								/// #

	// Special tokens
	date,								/// __DATE__
	eof,								/// __EOF__
	time,								/// __TIME__
	timestamp,							/// __TIMESTAMP__
	vendor,								/// __VENDOR__
	version_,							/// __VERSION__
	line								/// #line
}