using System;

namespace DoublyLinkedLists
{
    public class DllNode
    {
        public int Value;
        public DllNode Next;
        public DllNode Prev;
        public DllNode(int val) 
        {
            Value = val;
            Next = null;
            Prev = null;
        }
    }
}
