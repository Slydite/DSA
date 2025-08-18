---

### 1. Introduction to LinkedList
`[FUNDAMENTAL]` `[EASY]` `#linked-list` `#data-structure`

#### Problem Statement
Understand the basic structure of a Singly Linked List. This includes the concept of a `Node`, which contains data and a pointer to the next node, and how these nodes link together to form a list.

#### Implementation Overview
A linked list is a linear data structure where elements are not stored at contiguous memory locations. They are linked using pointers.

- **Node Structure**: The fundamental unit of a linked list is a `Node`. Each node consists of two parts:
    1.  **Data**: The value stored in the node (e.g., an integer, string, or any object).
    2.  **Next Pointer**: A reference or pointer to the next node in the sequence. For the last node in the list, this pointer is `null` (or `None` in Python).

- **Head Pointer**: The entry point to the linked list is a special pointer called the `HEAD`. It points to the very first node of the list. If the list is empty, the `HEAD` is `null`.

This structure allows for dynamic memory allocation and efficient insertion and deletion operations compared to arrays, as there is no need to shift elements.

#### Python Code Snippet
Here is a simple Python implementation of a `Node` class and a `LinkedList` class.

```python
class Node:
    """
    A class to represent a node in a singly linked list.
    """
    def __init__(self, data):
        self.data = data  # The value stored in the node
        self.next = None  # Pointer to the next node, initialized to None

class LinkedList:
    """
    A class to represent a singly linked list.
    """
    def __init__(self):
        self.head = None  # The head pointer, initialized to None for an empty list
```

#### Tricks/Gotchas
- **Null Pointer**: Always handle the case where a node or the head is `null`/`None` to avoid runtime errors (Null Pointer Exception).
- **Losing the Head**: Be careful not to lose the reference to the `head` pointer during operations, as it's the only entry point to the list.

#### Related Problems
- All other problems in this section build upon this foundational concept.

---

### 2. Inserting a Node in LinkedList
`[FUNDAMENTAL]` `[EASY]` `#linked-list` `#insertion` `#inplace`

#### Problem Statement
Given a singly linked list, a value, and sometimes a position, insert a new node with the given value into the list. Common variations include:
1.  Insertion at the beginning (head).
2.  Insertion at the end (tail).
3.  Insertion at a specific position `k`.

#### Implementation Overview
1.  **Create a New Node**: First, create a new `Node` instance with the given value.
2.  **Insertion at Head**:
    - Set the `next` pointer of the new node to point to the current `head` of the list.
    - Update the `head` of the list to be the new node.
3.  **Insertion at Tail**:
    - If the list is empty, make the new node the `head`.
    - Otherwise, traverse the list until you reach the last node (the one whose `next` is `None`).
    - Set the `next` pointer of this last node to point to the new node.
4.  **Insertion at Position `k`**:
    - Handle the edge case of `k=1` (insertion at head) separately.
    - Traverse the list to find the node at position `k-1`.
    - Set the `next` pointer of the new node to point to the node currently at position `k` (which is `(k-1)th_node.next`).
    - Update the `next` pointer of the `(k-1)th` node to point to the new node.

#### Python Code Snippet
```python
# Assuming Node and LinkedList classes are defined as above

def insert_at_beginning(self, data):
    new_node = Node(data)
    new_node.next = self.head
    self.head = new_node

def insert_at_end(self, data):
    new_node = Node(data)
    if not self.head:
        self.head = new_node
        return
    last = self.head
    while last.next:
        last = last.next
    last.next = new_node

def insert_at_position(self, data, position):
    if position < 1:
        print("Position must be >= 1.")
        return
    if position == 1:
        self.insert_at_beginning(data)
        return

    new_node = Node(data)
    temp = self.head
    for _ in range(position - 2):
        if temp is None:
            print("Position out of bounds.")
            return
        temp = temp.next

    if temp is None:
        print("Position out of bounds.")
        return

    new_node.next = temp.next
    temp.next = new_node
```

#### Tricks/Gotchas
- **Edge Cases**: Always consider inserting into an empty list, at the head, and at the tail.
- **Position `k`**: For insertion at position `k`, ensure your loop terminates at the `(k-1)th` node correctly. Off-by-one errors are common. Check for invalid or out-of-bounds positions.

#### Related Problems
- Deleting a node in LinkedList

---

### 3. Deleting a Node in LinkedList
`[FUNDAMENTAL]` `[EASY]` `#linked-list` `#deletion` `#inplace`

#### Problem Statement
Given a singly linked list and a key (either a value or a position), delete the first occurrence of the node with that key. Variations include:
1.  Deletion of the head node.
2.  Deletion of the tail node.
3.  Deletion of a node at a given position.

#### Implementation Overview
1.  **Deletion of Head**:
    - If the list is not empty, simply update the `head` to point to `head.next`.
2.  **Deletion of Tail**:
    - Traverse the list with two pointers, `current` and `previous`.
    - When `current` reaches the last node, `previous` will be at the second-to-last node.
    - Set `previous.next` to `None`.
3.  **Deletion by Position/Value**:
    - Handle the head deletion case separately.
    - Use two pointers, `previous` and `current`, to traverse the list. `previous` trails `current`.
    - When `current` is the node to be deleted, "bypass" it by setting `previous.next = current.next`.

#### Python Code Snippet
```python
# Assuming Node and LinkedList classes are defined

def delete_node_by_value(self, key):
    temp = self.head
    # If head node itself holds the key
    if temp is not None and temp.data == key:
        self.head = temp.next
        temp = None  # Free memory
        return

    # Search for the key to be deleted
    prev = None
    while temp is not None and temp.data != key:
        prev = temp
        temp = temp.next

    # If key was not present in linked list
    if temp is None:
        return

    # Unlink the node from linked list
    prev.next = temp.next
    temp = None
```

#### Tricks/Gotchas
- **Deleting the only node**: If the list has one node and it's deleted, the `head` must become `None`.
- **Keeping a `previous` pointer**: For deletion, you almost always need a reference to the node *before* the one you want to delete.

#### Related Problems
- Inserting a node in LinkedList
- Remove Nth node from the back of the LL

---

### 4. Find the length of the linkedlist
`[FUNDAMENTAL]` `[EASY]` `#linked-list` `#traversal`

#### Problem Statement
Given the `head` of a singly linked list, find and return its length (the number of nodes).

#### Implementation Overview
This is a classic traversal problem.
1.  Initialize a counter variable `length` to 0.
2.  Initialize a temporary pointer `current` to the `head` of the list.
3.  Traverse the list from the `head` to the end. For each node visited, increment the `length` counter.
4.  The loop continues as long as `current` is not `None`.
5.  When the loop terminates (i.e., you've reached the end), return the final `length`.

#### Python Code Snippet
```python
def get_length(self):
    """
    Returns the number of nodes in the linked list.
    """
    length = 0
    current = self.head
    while current:
        length += 1
        current = current.next
    return length
```

#### Tricks/Gotchas
- **Empty List**: The code should gracefully handle an empty list (`head` is `None`), in which case it correctly returns 0.

#### Related Problems
- Search an element in the LL
- Middle of a LinkedList

---

### 5. Search an element in the LL
`[FUNDAMENTAL]` `[EASY]` `#linked-list` `#traversal` `#search`

#### Problem Statement
Given the `head` of a singly linked list and a target value, determine if a node with that value exists in the list. Return `True` if it exists, otherwise `False`.

#### Implementation Overview
This is another standard traversal problem.
1.  Initialize a temporary pointer `current` to the `head` of the list.
2.  Traverse the list starting from the `head`.
3.  At each node, compare the node's `data` with the target value.
4.  If a match is found, return `True` immediately.
5.  If the entire list is traversed and no match is found (i.e., `current` becomes `None`), return `False`.

#### Python Code Snippet
```python
def search(self, target):
    """
    Searches for a node with the given target value.
    Returns True if found, False otherwise.
    """
    current = self.head
    while current:
        if current.data == target:
            return True
        current = current.next
    return False
```

#### Tricks/Gotchas
- **Empty List**: The logic naturally handles an empty list; the `while` loop condition will be false from the start, and the function will correctly return `False`.

#### Related Problems
- Find the length of the linkedlist
