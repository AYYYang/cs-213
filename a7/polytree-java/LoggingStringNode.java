public class LoggingStringNode extends StringNode {

  LoggingStringNode(String s) {
    super(s);
  }
  
  @Override
  void insert(Node node) {
    super.insert(node);
    node.printNode();
    System.out.print("insert ");
    node.printNode();
  }
}