grammar Cmpt379Compiler;
//---------------------------------------------------------------------------------------------------
// Session 1: ANTLR tree plotting API, You SHOULD NOT make any modification to this session
//---------------------------------------------------------------------------------------------------
@header {
    import java.io.*;
}

@parser::members {
    //AST node count
	int count = 0;
	String graph = "";

	int GetId() {
		return count++;
	}

	public class MySet {

		int[] ids;
		int size;

		MySet () {
			System.out.println("\n\nInitArray\n-------------");

			ids = new int [100];		
			size = 0;	
		}

		void ExtendArray(int val) {
			System.out.println("\n\nExtendArray\n-------------\nsize = " + size + "\nval = " + val);

			ids[size] = val;
			size ++;		
		}

		void AppendArray(MySet s) {
			for (int i = 0; i < s.size; i ++) {
				ExtendArray(s.ids[i]);
			}
		}
	}//MySet

	String ProcessString(String s) {
		String x = "\\" + s.substring(0, s.length() - 1) + "\\\"";
		return x;
	}

	int PrintNode (String label) {
		System.out.println("\n\nPrintNode\n-------------\nlabel = " + label + "\nid = " + count);

		int id = GetId();
		graph += (id + " [label=\"" + label + "\"]\n");
		return id;
	}

	void PrintEdge (int id1, int id2) {
		System.out.println("\n\nPrintEdge\n-------------\nid1 = " + id1 + "\nid2 = " + id2);

		
		if ((id1 != -1) && (id2 != -1)) graph += (id1 + " -> " + id2 + "\n");
	}

	void PrintEdges (int id, MySet s) {
		System.out.println("\n\nPrintEdges\n-------------\nid = " + id + "\nsize = " + s.size);

		
		for (int i = 0; i < s.size; i ++) {
			PrintEdge(id, s.ids[i]);
		}
	}

	void PrintGraph () throws IOException {
		System.out.println("\n\nPrintGraph\n-------------");
		

		File file = new File("test.dot");
		file.createNewFile();
		FileWriter writer = new FileWriter(file); 
		writer.write("digraph G {\nordering=out\n" + graph + "\n}\n"); 
		writer.flush();
		writer.close();
		

		System.out.println("digraph G {\nordering=out\n" + graph + "\n}\n");
	}
}

//-------
// Syntax Parser Grammar Definition
//------
program
: Class Program '{' field_decls method_decls '}' 
{
    int id = PrintNode("Program");
    if ($field_decls.s.size > 0) {
		int id2 = PrintNode("Field_decls");
		PrintEdges(id2, $field_decls.s);
		PrintEdge(id, id2);
	}

	if ($method_decls.s.size > 0) {
		int id2 = PrintNode("Method_decls");
		PrintEdges(id2, $method_decls.s);
		PrintEdge(id, id2);
	}

	try {PrintGraph();} catch(IOException e) {}

}
;

field_decls returns [MySet s]
: f=field_decls field_decl ';'
{
	$s = $f.s;
	$s.ExtendArray($field_decl.id);
}
| f=field_decls inited_field_decl ';'
{
	$s = $f.s;
	$s.ExtendArray($inited_field_decl.id);
}
| 
{
	$s = new MySet();
}
;

field_decl returns [int id]
: f=field_decl ',' Ident 
{
	$id = $f.id;
	PrintEdge($f.id, PrintNode($Ident.text));
}
('[' int_literal ']'
{
    PrintEdge($f.id, PrintNode($int_literal.text));
})?
| Type Ident
{
	$id = PrintNode("Field_decl");
	PrintEdge($id, PrintNode($Type.text));
	PrintEdge($id, PrintNode($Ident.text));
}
( '[' int_literal ']'
{
    PrintEdge($id, PrintNode($int_literal.text));
})?
;

inited_field_decl returns [int id]
: Type Ident '=' literal
{
	$id = PrintNode("Inited_field_decl");

	PrintEdge($id, PrintNode($Type.text));
	PrintEdge($id, PrintNode($Ident.text));
	PrintEdge($id, PrintNode($literal.text));
}
;

method_decls returns [MySet s]
: m=method_decls method_decl
{
	$s = $m.s;
	$s.ExtendArray($method_decl.id);
}
|
{
	$s = new MySet();	
}
;

method_decl returns [int id]
: Type Ident '(' ')' block
{
	$id = PrintNode("Method_decl");

	PrintEdge($id, PrintNode($Type.text));
	PrintEdge($id, PrintNode($Ident.text));
	PrintEdge($id, $block.id);	
}
| Type Ident '(' params ')' block
{
	$id = PrintNode("Method_decl");

	PrintEdge($id, PrintNode($Type.text));
	PrintEdge($id, PrintNode($Ident.text));
	PrintEdge($id, $params.id);
	PrintEdge($id, $block.id);	
}
| Void Ident '(' params ')' block
{
	$id = PrintNode("Method_decl");

	PrintEdge($id, PrintNode("void"));
	PrintEdge($id, PrintNode($Ident.text));
	PrintEdge($id, $params.id);
	PrintEdge($id, $block.id);
	
}
;

params returns [int id]
: Type Ident nextParams
{
	$id = PrintNode("Method_args");
	
	PrintEdge($id, PrintNode($Type.text));
	PrintEdge($id, PrintNode($Ident.text));

	PrintEdges($id, $nextParams.s);
}
|
{
	$id = -1;
}
;

nextParams returns [MySet s]
: n=nextParams ',' Type Ident
{
	$s = $n.s;
	
	$s.ExtendArray(PrintNode($Type.text));
	$s.ExtendArray(PrintNode($Ident.text));
}
|
{
	$s = new MySet();
}
;

block returns [int id]
: '{' var_decls statements '}'
{
	$id = -1;
	if ($var_decls.s.size > 0) {
		$id = PrintNode("Block");
		int id2 = PrintNode("Var_decls");
		PrintEdges(id2, $var_decls.s);
		PrintEdge($id, id2);
	}
	if ($statements.id != -1) {
		if ($id == -1) $id = PrintNode("Block");
		PrintEdge($id, $statements.id);
	}
}
;

var_decls returns [MySet s]
: v=var_decls var_decl ';'
{
	$s = $v.s;
	$s.ExtendArray($var_decl.id);
}
| 
{
	$s = new MySet();
}
;

var_decl returns [int id]
: v=var_decl ',' Ident
{
	$id = $v.id;
	
	PrintEdge($id, PrintNode($Ident.text));
}
| Type Ident
{
	$id = PrintNode("Var_decl");
	
	PrintEdge($id, PrintNode($Type.text));
	PrintEdge($id, PrintNode($Ident.text));
}
;

statements returns [int id]
: statement t=statements
{
	if ($t.id != -1) {
		$id = PrintNode("Seq");
		PrintEdge($id, $statement.id);
		PrintEdge($id, $t.id);
	} else {
		$id = $statement.id;
	}
}
|
{
	$id = -1;
}
;

// <statement> -> <location> <assign_op> <expr> ;
statement returns [int id]
: location '=' expr ';'
{
	$id = PrintNode("Assign");
	PrintEdge($id, $location.id);
	PrintEdge($id, PrintNode("="));
	PrintEdge($id, $expr.id);
}
| location '+=' expr ';'
{
	$id = PrintNode("Assign");
	PrintEdge($id, $location.id);
	PrintEdge($id, PrintNode("+="));
	PrintEdge($id, $expr.id);
}
| location '-=' expr ';'
{
	$id = PrintNode("Assign");
	PrintEdge($id, $location.id);
	PrintEdge($id, PrintNode("-="));
	PrintEdge($id, $expr.id);
}
| method_call ';'
{
    $id = $method_call.id;
}
| ext_method_call ';'
{
    $id = $ext_method_call.id;
}
| If '(' expr ')' b1=block Else b2=block
{
    $id = PrintNode("If_Else");
    PrintEdge($id, $expr.id);
    PrintEdge($id, $b1.id);
    PrintEdge($id, $b2.id);
}
| If '(' expr ')' block
{
    $id = PrintNode("If");
    PrintEdge($id, $expr.id);
    PrintEdge($id, $block.id);
}
| Switch expr '{' case_seq '}'
{
    $id = PrintNode("Switch");
    PrintEdge($id, $expr.id);
    PrintEdge($id, $case_seq.id);
}
| While '(' expr ')' s=statement
{
    $id = PrintNode("While");
    PrintEdge($id, $expr.id);
    PrintEdge($id, $s.id);
}
| Ret ';'
{
    $id = PrintNode("Ret");
}
| Ret expr ';'
{
    $id = PrintNode("Ret");
    PrintEdge($id, $expr.id);
}
| Brk ';'
{
    $id = PrintNode("Brk");
}
| Cnt ';'
{
    $id = PrintNode("Cnt");
}
| block
{
	$id = $block.id;
};

case_seq returns [int id]
: cases
{
    $id = PrintNode("CaseSeq");
    PrintEdges($id, $cases.s);
}
;

cases returns [MySet s]
: c=cases case_sample
{
    $s = $c.s;
    $s.ExtendArray($case_sample.id);
}
| case_sample
{
    $s = new MySet();
    $s.ExtendArray($case_sample.id);
}
;

case_sample returns [int id]
: Case literal ':' statements
{
    $id = PrintNode("Case");
    PrintEdge($id, PrintNode($literal.text));
    PrintEdge($id, $statements.id);
}
|
Case literal ':'
{
    $id = PrintNode("Case");
    PrintEdge($id, PrintNode($literal.text));
}
;

method_call returns [int id]
: Ident '(' ')'
{
    $id = PrintNode("User_meth");
    PrintEdge($id, PrintNode($Ident.text));
}
| Ident '(' expr_arg next_args ')'
{
    $id = PrintNode("User_meth");
    PrintEdge($id, $expr_arg.id);
    PrintEdges($id, $next_args.s);
}
;

ext_method_call returns [int id]
: Callout '(' str_arg ')'
{
    $id = PrintNode("Ext_meth");
    PrintEdge($id, PrintNode("callout"));
    PrintEdge($id, $str_arg.id);
}
| Callout '(' str_arg callout_args ')'
{
    $id = PrintNode("Ext_meth");
    PrintEdge($id, PrintNode("callout"));
    PrintEdge($id, $str_arg.id);
    PrintEdges($id, $callout_args.s);
}
;
callout_args returns [MySet s]
: c=callout_args ',' expr_arg
{
    $s = $c.s;
    int id = $expr_arg.id;
    $s.ExtendArray(id);
}
| c=callout_args ',' str_arg
{
    $s = $c.s;
    $s.ExtendArray($str_arg.id);
}
|
{
    $s = new MySet();
}
;

str_arg returns [int id]
: Str
{
    $id = PrintNode("string_arg");
    PrintEdge($id, PrintNode(ProcessString($Str.text)));
};

next_args returns [MySet s]
: e=next_args ',' expr_arg
{
    $s = $e.s;
    int id = $expr_arg.id;
    $s.ExtendArray(id);
}
|
{
    $s = new MySet();
}
;

expr_arg returns [int id]
: expr
{
    $id = PrintNode("Expr_arg");
    PrintEdge($id, $expr.id);
}
;

//<expr> -> <expr> <bin_op> <expr>
//<expr> -> <location>
//<expr> -> <literal>
multiOp: '*' | '/' | '%';
addOp: '+' | '-';

expr returns [int id]
: e1=expr '||' and_expr
{
	$id = PrintNode("Bin_expr");
	PrintEdge($id, $e1.id);
	PrintEdge($id, PrintNode("||"));
	PrintEdge($id, $and_expr.id);
}
| and_expr
{
	$id = $and_expr.id;
}
;

and_expr returns [int id]
: e1=and_expr '&&' equal_expr
{
	$id = PrintNode("Bin_expr");
	PrintEdge($id, $e1.id);
	PrintEdge($id, PrintNode("&&"));
	PrintEdge($id, $equal_expr.id);
}
| equal_expr
{
	$id = $equal_expr.id;
}
;

equal_expr returns [int id]
: e1=equal_expr EqOp rel_expr
{
	$id = PrintNode("Bin_expr");
	PrintEdge($id, $e1.id);
	PrintEdge($id, PrintNode($EqOp.text));
	PrintEdge($id, $rel_expr.id);
}
| rel_expr
{
	$id = $rel_expr.id;
}
;

rel_expr returns [int id]
: e1=rel_expr Relop add_expr
{
	$id = PrintNode("Bin_expr");
	PrintEdge($id, $e1.id);
	PrintEdge($id, PrintNode($Relop.text));
	PrintEdge($id, $add_expr.id);
}
| add_expr
{
	$id = $add_expr.id;
}
;

add_expr returns [int id]
: e1=add_expr addOp multi_expr
{
	$id = PrintNode("Bin_expr");
	PrintEdge($id, $e1.id);
	PrintEdge($id, PrintNode($addOp.text));
	PrintEdge($id, $multi_expr.id);
}
| multi_expr
{
	$id = $multi_expr.id;
}
;

multi_expr returns [int id]
: e1=multi_expr multiOp not_expr
{
	$id = PrintNode("Bin_expr");
	PrintEdge($id, $e1.id);
	PrintEdge($id, PrintNode($multiOp.text));
	PrintEdge($id, $not_expr.id);
}
| not_expr
{
	$id = $not_expr.id;
}
;

not_expr returns [int id]
: '-' e1=not_expr
{
	$id = PrintNode("Neg_expr");
	PrintEdge($id, $e1.id);
}
| '!' e1=not_expr
{
	$id = PrintNode("Not_expr");
	PrintEdge($id, $e1.id);
}
| literal_expr
{
	$id = $literal_expr.id;
}
;

literal_expr returns [int id]
: literal
{
	$id = PrintNode("Const_expr");
	PrintEdge($id, PrintNode($literal.text));
}
| location
{
	$id = PrintNode("Loc_expr");
	PrintEdge($id, $location.id);
}
| method_call
{
	$id = PrintNode("Call_expr");
	PrintEdge($id, $method_call.id);
}
| '(' expr ')'
{
	$id = $expr.id;
}
;

location returns [int id]
: Ident '[' expr ']'
{
	$id = PrintNode("Loc");
	PrintEdge($id, PrintNode($Ident.text));
    PrintEdge($id, $expr.id);
}
| Ident
{
	$id = PrintNode("Loc");
	PrintEdge($id, PrintNode($Ident.text));
}
;

int_literal: Num | HexNum;
literal: int_literal | Char | BoolLit;

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

While: 'while';

Ret: 'return';

Brk: 'break';

Cnt: 'continue';

Callout: 'callout';

Switch: 'switch';

Case: 'case';

Num: Digit+;

HexNum: '0x'HexDigit+;

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

EqOp: '==' | '!=';

