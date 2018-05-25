lexer grammar A1_Lexer;

// Fragment definition

fragment SingleQuote: '\'';

fragment DoubleQuote: '"';

fragment Digit: [0-9];

fragment Letter: [a-zA-Z];

fragment Alpha: [a-zA-Z_];

fragment AlphaNum: Alpha | Digit;

fragment Delim: ' ' | '\t' | '\n';

fragment Escape: '\\' . ;

fragment HexDigit: Digit | [a-f] | [A-F];

// Lexer defintion

WhiteSpace: Delim+ -> skip;

Char: SingleQuote (Escape|~['\\]) SingleQuote; //'

Str: DoubleQuote (Escape|~["\\])* DoubleQuote;

Class: 'class';

Program: 'Program';

Void: 'void';

If: 'if';

Else: 'else';

For: 'for';

Ret: 'return';

Brk: 'break';

Cnt: 'continue';

Callout: 'callout';

Switch: 'switch';

Case: 'case';

Num: Digit+;

HexNum: '0x' Delim+ HexDigit+;

BoolLit: 'true' | 'false';

Type: 'int' | 'boolean';

Ident: Alpha AlphaNum*;

Relop: '<' | '>' | '<=' | '>=';

AssignOp: '=' | '+=' | '-=';

ArithOp: '+' | '-' | '*' | '/' | '%';

CondOp: '&&' | '||';

OParen: '(';

CParen: ')';

OBrace: '{';

CBrace: '}';

OBracket: '[';

CBracket: ']';

SemiColon: ';';

Colon: ':';

Comma: ',';

While: 'while';

EqOp: '==' | '!=';







