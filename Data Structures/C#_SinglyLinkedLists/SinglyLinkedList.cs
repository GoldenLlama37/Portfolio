using System;

namespace SinglyLinkedLists
{
    public class SinglyLinkedList
    {
        public SllNode Head;
         public SinglyLinkedList() 
        {
            Head = null;
        }
        public void Add(int value) 
        {
            SllNode newNode = new SllNode(value);
            if(Head == null) 
            {
                Head = newNode;
            } 
            else
            {
                SllNode runner = Head;
                while(runner.Next != null) {
                    runner = runner.Next;
                }
                runner.Next = newNode;
            }
        }  
        public void Remove(int value)
        {
            SllNode runner = Head;
            SllNode previous = Head;
            while (runner != null)
            {
                if (runner.Value == value)
                {
                    if (runner == Head)
                    {
                        Head = runner.Next;
                        break;
                    }
                    else if (runner.Next == null)
                    {
                        previous.Next = null;
                        break;
                    }
                    else
                    {
                        previous.Next = runner.Next;
                        break;
                    }
                }
                else
                {
                    previous = runner;
                    runner = runner.Next;
                }
            }
        }
        public void PrintValues()
        {
            SllNode runner = Head;
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
        public void Find(int value)  
        {
            SllNode runner = Head;
            while (runner != null)
            {
                if (runner.Value == value)
                {
                    Console.WriteLine(runner.Value);
                    break;
                }
                else
                {
                    runner = runner.Next;
                    if(runner == null)
                    {
                        Console.WriteLine("Value doesn't exist");
                        break;
                    }
                }
                
            }
        }
        public void RemoveAt(int value)
        {
            SllNode runner = Head;
            int index = value++;
            while (index != 0)
            {
                index--;
                if (index == 0)
                {
                    Remove(runner.Value);
                }
                else
                {
                    runner = runner.Next;
                    if (runner == null)
                    {
                        Console.WriteLine("Not enough nodes");
                        break;
                    }
                }
            }
        }
    }
}