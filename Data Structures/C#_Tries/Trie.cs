using System;
using System.Collections.Generic;
using System.Linq;

namespace Tries
{
    public class TrieList
    {
        public Node rootNode;
        public TrieList()
        {
            rootNode = new Node(null, '^', 0, false, null);
        }
        public void Add(string word)
        {
            Node currentNode = rootNode;
            int depthCounter = 0;
            foreach (char c in word)
            {
                depthCounter++;
                bool nodeMatches = false;
                foreach (Node childNode in currentNode.childNodes)
                {
                    if (c == childNode.letter)
                    {
                        
                        currentNode = childNode;
                        nodeMatches = true;
                    }
                }
                if (nodeMatches == false)
                {
                    if (depthCounter == word.Length)
                    {
                        Node newNode = new Node(currentNode, c, depthCounter, true, word);
                        currentNode.childNodes.Add(newNode);
                        currentNode.totalChildNodes = currentNode.childNodes.Count;
                        currentNode.nodeCounter = currentNode.childNodes.Count;
                        currentNode = newNode;
                    }
                    else
                    {
                        Node newNode = new Node(currentNode, c, depthCounter, false, null);
                        currentNode.childNodes.Add(newNode);
                        currentNode.totalChildNodes = currentNode.childNodes.Count;
                        currentNode.nodeCounter = currentNode.childNodes.Count;
                        currentNode = newNode;
                    }
                }
            }
        }
        public bool Contains(string word)
        {
            int wordDepth = word.Length;
            int depthCounter = 1;
            Node currentNode = rootNode;
            foreach (char c in word)
            {         
                foreach (Node childNode in currentNode.childNodes)
                {
                    if (c == childNode.letter)
                    {
                        
                        currentNode = childNode; 
                        if (depthCounter == wordDepth)
                        {
                            return true;
                        }
                        depthCounter++;
                    }
                }
            }
            return false;
        }
        public string[] Autocomplete(string prefix)
        {
            List<string> WordsInList= new List<string>();
            int prefixLength = prefix.Length;
            int prefixCounter = 0;
            Node currentNode = rootNode;
            foreach (char c in prefix)
            {
                prefixCounter++;                
                foreach (Node childNode in currentNode.childNodes)
                {
                    if (c == childNode.letter)
                    {           
                        currentNode = childNode; 
                        if (prefixLength == prefixCounter)
                        {
                            Node startingNode = currentNode;
                            if (currentNode.nodeCounter > 0)//THIS IS STARTING NODE. ha, have, having, half. a totalchildnodes == 3.
                            {
                                while (currentNode.nodeCounter >= 0)
                                {
                                    currentNode.nodeCounter--;
                                    if (currentNode.isWord == true)
                                    {
                                        WordsInList.Add(currentNode.wordValue);
                                    }
                                    List<Node> nextNodeList;
                                    nextNodeList = currentNode.FindChildNodes(currentNode);
                                    if (currentNode.nodeCounter < 0)
                                    {
                                        if (currentNode.isWord == true)
                                        {
                                            WordsInList.Add(currentNode.wordValue);
                                        }
                                        currentNode.nodeCounter = currentNode.totalChildNodes;
                                        currentNode = currentNode.parentNode;//moves backward
                                        if (currentNode == startingNode.parentNode)
                                        {
                                            break;
                                        }
                                    }
                                    else
                                    {
                                        currentNode = nextNodeList[currentNode.nodeCounter];//moves to next node
                                    }
                                }
                            }
                        }
                    }
                }
            }
            List<string> uniqueWords = WordsInList.Distinct().ToList();
            return uniqueWords.ToArray();
        }
    }
}
