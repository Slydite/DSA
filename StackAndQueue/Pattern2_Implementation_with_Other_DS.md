# Pattern 2: Implementation with Other Data Structures

This pattern involves implementing a data structure using the properties of another. These problems are common interview questions to test the understanding of the fundamental operations (LIFO for stacks, FIFO for queues).

---

### 1. Implement Stack using Queue
`[MEDIUM]` `#implementation` `#queue`

#### Problem Statement
Implement a LIFO stack using only one or two queues. The implemented stack should support all the functions of a normal stack (`push`, `top`, `pop`, and `empty`).

#### Implementation Overview
The goal is to make the queue, a FIFO structure, behave in a LIFO manner. The key is to re-arrange the queue elements on every push so that the most recently added element is at the front.

**Method: Making `push` costly (O(n)) using a single queue**
1.  **Push `x`**:
    - Get the current size of the queue, say `s`.
    - Enqueue the new element `x`.
    - Dequeue the first `s` elements and enqueue them back to the rear of the queue. This moves the new element `x` to the front.
2.  **Pop**: Dequeue from the queue.
3.  **Top**: Peek at the front of the queue.

This approach effectively reverses the order of the existing elements after the new element is added, making the queue behave like a stack.

#### Python Code Snippet (Single Queue)
```python
from collections import deque

class MyStack:
    def __init__(self):
        self.q = deque()

    def push(self, x: int) -> None:
        # Add the new element
        self.q.append(x)
        # Rotate the queue to make the new element the front
        for _ in range(len(self.q) - 1):
            self.q.append(self.q.popleft())

    def pop(self) -> int:
        if not self.empty():
            return self.q.popleft()
        return -1 # Or raise exception

    def top(self) -> int:
        if not self.empty():
            return self.q[0]
        return -1

    def empty(self) -> bool:
        return not self.q
```

---

### 2. Implement Queue using Stack
`[MEDIUM]` `#implementation` `#stack`

#### Problem Statement
Implement a FIFO queue using only two stacks. The implemented queue should support all the functions of a normal queue (`push` (enqueue), `peek` (front), `pop` (dequeue), and `empty`).

#### Implementation Overview
This is a classic problem that uses an "amortized" approach with two stacks, often named `input` and `output`.
- The `input` stack is for `push` operations.
- The `output` stack is for `pop` and `peek` operations.

The core idea is to transfer elements from `input` to `output` only when the `output` stack is empty. This reverses their order, making the first element that went into the `input` stack become the top element of the `output` stack.

1.  **Push `x`**: Simply push `x` onto the `input` stack. This is an O(1) operation.
2.  **Pop/Peek**:
    - First, check if the `output` stack is empty.
    - If it is, pop every element from `input` and push it onto `output`. This O(n) transfer operation only happens occasionally.
    - If `output` is not empty (or after the transfer), `pop` or `peek` from the `output` stack. This is an O(1) operation.

#### Python Code Snippet (Amortized)
```python
class MyQueue:
    def __init__(self):
        self.input_stack = []
        self.output_stack = []

    def push(self, x: int) -> None:
        self.input_stack.append(x)

    # Helper function to transfer elements when needed
    def _transfer_if_needed(self):
        if not self.output_stack:
            while self.input_stack:
                self.output_stack.append(self.input_stack.pop())

    def pop(self) -> int:
        self._transfer_if_needed()
        if self.output_stack:
            return self.output_stack.pop()
        return -1 # Or raise exception

    def peek(self) -> int:
        self._transfer_if_needed()
        if self.output_stack:
            return self.output_stack[-1]
        return -1

    def empty(self) -> bool:
        return not self.input_stack and not self.output_stack
```

#### Tricks/Gotchas
- The efficiency of the queue-using-stacks implementation comes from the amortized analysis. A common mistake is to transfer elements back and forth on every operation, which would be highly inefficient. The key is to only move elements from `input` to `output` when `output` is exhausted.
