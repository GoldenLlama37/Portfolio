using System;
using System.Collections.Generic;

namespace Tries
{
    public class Node
    {
        public Node parentNode { get; set; }
        public char letter { get; set; }
        public List<Node> childNodes { get; set; }
        public int depth { get; set; }
        public bool isWord { get; set; }
        public string wordValue { get; set; }
        public int totalChildNodes { get; set; }
        public int nodeCounter { get; set; }
        public Node(Node parent, char value, int Depth, bool isword, string wordvalue)

        {
            parentNode = parent;
            letter = value;
            childNodes = new List<Node>();
            depth = Depth;
            isWord = isword;
            wordValue = wordvalue;
            nodeCounter = 0;
        }
        public List<Node> FindChildNodes(Node inputNode)
        {
            List<Node> returnList = new List<Node>();
            foreach (Node childNode in inputNode.childNodes)
            {
                returnList.Add(childNode);
            }
            return returnList;
        }
    }
}