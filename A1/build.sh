make clean
make
java org.antlr.v4.gui.TestRig A1_Lexer tokens -tokens a1_test_cases/demo0 > test_res/demo0.out
java org.antlr.v4.gui.TestRig A1_Lexer tokens -tokens a1_test_cases/demo1 > test_res/demo1.out
java org.antlr.v4.gui.TestRig A1_Lexer tokens -tokens a1_test_cases/demo2 > test_res/demo2.out
java org.antlr.v4.gui.TestRig A1_Lexer tokens -tokens a1_test_cases/demo3 > test_res/demo3.out
java org.antlr.v4.gui.TestRig A1_Lexer tokens -tokens a1_test_cases/demo4 > test_res/demo4.out
java org.antlr.v4.gui.TestRig A1_Lexer tokens -tokens a1_test_cases/demo5 > test_res/demo5.out
java org.antlr.v4.gui.TestRig A1_Lexer tokens -tokens a1_test_cases/demo6 > test_res/demo6.out