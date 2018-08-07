package x86;

	public class Quad {

		Symbol label;
		String op;
		Symbol src1;
		Symbol src2;
		Symbol dst;


		public Quad (SymStack s, int l, Symbol d, Symbol s1, Symbol s2, String o) {
			label = s.Add(l);
			dst = d;
			src1 = s1;
			src2 = s2;
			op = o;
		}

		public Quad (Symbol l) {
			label = l;
			dst = null;
			src1 = null;
			src2 = null;
			op = "";
		}

		public void BackPatch (Symbol l) {
			dst = l;
		}

		public Symbol GetLabel () {
			return label;
		}

		public void Print () {
			System.out.print(label.GetName() + ": ");
			if (dst != null) System.out.print(dst.GetName());
			if (src1 != null) System.out.print(" = " + src1.GetName());
			System.out.print(" " + op + " ");
			if (src2 != null) System.out.print(src2.GetName());
			System.out.println("");
		}

		public void AsmPrint () {
			System.out.print(label.GetName() + ": ");
			
			if (op.equals("")) { //label
				System.out.println("push %rbp");
				System.out.println("mov %rsp, %rbp");
			} else if (op.equals("frame")) {
				System.out.println("sub " + dst.AsmPrint() + ", %rsp");
			} else if (op.equals("ret")) { //return
				if (src1 != null) System.out.println("mov -" + src1.GetOffset() + "(%rbp), %rax");
				System.out.println("add $" + dst.GetName() + ", %rsp");
				System.out.println("pop %rbp");
				System.out.println("ret");
			} else if (op.equals("=")) { //assignment
				ReadSrc1(src1);
				WriteDst(dst);
			} else if (op.equals("+")) { //addition
				ReadSrc1(src1);
				ReadSrc2(src2);
				Compute("add");
				WriteDst(dst);
			} else if (op.equals("-") && src2 != null) { // subtraction 
				ReadSrc1(src1);
				ReadSrc2(src2);
				Compute("sub");
				WriteDst(dst);
			} else if (op.equals("*")) {
				ReadSrc1(src1);
				ReadSrc2(src2);
				Compute("imul");
				WriteDst(dst);
			} else if (op.equals("/")) {
				ReadSrc1(src1);
				ReadSrc2(src2);
				System.out.println("mov $0, %rdx");
				System.out.println("idiv %rbx");
				WriteDst(dst);
			} else if (op.equals("%")) {
				ReadSrc1(src1);
				ReadSrc2(src2);
				System.out.println("mov $0, %rdx");
				System.out.println("idiv %rbx");
				System.out.println("mov %rdx, " + dst.AsmPrint());
			} else if (op.equals("-") && src2 == null) {
				ReadSrc1(src1);
				SingleCompute("neg");
				WriteDst(dst);
			} else if (op.equals("=[]")) {
				ReadSrc1(src1);
				ReadSrc2(src2);
				System.out.println("add %rbx, %rax");
				System.out.println("movq %rax, " + dst.AsmPrint()); // may need further implementation
			} else if (op.equals("[]=")) {
				ReadSrc1(src1);
				ReadSrc2(src2);
				ReadDst(dst);
				System.out.println("movq %rbx, (%r10, %rax, 1)");
			} else if (op.equals("goto")) {
				System.out.println("jmp " + dst.AsmPrint().substring(1));
			} else if (op.equals("cmp")) {
				ReadSrc1(src1);
				ReadSrc2(src2);
				System.out.println("cmp %rax, %rbx");
			} else if (op.equals("jle") || op.equals("jl") || op.equals("jge") || op.equals("jg") || op.equals("je") || op.equals("jne")) {
				System.out.println(op + " " + dst.AsmPrint().substring(1));
			} else if (op.equals("call")) {
				System.out.println("call " + src1.GetName());
			} else if (op.equals("rdi") || op.equals("rsi") || op.equals("rdx") || op.equals("rcx") || op.equals("r8") || op.equals("r9")) {
				System.out.println("mov " + dst.AsmPrint() + ", %" + op); 
			} else if (op.equals("callexp")) {
				System.out.println("call " + src1.GetName());
				System.out.println("mov %rax, " + dst.AsmPrint());
			} else if (op.equals("push %rdi")) {
				System.out.println("mov %rdi, " + dst.AsmPrint());
			} else if (op.equals("push %rsi")) {
				System.out.println("mov %rsi, " + dst.AsmPrint());
			} else if (op.equals("push %rdx")) {
				System.out.println("mov %rdx, " + dst.AsmPrint());
			} else if (op.equals("push %rcx")) {
				System.out.println("mov %rcx, " + dst.AsmPrint());
			} else if (op.equals("push %r8")) {
				System.out.println("mov %r8, " + dst.AsmPrint());
			} else if (op.equals("push %r9")) {
				System.out.println("mov %r9, " + dst.AsmPrint());
			}
		}

		void Compute (String opcode) {
			System.out.println(opcode + " %rbx, %rax");
		}

		void SingleCompute (String opcode) {
			System.out.println(opcode + " %rax");
		}

		void ReadSrc1 (Symbol src) {
			System.out.println("mov " + src.AsmPrint() + ", %rax");
		}

		void ReadSrc2 (Symbol src) {
			System.out.println("mov " + src.AsmPrint() + ", %rbx");
		}

		void ReadDst(Symbol dst) {
			System.out.println("mov " + dst.AsmPrint() + ", %r10");
		}

		void WriteDst (Symbol dst) {
			System.out.println("mov %rax, " + dst.AsmPrint());
		}



	}