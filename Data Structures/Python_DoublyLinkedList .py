class DLnode(object):
    def __init__(self, value):
        self.value = value
        self.next = None
        self.prev = None

class DList(object):
    def __init__(self):
        self.head = None
        self.tail = None

    def AddNode(self, value):
        previousEndNode = list.tail
        newNode = DLnode(value)
        previousEndNode.next = newNode
        list.tail = newNode
        newNode.prev = previousEndNode

    def PrintAllVals(self):
        runner = list.head
        while(runner.next != None):
                print(runner.value)
                runner = runner.next
                if runner.next == None:
                    print runner.value
        print "\n"

    def deleteNode(self, val):
        runner = list.head
        while(runner.value != None):
            if runner.prev != None:
                previousNode = runner.prev
            if runner.value == val:
                if runner.next == None:
                    list.tail = previousNode
                    previousNode.next = None
                    break
                elif runner.prev == None:
                    list.head = runner.next
                    runner.next = None
                    del runner
                    break
                else:
                    followingNode = runner.next
                    previousNode.next = followingNode
                    followingNode.prev = previousNode
                    del runner
                    break
            runner = runner.next

    def InsertAfter(self, preval, val):
        runner = list.head
        newNode = DLnode(val)
        while(runner.value != None):
            if runner.prev != None:
                previousNode = runner
            if runner.value == preval:
                if runner.next == None:
                    runner.next = newNode
                    newNode.prev = runner
                    list.tail = newNode
                    break
                elif runner.value == list.head.value:
                    followingNode = runner.next
                    runner.next = newNode
                    newNode.prev = runner
                    newNode.next = followingNode
                    followingNode.prev = newNode
                else:
                    newNode.next = runner
                    newNode.prev = previousNode
                    previousNode.next = newNode
                    runner.prev = newNode
                    break
            runner = runner.next