---

### 1. Introduction to Doubly LinkedList
`[FUNDAMENTAL]` `[EASY]` `#linked-list` `#doubly-linked-list` `#data-structure`

#### Problem Statement
Understand the structure of a Doubly Linked List (DLL). This includes the `Node` structure, which now contains data, a pointer to the *next* node, and a pointer to the *previous* node.

#### Implementation Overview
A Doubly Linked List is a variation of a linked list where each node has a pointer to both its next and previous nodes. This bidirectional linkage provides advantages for certain operations.

- **Node Structure**: A DLL `Node` contains three parts:
    1.  **Data**: The value stored in the node.
    2.  **Next Pointer**: A reference to the next node in the sequence.
    3.  **Previous Pointer**: A reference to the previous node in the sequence. The `prev` pointer of the first node is `null`.

- **Head and Tail**: A DLL is typically tracked with two pointers: `HEAD` (pointing to the first node) and sometimes `TAIL` (pointing to the last node) for more efficient appends.

This structure allows for traversal in both forward and backward directions.

#### Python Code Snippet
A Python implementation of a `Node` for a Doubly Linked List.

```python
class Node:
    """
    A class to represent a node in a doubly linked list.
    """
    def __init__(self, data):
        self.data = data      # The value stored in the node
        self.next = None      # Pointer to the next node
        self.prev = None      # Pointer to the previous node
```

#### Tricks/Gotchas
- **Pointer Management**: With two pointers per node (`next` and `prev`), operations like insertion and deletion require careful management of four links, not just two.
- **Null Pointers**: The `head.prev` and `tail.next` should always be `None`.

#### Related Problems
- All other problems in this section.
- Reverse a DLL

---

### 2. Insert a node in DLL
`[FUNDAMENTAL]` `[EASY]` `#doubly-linked-list` `#insertion`

#### Problem Statement
Given a doubly linked list, a value, and a position, insert a new node with the given value. This includes insertion at the head, at the tail, and before a given node.

#### Implementation Overview
1.  **Create New Node**: Allocate a new `Node` with the given data.
2.  **Insertion at Head**:
    - Set `new_node.next` to the current `head`.
    - If the list is not empty, set `head.prev` to `new_node`.
    - Update `head` to be `new_node`.
3.  **Insertion at Tail**:
    - Find the last node.
    - Set `last.next` to `new_node`.
    - Set `new_node.prev` to `last`.
4.  **Insertion Before a Given Node (`next_node`)**:
    - Set `new_node.next` to `next_node`.
    - Set `new_node.prev` to `next_node.prev`.
    - Update the `next` pointer of the node *before* `next_node` to point to `new_node`.
    - Update `next_node.prev` to point to `new_node`.

#### Python Code Snippet
```python
# Assuming Node class is defined as above

def insert_at_beginning(self, data):
    new_node = Node(data)
    if self.head is None:
        self.head = new_node
        return

    new_node.next = self.head
    self.head.prev = new_node
    self.head = new_node

def insert_at_end(self, data):
    new_node = Node(data)
    if self.head is None:
        self.head = new_node
        return

    last = self.head
    while last.next:
        last = last.next

    last.next = new_node
    new_node.prev = last
```

#### Tricks/Gotchas
- **Updating `prev` pointers**: A common mistake is to forget to update the `prev` pointer of the node that comes *after* the insertion point.
- **Empty List**: Insertion into an empty list is an important edge case where the `head` must be correctly initialized.

#### Related Problems
- Delete a node in DLL

---

### 3. Delete a node in DLL
`[FUNDAMENTAL]` `[EASY]` `#doubly-linked-list` `#deletion`

#### Problem Statement
Given a doubly linked list and a pointer to a node, delete that node.

#### Implementation Overview
The key is to "bypass" the node to be deleted by linking its previous and next nodes directly to each other.
1.  **Handle Head Deletion**: If the node to be deleted is the `head`, update `head` to `head.next`. If the new head exists, set its `prev` to `None`.
2.  **Handle Tail Deletion**: If the node is the tail, update the `next` pointer of its `prev` node to `None`.
3.  **General Case (Node in the middle)**:
    - Let the node to be deleted be `del_node`.
    - `del_node.prev.next = del_node.next` (Link previous node's `next` to the next node).
    - `del_node.next.prev = del_node.prev` (Link next node's `prev` to the previous node).

#### Python Code Snippet
```python
def delete_node(self, del_node):
    if self.head is None or del_node is None:
        return

    # If node to be deleted is head node
    if self.head == del_node:
        self.head = del_node.next

    # Change next only if node to be deleted is NOT the last node
    if del_node.next is not None:
        del_node.next.prev = del_node.prev

    # Change prev only if node to be deleted is NOT the first node
    if del_node.prev is not None:
        del_node.prev.next = del_node.next
```

#### Tricks/Gotchas
- **Edge Cases**: Deleting the head, tail, or the only node in the list are crucial edge cases to handle.
- **Null Checks**: Before accessing `node.next` or `node.prev`, ensure the `node` itself is not `None`.

#### Related Problems
- Insert a node in DLL

---

### 4. Reverse a DLL
`[MEDIUM]` `#doubly-linked-list` `#reversal` `#two-pointers`

#### Problem Statement
Given a doubly linked list, reverse it in-place.

#### Implementation Overview
Reversing a DLL is simpler than reversing a singly linked list. Since we have the `prev` pointer, we can iterate through the list and swap the `next` and `prev` pointers for each node.

1.  Initialize two pointers: `current = head` and `temp = None`.
2.  Traverse the list using the `current` pointer.
3.  In each iteration, store `current.prev` in the `temp` pointer. This is because we are about to overwrite `current.prev`.
4.  Swap the pointers: `current.prev = current.next` and `current.next = temp`.
5.  Move to the next node in the original list. The next node is now stored in `current.prev` (since we just swapped). So, `current = current.prev`.
6.  After the loop, the last node visited becomes the new `head`. The `temp` pointer (which holds the `prev` of the original head) will be the parent of the new head. So, update `head` to `temp.prev`.

#### Python Code Snippet
```python
def reverse(self):
    temp = None
    current = self.head

    # Swap next and prev for all nodes of doubly linked list
    while current is not None:
        temp = current.prev
        current.prev = current.next
        current.next = temp
        current = current.prev

    # Before changing head, check for cases like empty list and list with only one node
    if temp is not None:
        self.head = temp.prev
```

#### Tricks/Gotchas
- **New Head**: The last node of the original list becomes the new `head`. It's crucial to correctly update the `head` pointer at the end of the reversal.
- **Loop Termination**: The loop should stop when `current` becomes `None`. At this point, `temp` will be pointing to the original head node. The new head is `temp.prev`.

#### Related Problems
- Reverse a LinkedList [Iterative]

---

### 5. Delete all occurrences of a key in DLL
`[MEDIUM]` `#doubly-linked-list` `#deletion`

#### Problem Statement
Given a doubly linked list and a key, delete all nodes that have the given key.

#### Implementation Overview
We need to traverse the list and delete nodes that match the key. Care must be taken because deleting a node changes the links of its neighbors.

1.  Initialize a `current` pointer to the `head`.
2.  Traverse the list with the `current` pointer.
3.  If `current.data` matches the `key`:
    -   This node needs to be deleted.
    -   Store a reference to the next node: `next_node = current.next`.
    -   Call a helper function `delete_node(current)` or perform the deletion logic inline. This involves:
        -   If `current` is not the head, update `current.prev.next`.
        -   If `current` is not the tail, update `current.next.prev`.
        -   If `current` is the head, update the main `head` pointer.
    -   Move to the next node to check: `current = next_node`.
4.  If `current.data` does not match the key, simply move to the next node: `current = current.next`.

#### Python Code Snippet
```python
def delete_all_occurrences(self, key):
    current = self.head
    while current is not None:
        if current.data == key:
            next_node = current.next
            # Standard deletion logic for DLL
            if current.prev is not None:
                current.prev.next = current.next
            else: # It's the head
                self.head = current.next

            if current.next is not None:
                current.next.prev = current.prev

            # Move to the next node
            current = next_node
        else:
            current = current.next
    return self.head
```

#### Tricks/Gotchas
- **Multiple Deletions**: The loop must correctly handle consecutive nodes with the same key. After deleting a node, the `current` pointer must be advanced to the *next* valid node in the original list.
- **Head Deletion**: Deleting the head (or multiple nodes at the start) is a critical edge case. The main `head` pointer for the list must be updated correctly.

#### Related Problems
- Delete a node in DLL
