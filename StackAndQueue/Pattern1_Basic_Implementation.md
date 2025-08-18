# Pattern 1: Basic Data Structure Implementation

This pattern covers the foundational implementation of stacks and queues using basic data structures like arrays and linked lists. Understanding these is crucial before tackling more complex problems.

---

### 1. Implement Stack using Arrays
`[EASY]` `[FUNDAMENTAL]` `#implementation` `#array`

#### Problem Statement
Implement a Stack class using an array. It should support the following operations:
- `push(x)`: Pushes element x onto the stack.
- `pop()`: Removes the element on the top of the stack and returns it.
- `top()`: Gets the top element of the stack.
- `size()`: Returns the number of elements in the stack.
- `isEmpty()`: Returns true if the stack is empty.

#### Implementation Overview
We use an array (or a dynamic list in Python) to store the stack elements. The "top" of the stack is considered the end of the list.
- **Push**: Add the element to the end of the array. This is an amortized O(1) operation.
- **Pop**: Remove the element from the end of the array. This is an O(1) operation.
- **Top**: Return the last element of the array without removing it.
- **Edge Cases**: Check for stack underflow (calling `pop` or `top` on an empty stack).

#### Python Code Snippet
```python
class Stack:
    def __init__(self):
        self.arr = []

    def push(self, x):
        self.arr.append(x)

    def pop(self):
        if self.isEmpty():
            return -1 # Or raise an exception for underflow
        return self.arr.pop()

    def top(self):
        if self.isEmpty():
            return -1
        return self.arr[-1]

    def size(self):
        return len(self.arr)

    def isEmpty(self):
        return len(self.arr) == 0
```

---

### 2. Implement Queue using Arrays
`[EASY]` `[FUNDAMENTAL]` `#implementation` `#array`

#### Problem Statement
Implement a Queue class using an array. It should support:
- `enqueue(x)`: Pushes element x to the back of the queue.
- `dequeue()`: Removes the element from the front of the queue and returns it.
- `front()`: Gets the front element of the queue.
- `size()`: Returns the number of elements in the queue.
- `isEmpty()`: Returns true if the queue is empty.

#### Implementation Overview
A naive implementation using a dynamic array for a queue is inefficient for dequeues (removing from the front is O(n)). A more robust solution uses a circular array with `front` and `rear` pointers. However, for simplicity in many contexts, a basic array is shown, with the acknowledgment of its performance limitations. For efficient queue operations in Python, `collections.deque` is the standard tool.
- **Enqueue**: Add element to the end of the list (O(1)).
- **Dequeue**: Remove element from the beginning of the list (O(n)).

#### Python Code Snippet
```python
# Note: This is a simple but inefficient implementation.
# In Python, collections.deque is strongly preferred for queues.
class Queue:
    def __init__(self):
        self.arr = []

    def enqueue(self, x):
        self.arr.append(x)

    def dequeue(self):
        if self.isEmpty():
            return -1 # Or raise an exception for underflow
        return self.arr.pop(0) # This is an O(n) operation

    def front(self):
        if self.isEmpty():
            return -1
        return self.arr[0]

    def size(self):
        return len(self.arr)

    def isEmpty(self):
        return len(self.arr) == 0
```

---

### 3. Implement Stack using LinkedList
`[EASY]` `[FUNDAMENTAL]` `#implementation` `#linked-list`

#### Problem Statement
Implement a Stack class using a singly linked list.

#### Implementation Overview
The LIFO (Last-In, First-Out) property of a stack is efficiently implemented by adding and removing nodes from the head of a linked list. We only need to maintain a `head` pointer.
- **Push**: Create a new node. Set its `next` pointer to the current `head`, and then update `head` to be the new node.
- **Pop**: The element to pop is the `head`. To remove it, update `head` to point to `head.next`.
- All core operations (push, pop, top) are O(1).

#### Python Code Snippet
```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class Stack:
    def __init__(self):
        self.head = None
        self.stack_size = 0

    def push(self, x):
        new_node = Node(x)
        new_node.next = self.head
        self.head = new_node
        self.stack_size += 1

    def pop(self):
        if self.isEmpty():
            return -1
        popped_node_data = self.head.data
        self.head = self.head.next
        self.stack_size -= 1
        return popped_node_data

    def top(self):
        if self.isEmpty():
            return -1
        return self.head.data

    def size(self):
        return self.stack_size

    def isEmpty(self):
        return self.stack_size == 0
```

---

### 4. Implement Queue using LinkedList
`[MEDIUM]` `[FUNDAMENTAL]` `#implementation` `#linked-list`

#### Problem Statement
Implement a Queue class using a singly linked list.

#### Implementation Overview
The FIFO (First-In, First-Out) property requires adding to one end (rear) and removing from the other (front). We maintain two pointers: `head` (for the front) and `tail` (for the rear).
- **Enqueue**: Create a new node. If the queue is empty, set both `head` and `tail` to this new node. Otherwise, set the current `tail.next` to the new node, and then update `tail` to point to the new node.
- **Dequeue**: The element to dequeue is at the `head`. To remove it, simply advance the `head` pointer to `head.next`. If the queue becomes empty after this operation, the `tail` pointer must also be set to `None`.
- All core operations are O(1).

#### Python Code Snippet
```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class Queue:
    def __init__(self):
        self.head = None
        self.tail = None
        self.queue_size = 0

    def enqueue(self, x):
        new_node = Node(x)
        if self.isEmpty():
            self.head = self.tail = new_node
        else:
            self.tail.next = new_node
            self.tail = new_node
        self.queue_size += 1

    def dequeue(self):
        if self.isEmpty():
            return -1
        popped_node_data = self.head.data
        self.head = self.head.next
        if self.head is None: # The queue is now empty
            self.tail = None
        self.queue_size -= 1
        return popped_node_data

    def front(self):
        if self.isEmpty():
            return -1
        return self.head.data

    def size(self):
        return self.queue_size

    def isEmpty(self):
        return self.queue_size == 0
```
