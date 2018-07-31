grammar Cmpt379Compiler;

@header {

import java.io.*;
}

@parser::members {

public enum DataType {
	INT, BOOLEAN, ARRAY, CHAR, STRING, VOID, INVALID
}

public class Array {
	int size;
	DataType type;
	Array arr;

    Array() {
        size = 0;
        type =  DataType.INVALID;
        arr = null;
    }

	Array(Array a, int s) {
        arr = a;
        type = DataType.ARRAY;
        size = s;
    }

    Array(DataType d, int s) {
        size = s;
        type = d;
        arr = null;
    }
}

public class Symbol {
	
	String name;
	DataType dt;
    Array arr;

	Symbol (String n, DataType d) {
		name = n;
		dt = d;
        arr = null;
	}

	Symbol (int id, DataType d) {
		name = "t_" + id;
		dt = d;
        arr = null;
	}

    Symbol (String n, Array a) {
        name = n;
        dt = DataType.ARRAY;
        arr = a;
    }

    Symbol (int id, Array a) {
        name = "t_" + id;
		dt = DataType.ARRAY;
        arr = a;
    }

	boolean Equal (String n) {
		return (name.equals(n));
	}

	DataType GetType () {
		return dt;
	}

	String GetName () {
		return name;
	}

	void Print() {
		System.out.println(name + "\t" + dt);
	}
}

int symbol_counter = 0;
public class SymTab {
	
	Symbol st[];
	int size;
	int temps;

	SymTab () {
		st = new Symbol[1000];
		size = 0;
		temps = 0;
	}

	int Find (String n) {
		for (int  i = 0; i < size; i ++) {
			if (st[i].Equal(n)) return i;
		}
		
		return -1;
	}

    int Insert(DataType d) {	
		st[size] = new Symbol(symbol_counter++, d);
		return (size ++);
	}

	int Insert(String n, DataType d) {
		int id = Find(n);
		if (id != -1) return id;
	
		st[size] = new Symbol(n, d);
		return (size ++);
	}

    int Insert(String n, Array a) {
        int id = Find(n);
        if (id != -1) return id;

        st[size] = new Symbol(n, a);
        return (size++); 
    }

	int Add (DataType d) {
		st [size] = new Symbol (temps, d);
		temps ++;
		return (size ++);
	}

    int ToArray (int id, int s) {
        Symbol temp = st[id];
        Array a = new Array();
        if (temp.dt == DataType.ARRAY){
            a.arr = temp.arr;
            a.size = s;
            a.type = DataType.ARRAY;
            temp.arr = a;
        } else {
            a.type = temp.dt;
            a.size = s;
            a.arr = null;
            temp.arr = a;
            temp.dt = DataType.ARRAY;
        }
        return id;
    }

	DataType GetType (int id) {
		if (id == -1) return DataType.INVALID;
		return (st[id].GetType());
	}

	String GetName (int id) {
		if (id == -1) return ("");
		return (st[id].GetName()); 
	}

	void Print() {
		for (int  i = 0; i < size; i ++) {
			st[i].Print();
		}
	}

	

}
SymTab s = new SymTab();

public class Quad {

	int label;
	String op;
	int src1;
	int src2;
	int dst;


	Quad (int l, int d, int s1, int s2, String o) {
		label = l;
		dst = d;
		src1 = s1;
		src2 = s2;
		op = o;
	}

	void Print () {
        if (op == "if")
            System.out.println("L_" + label + ": if " + s.GetName(dst) + " goto L_" 
				+ s.GetName(src1));
        else if (op == "ifElse")
            System.out.println("L_" + label + ": ifElse " + s.GetName(dst) + " goto L_" 
				+ s.GetName(src1));
        else if (op == "[]=")
            System.out.println("L_" + label + ": " + s.GetName(dst) + " [ " + s.GetName(src1) + " ] = "
                + s.GetName(src2));
        else if (op == "[]+=")
            System.out.println("L_" + label + ": " + s.GetName(dst) + " [ " + s.GetName(src1) + " ] = "
                + s.GetName(dst) + " [ " + s.GetName(src1) + " ] + " + s.GetName(src2));
        else if (op == "[]-=")
            System.out.println("L_" + label + ": " + s.GetName(dst) + " [ " + s.GetName(src1) + " ] = "
                + s.GetName(dst) + " [ " + s.GetName(src1) + " ] - " + s.GetName(src2));
        else if (op == "=[]")
            System.out.println("L_" + label + ": " + s.GetName(dst) + " = " + s.GetName(src1) 
				+ "[ " + s.GetName(src2) + " ]");
        else if (op == "call")
            System.out.println("L_" + label + ": " + s.GetName(dst) + " = " + s.GetName(src1) 
				+ " call " + s.GetName(src2));
        else if (op == "callout")
            System.out.println("L_" + label + ":  = " + s.GetName(src1) 
				+ " call " + s.GetName(src2));
        else if (op == "method_decl")
            System.out.println(s.GetName(dst) + ":");
        else if (op == "param")
            System.out.println("L_" + label + ": " + s.GetName(dst) + " param");
        else if (op == "ret")
            System.out.println("L_" + label + ":  = " + s.GetName(dst) + " ret");
        else if (op == "goto")
            System.out.println("L_" + label + ": goto L_" + s.GetName(src1));
        else if (op == "")
            System.out.println("L_" + label + ":");
        else if (op == "=")
            System.out.println("L_" + label + ": " + s.GetName(dst) + " = " 
				+ s.GetName(src1));
        else
		    System.out.println("L_" + label + ": " + s.GetName(dst) + " = " 
				+ s.GetName(src1) + " " + op + " " + s.GetName(src2));
	}

    
}



public int[] Merge(int[] l1, int[] l2) {
    if (l1 == null)
        return l2;
    if (l2 == null)
        return l1;
    int[] res = new int[l1.length + l2.length];
    for (int i = 0; i < l1.length; i++) {
        res[i] = l1[i];
    }
    for (int i = l1.length; i < l1.length + l2.length; i++) {
        res[i] = l2[i - l1.length];
    }
    return res;
}

public class QuadTab {

	Quad qt[];
	int size;

	QuadTab () {
		qt = new Quad[1000];
		size = 0;
	}
	int Add(int dst, int src1, int src2, String op) {
			
		qt[size] = new Quad(size, dst, src1, src2, op);
		return (size ++);
	}

	void Print() {
		for (int  i = 0; i < size; i ++) {
			qt[i].Print();
		}
	}

    void BackPatch(int[] l){
        if (l == null)
            return;
        for (int i = 0; i < l.length; i++) {
            qt[l[i]].src1 = s.Insert(Integer.toString(size), DataType.INT);
        }
    }

    void BackPatch(int[] l, int instId){
        if (l == null)
            return;
        for (int i = 0; i < l.length; i++) {
            qt[l[i]].src1 = s.Insert(Integer.toString(instId), DataType.INT);
        }
    }

    int[] MakeList() {
        int[] res = {size};
        return res;
    }

    int[] MakeList(int l) {
        int[] res = {l};
        return res;
    }
}

QuadTab q = new QuadTab();

}


//---------------------------------------------------------------------------

program
: Class Program '{' field_decls method_decls '}'
{
	// s.Print();
	// System.out.println("------------------------------------");
	q.Print();
}
;

field_decls
: f=field_decls field_decl ';'
| f=field_decls inited_field_decl ';'
|
;

field_decl returns [DataType t]
: f=field_decl ',' Ident 
{
	$t = $f.t;
	int id = s.Insert($Ident.text, $t);
}
('[' int_literal ']'
{
    s.ToArray(id , Integer.parseInt($int_literal.text));
})?
| Type Ident
{
	$t = DataType.valueOf($Type.text.toUpperCase());
	int id = s.Insert($Ident.text, $t);	
}
( '[' int_literal ']'
{
    s.ToArray(id , Integer.parseInt($int_literal.text));
})?
;

inited_field_decl
: Type Ident '=' int_literal
{
    int id = s.Insert($Ident.text, DataType.valueOf($Type.text.toUpperCase()));
    q.Add(id, $int_literal.id, -1, "=");
}
;

method_decls
: m=method_decls method_decl
|
;

method_decl
: Type Ident
{
	int method_id = s.Insert($Ident.text, DataType.valueOf($Type.text.toUpperCase()));
    q.Add(method_id, -1, -1, "method_decl");
} 
'(' ')' block
{
    int dummy = q.Add(-1, -1, -1, "");
    if ($block.nextlist != null && $block.nextlist.length != 0)
        q.BackPatch($block.nextlist, dummy);
    if ($block.nextlist != null && $block.nextlist.length != 0)
        q.BackPatch($block.nextlist, dummy);
}
| Type Ident 
{
	int method_id = s.Insert($Ident.text, DataType.valueOf($Type.text.toUpperCase()));
    q.Add(method_id, -1, -1, "method_decl");
} 
'(' params ')' block
{
    int dummy = q.Add(-1, -1, -1, "");
    if ($block.nextlist != null && $block.nextlist.length != 0)
        q.BackPatch($block.nextlist, dummy);
    if ($block.nextlist != null && $block.nextlist.length != 0)
        q.BackPatch($block.nextlist, dummy);
}
| Void Ident 
{
	int method_id = s.Insert($Ident.text, DataType.VOID);
    q.Add(method_id, -1, -1, "method_decl");
} 
'(' params ')' block
{
    int dummy = q.Add(-1, -1, -1, "");
    if ($block.nextlist != null && $block.nextlist.length != 0)
        q.BackPatch($block.nextlist, dummy);
    if ($block.nextlist != null && $block.nextlist.length != 0)
        q.BackPatch($block.nextlist, dummy);
}
;

params
: Type Ident nextParams
|
;

nextParams
: n=nextParams ',' Type Ident
|
;

block returns [int[] nextlist, int[] cntlist, int[] brklist]
: '{' var_decls statements '}'
{
    $nextlist = $statements.nextlist;
    $cntlist = $statements.cntlist;
    $brklist = $statements.brklist;
}
;

var_decls 
: v=var_decls var_decl ';'
| 
;


var_decl returns [DataType t]
: v=var_decl ',' Ident
{
	$t = $v.t;
	s.Insert($Ident.text, $t);
}
| Type Ident
{
	$t = DataType.valueOf($Type.text.toUpperCase());
	s.Insert($Ident.text, $t);					
}
;



statements returns [int[] nextlist, int[] cntlist, int[] brklist]
: t=statements 
{
    q.BackPatch($t.nextlist);
    q.BackPatch($t.brklist);
}
statement 
{
    $nextlist = $statement.nextlist;
    $brklist = $statement.brklist;
    $cntlist = Merge($statement.cntlist, $t.cntlist);
}
| statement
{
    $nextlist = $statement.nextlist;
    $brklist = $statement.brklist;
    $cntlist = $statement.cntlist;
}
;

statement returns [int[] nextlist, int[] brklist, int[] cntlist]
: location '=' expr ';'
{
    if ($location.offset != -1) {
        q.Add($location.id, $location.offset, $expr.id, "[]=");
    } else
	    q.Add($location.id, $expr.id, -1, "=");
}
| location '+=' expr ';'
{
    if ($location.offset != -1) {
        q.Add($location.id, $location.offset, $expr.id, "[]+=");
    } else 
        q.Add($location.id, $location.id, $expr.id, "+");
}
| location '-=' expr ';'
{
    if ($location.offset != -1) {
        q.Add($location.id, $location.offset, $expr.id, "[]-=");
    } else 
	    q.Add($location.id, $location.id, $expr.id, "-");
}
| method_call ';'
| If '(' bool_expr ')' 
{
    q.BackPatch($bool_expr.truelist);
}
b1=block 
{
    int[] temp = q.MakeList();
    q.Add(-1, -1, -1, "goto");
    temp = Merge($b1.nextlist, temp);
}
Else 
{
    q.BackPatch($bool_expr.falselist);
}
b2=block
{
    $nextlist = Merge(temp, $b2.nextlist);
    $cntlist = Merge($b1.cntlist, $b2.cntlist);
    $brklist = Merge($b1.brklist, $b2.brklist);
}

| If '(' bool_expr ')' 
{
    q.BackPatch($bool_expr.truelist); 
}
block
{
    $nextlist = Merge($bool_expr.falselist, $block.nextlist);
    $cntlist = $block.cntlist;
    $brklist = $block.brklist;
}
| Switch expr 
{
    int temp = $expr.id;
} 
'{' cases[temp] '}'
{
    q.BackPatch($cases.brklist);
    $nextlist = $cases.nextlist;
    $cntlist = $cases.cntlist;
}
| While {
    int m1 = q.size;
} 
'(' bool_expr ')' 
{
    $nextlist = $bool_expr.falselist;
    q.BackPatch($bool_expr.truelist);
} 
stat=statement
{
    q.BackPatch($stat.nextlist, m1);
    q.Add(-1, s.Insert(Integer.toString(m1), DataType.INT), -1, "goto");
    q.BackPatch($stat.cntlist, m1);
    $brklist = $stat.brklist;
}
| Ret ';'
{
    q.Add(0, -1, -1, "ret");
}
| Ret expr ';'
{
    q.Add($expr.id, -1, -1, "ret");
}
| Brk ';'
{
    $brklist = q.MakeList();
    q.Add(-1, -1, -1, "goto");
}
| Cnt ';'
{
    $cntlist = q.MakeList();
    q.Add(-1, -1, -1, "goto");
}
| block
{
    $nextlist = $block.nextlist;
    $brklist = $block.brklist;
    $cntlist = $block.cntlist;
}
;

cases[int eid] returns [int[] nextlist, int[] cntlist, int[] brklist]
: case_sample[eid] c=cases[eid]
{
    $nextlist = Merge($c.nextlist, $case_sample.nextlist);
    $cntlist = Merge($c.cntlist, $case_sample.cntlist);
    $brklist = Merge($c.brklist, $case_sample.brklist);
}
| case_sample[eid]
{
    $nextlist = $case_sample.nextlist;
    $cntlist = $case_sample.cntlist;
    $brklist = $case_sample.brklist;
}
|
;

case_sample[int eid] returns [int[] nextlist, int[] cntlist, int[] brklist]
: Case literal
{
    int tid = s.Insert(DataType.BOOLEAN);
    q.Add(tid, $literal.id, eid, "==");
    int[] truelist = q.MakeList();
    q.Add(tid, -1, -1, "if");
    int[] falselist = q.MakeList();
    q.Add(tid, -1, -1, "ifElse");
    q.BackPatch(truelist);
}
 ':' statements
 {
    q.BackPatch(falselist);
    $nextlist = $statements.nextlist;
    $cntlist = $statements.cntlist;
    $brklist = $statements.brklist;
 }
|
Case literal ':'
;

method_call returns [ int id ]
:
Ident '(' args ')'
{
    int method_id = s.Find($Ident.text);
    if (method_id != -1){
        $id = s.Insert(s.GetType(method_id));
    } else {
        $id = -1;
    }
    q.Add($id, method_id, s.Insert(Integer.toString($args.arg_count), DataType.INT), "call");
}
| Callout '(' Str callout_args ')'
{
    q.Add(-1, s.Insert($Str.text, DataType.STRING), s.Insert(Integer.toString($callout_args.arg_count), DataType.INT), "callout");
}
;

callout_args returns [int arg_count]
: c=callout_args ',' expr_arg
{
    $arg_count = $c.arg_count + 1;
}
| c=callout_args ',' str_arg
{
    $arg_count = $c.arg_count + 1;
}
|
{
    $arg_count = 0;
}
;

str_arg returns [int arg_count]
: Str
{
    q.Add(s.Insert($Str.text, DataType.STRING), -1, -1, "param");
    $arg_count = 1;
};

args returns [int arg_count]
: e=args ',' expr_arg
{
    $arg_count = $e.arg_count + 1;
}
| expr_arg
{
    $arg_count = 1;
}
|
{
    $arg_count = 0;
}
;

expr_arg returns [int arg_count]
: expr
{
    $arg_count = 1;
    q.Add($expr.id, -1, -1, "param");
}
;


//<expr> -> <expr> <bin_op> <expr>
//<expr> -> <location>
//<expr> -> <literal>
multiOp: '*' | '/' | '%';
addOp: '+' | '-';

bool_expr returns [int[] truelist, int[] falselist]
: e1=bool_expr '||' 
{
    int m1 = q.size;
}
and_expr
{
    q.BackPatch($e1.falselist, m1);
    $truelist = Merge($e1.truelist, $and_expr.truelist);
    $falselist = $and_expr.falselist;
}
| and_expr
{
    $truelist = $and_expr.truelist;
    $falselist = $and_expr.falselist;
}
;

and_expr returns [int[] truelist, int[] falselist]
: e1=and_expr '&&'
{
    int m1 = q.size;
} 
not_expr
{
    q.BackPatch($e1.truelist, m1);
    $truelist = $not_expr.truelist;
    $falselist = Merge($e1.falselist, $not_expr.falselist);
}
| not_expr
{
    $truelist = $not_expr.truelist;
    $falselist = $not_expr.falselist;
}
;

not_expr returns [int[] truelist, int[] falselist]
: '!' e1=not_expr
{
    $truelist = $e1.falselist;
    $falselist = $e1.truelist;
}
| expr
{
    int if_id = q.Add($expr.id, -1, -1, "if");
    int else_id = q.Add($expr.id, -1, -1, "ifElse");
    $truelist = new int[] {if_id};
    $falselist = new int[] {else_id};
}
| '(' bool_expr ')'
{
    $truelist = $bool_expr.truelist;
    $falselist = $bool_expr.falselist;
}
;

expr returns [int id]
: e1=expr EqOp rel_expr
{

    $id = s.Insert(DataType.INT);
    q.Add($id, $e1.id, $rel_expr.id, $EqOp.text);
}
| rel_expr
{
    $id = $rel_expr.id;
}
;

rel_expr returns [int id]
: e1=rel_expr Relop add_expr
{
    $id = s.Insert(DataType.INT);
    q.Add($id, $e1.id, $add_expr.id, $Relop.text);
}
| add_expr
{
    $id = $add_expr.id;
}
;

add_expr returns [int id]
: e1=add_expr addOp multi_expr
{
    $id = s.Insert(DataType.INT);
    q.Add($id, $e1.id, $multi_expr.id, $addOp.text);
}
| multi_expr
{
    $id = $multi_expr.id;
}
;

multi_expr returns [int id]
: e1=multi_expr multiOp neg_expr
{
    $id = s.Insert(DataType.INT);
    q.Add($id, $e1.id, $neg_expr.id, $multiOp.text);
}
| neg_expr
{
    $id = $neg_expr.id;
}
;

neg_expr returns [int id]
: '-' e1=neg_expr
{
    $id = s.Insert(DataType.INT);
    q.Add($id, s.Insert(Integer.toString(0), DataType.INT), $e1.id, "-");
}
| literal_expr
{
    $id = $literal_expr.id;
}
;

literal_expr returns [int id]
: literal
{
    $id = $literal.id;
}
| location
{
    if ($location.offset != -1) {
        $id = s.Insert($location.type);
        q.Add($id, $location.id, $location.offset, "=[]");
    } else
        $id = $location.id;
}
| method_call
{
    $id = $method_call.id;
}
| '(' expr ')'
{
    $id = $expr.id;
}
;

location returns [ int id, int offset, DataType type ]
: Ident '[' expr ']'
{
	$id = s.Find($Ident.text);
    $offset = $expr.id;
    $type = s.st[$id].arr.type;
}
| Ident
{
	$id = s.Find($Ident.text);
    $offset = -1;
    $type = s.GetType($id);
}
;

int_literal returns [int id]
: Num
{
	$id = s.Insert($Num.text, DataType.INT);
}
| HexNum
{
	$id = s.Insert($HexNum.text, DataType.INT);
}
;

literal returns [int id]
: int_literal 
{
    $id = $int_literal.id;
}
| Char
{
    $id = s.Insert($Char.text, DataType.CHAR);
} 
| BoolLit
{
    $id = s.Insert($BoolLit.text, DataType.BOOLEAN);
}
;
//--------------------------------------------- END OF SESSION 2 -----------------------------------


//---------------------------------------------------------------------------------------------------
// Session 3: Lexical definition, You SHOULD NOT make any modification to this session
//---------------------------------------------------------------------------------------------------
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

