using System;

namespace DoublyLinkedLists
{
    public class DoublyLinkedList
    {
        public DllNode Head;
        public DoublyLinkedList()
        {
            Head = null;
        }
        public void Add(int value)
        {
            DllNode newNode = new DllNode(value);
            if (Head == null)
            {
                Head = newNode;
            }
            else
            {
                DllNode runner = Head;
                DllNode previous;
                while (runner.Value != null)
                {               
                    previous = runner;
                    runner = runner.Next;
                    if (runner == null)
                    {
                        previous.Next = newNode;
                        newNode.Prev = previous;
                        break;
                    }
                }
            }
        } 
        public bool Remove(int value)
        {
            DllNode runner = Head;
            DllNode previous;
            DllNode nextup;
            if (Head.Value == value)
            {
                previous = Head;
                Head.Next = Head;
                previous.Next = null;
                Head.Prev = null;
                return true;
            }
            else
            {
                while (runner.Value != value)
                {               
                    previous = runner;
                    runner = runner.Next;
                    if (runner.Value == value)
                    {
                        if (runner.Next == null)
                        {
                            previous.Next = null;
                            runner.Prev = null;
                            return true;
                        }
                        else
                        {
                            nextup = runner.Next;
                            previous.Next = nextup;
                            nextup.Prev = previous;
                            runner.Next = null;
                            runner.Prev = null;
                            return true;
                        }
                    }
                }
            }
            Console.WriteLine("Values didn't match");
            return false;
        }
        public void Reverse()
        {
            DllNode runner = Head;
            DllNode previous;
            if (runner == Head)
            {
                runner.Prev = runner.Next;
                runner.Next = null;
            }
            while (runner != null)
            {
                previous = runner;
                runner = runner.Prev;
                if (runner.Next == null)
                {
                    previous.Prev = runner;
                    Head = runner;
                    runner.Next = previous;
                    break;
                }
                else
                {
                    runner.Prev = runner.Next;
                    runner.Next = previous;
                }

            }
        }
        public void PrintValues()
        {
            DllNode runner = Head;
            while (runner != null)
            {
                Console.WriteLine($"{runner.Value}");
                if (runner.Next != null)
                {
                    runner = runner.Next;
                }
                else
                {
                    break;
                }
                
            }
        }
    }
}