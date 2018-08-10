# Configure Java compiler
JC = javac
JFAGS = -g
ANLTR = java -Xmx500M org.antlr.v4.Tool
PKG = jar
PKGPRA = cvfm  

# Configure output
OUTPUT = ./

# Configure source files
SRCS = ./*.java
X86_SRCS = ./x86/*.java
# Configure output class
CLASSES = *.class
X86_CLASSES = ./x86/*.class

# target
default:init $(CLASSES) $(X86_CLASSES)

init:
	$(ANLTR) Cmpt379Compiler.g4

# Compile
$(CLASSES):
	$(JC) $(JFAGS) $(SRCS) -d $(OUTPUT)

$(X86_CLASSES): 
	$(JC) $(JFAGS) $(X86_SRCS) -d $(OUTPUT)

clean:
	-rm -r *.class *.java *.tokens test*.png ./x86/*.class
