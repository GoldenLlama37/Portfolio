class SLNode(object):
    def __init__(self, value):
        self.value = value
        self.next = None

class SList(object):
    def __init__(self):
        self.head = None
        self.tail = None

    def PrintAllVals(self):
        runner = list.head
        while(runner.next != None):
                print(runner.value)
                runner = runner.next
                if runner.next == None:
                    print runner.value

    def AddBack(self, newValue):
        runner = list.head
        while(runner.next != None):
                runner = runner.next
                if runner.next == None:
                    runner.next = SLNode(newValue)
                    list.tail = runner.next
                    break

    def AddFront(self, newValue):
        newHead = SLNode(newValue)
        newHead.next = list.head
        list.head = newHead

    def InsertBefore(self, nextVal, val):
        runner = list.head
        newNode = SLNode(val)
        while(runner.next.value != nextVal):
            runner = runner.next
            if runner.next.value == nextVal:
                followingNode = runner.next
                runner.next = newNode
                newNode.next = followingNode
                break

    def InsertAfter(self, preval, val):
        runner = list.head
        newNode = SLNode(val)
        while(runner.value != preval):
            runner = runner.next
            if runner.value == preval:
                followingNode = runner.next
                runner.next = newNode
                newNode.next = followingNode
                break

    def RemoveNode(self, val):
        runner = list.head
        while(runner.value != val):
            previousNode = runner
            runner = runner.next
            if runner.value == val:
                followingNode = runner.next
                previousNode.next = followingNode
                del runner
                break

    def ReverseList(self):
        runner = list.head
        emptyList = []
        while(runner.value != None):
            emptyList.append(runner.value)
            if runner.next == None:
                break
            else:
                runner = runner.next
        emptyList.reverse()
        index = 0
        runner = list.head
        while(runner.value != None):
            runner.value = emptyList[index]
            index += 1
            if runner.next == None:
                break
            else:
                runner = runner.next
