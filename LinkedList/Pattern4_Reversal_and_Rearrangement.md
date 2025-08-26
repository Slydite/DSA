### `[PATTERN] Reversal and Rearrangement`

This pattern focuses on techniques to alter the structure of a linked list, primarily through reversal and reordering of its nodes. Mastering list reversal is fundamental, as it's a subroutine in many more complex problems. These problems often require a combination of pointer manipulations, including the two-pointer technique, to achieve the desired new structure.

---

### 1. Reverse a LinkedList (Iterative and Recursive)
`[EASY]` `#reversal` `#linked-list`

#### Problem Statement
Given the `head` of a singly linked list, reverse the list, and return the new head.

---

#### a) Iterative Approach

The iterative approach is generally preferred due to its O(1) space complexity. It involves using three pointers to traverse the list and reverse the links between nodes.

##### Implementation Overview
1.  Initialize three pointers: `prev = None`, `current = head`, and `next_node = None`.
2.  Iterate through the list as long as `current` is not `None`.
3.  In each iteration:
    a.  Store the next node: `next_node = current.next`.
    b.  Reverse the link: `current.next = prev`.
    c.  Move the pointers one step forward: `prev = current`, `current = next_node`.
4.  When the loop ends, `prev` will be pointing to the new head of the reversed list.

##### Python Code Snippet
```python
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

def reverse_list_iterative(head: ListNode) -> ListNode:
    """
    Reverses a singly linked list iteratively.
    """
    prev = None
    current = head
    while current:
        next_node = current.next  # Store next node
        current.next = prev       # Reverse the link
        prev = current            # Move prev to current
        current = next_node       # Move to the original next node
    return prev # prev is the new head
```

---

#### b) Recursive Approach

The recursive approach provides a more concise but less space-efficient (O(N) stack space) solution.

##### Implementation Overview
1.  **Base Case**: If the list is empty (`head is None`) or has only one node (`head.next is None`), it's already reversed, so return `head`.
2.  **Recursive Step**:
    a.  Recursively call the function on the rest of the list (`head.next`). This will reverse the sub-list and return its new head (`new_head`).
    b.  The `head` node is still pointing to the *last node* of the original sub-list (which is now the second node of the reversed sub-list). Let this be `head.next`.
    c.  To connect `head` to the end of the reversed sub-list, set `head.next.next = head`.
    d.  Break the original forward link: `head.next = None`.
3.  Return `new_head`.

##### Python Code Snippet
```python
def reverse_list_recursive(head: ListNode) -> ListNode:
    """
    Reverses a singly linked list recursively.
    """
    # Base case: empty list or a single node
    if not head or not head.next:
        return head

    # Recursively reverse the rest of the list
    new_head = reverse_list_recursive(head.next)

    # head.next is the last node of the original list, which should point back to head
    head.next.next = head
    head.next = None # Break the original link

    return new_head
```

---

### 2. Reverse Nodes in k-Group
`[HARD]` `#reversal` `#recursion` `#linked-list`

#### Problem Statement
Given the `head` of a linked list, reverse the nodes of the list `k` at a time, and return the modified list. `k` is a positive integer and is less than or equal to the length of the linked list. If the number of nodes is not a multiple of `k`, then the left-out nodes, in the end, should remain as they are.

#### Implementation Overview (Recursive)
This is a classic recursion problem. The main idea is to reverse the first `k` nodes and then recursively call the function on the rest of the list.

1.  **Base Case**: If there are fewer than `k` nodes left, do nothing and return the `head`.
2.  **Check for `k` nodes**: First, traverse `k` nodes to ensure there are enough nodes to reverse. If not, return `head`.
3.  **Reverse the `k`-group**:
    a. Use the iterative reversal method to reverse the first `k` nodes of the current segment. The `head` of this segment will become the tail, and the `k`-th node will become the new head (`new_head`).
    b. The original `head` of this segment (which is now the tail of the reversed group) needs to point to the result of the recursive call on the rest of the list.
4.  **Recursive Link**: The `head` of the original list (which is now the tail of the first reversed group) should have its `next` pointer set to the head of the *next* reversed group, which is obtained by `reverse_k_group(next_segment_head, k)`.

#### Python Code Snippet
```python
def reverse_k_group(head: ListNode, k: int) -> ListNode:
    """
    Reverses nodes of a linked list k at a time.
    """
    # 1. Check if there are at least k nodes left
    curr = head
    for _ in range(k):
        if not curr:
            return head # Not enough nodes, return as is
        curr = curr.next

    # 2. Reverse the first k nodes
    prev = None
    curr = head
    for _ in range(k):
        next_node = curr.next
        curr.next = prev
        prev = curr
        curr = next_node

    # 3. Recursively call for the rest of the list
    # head is now the tail of the reversed group.
    # curr is the head of the next segment.
    # prev is the new head of the current reversed group.
    if curr:
        head.next = reverse_k_group(curr, k)

    return prev # prev is the new head of this segment
```

---

### 3. Rotate List
`[MEDIUM]` `#rearrangement` `#two-pointers` `#linked-list`

#### Problem Statement
Given the `head` of a linked list, rotate the list to the right by `k` places.

#### Implementation Overview
A right rotation by `k` means the last `k` nodes become the first `k` nodes.
1.  **Handle Edge Cases**: If the list is empty, has one node, or `k=0`, return `head`.
2.  **Find Length and Connect to Tail**: Traverse the list to find its length (`L`) and the last node. Connect the last node's `next` to the `head`, forming a cycle.
3.  **Handle Large `k`**: The number of effective rotations is `k % L`.
4.  **Find the New Tail**: The new tail of the list will be at position `L - (k % L) - 1` from the original head. The node *after* this new tail will be the new head.
5.  **Break the Cycle**: Traverse `L - (k % L) - 1` steps from the head to find the new tail. The next node is the `new_head`. Set `new_tail.next = None` to break the cycle.
6.  Return `new_head`.

#### Python Code Snippet
```python
def rotate_right(head: ListNode, k: int) -> ListNode:
    if not head or not head.next or k == 0:
        return head

    # 1. Find length and last node
    last_node = head
    length = 1
    while last_node.next:
        last_node = last_node.next
        length += 1

    # 2. Connect to form a cycle
    last_node.next = head

    # 3. Reduce k
    k = k % length

    # 4. Find the new tail (node before the new head)
    # The new head is at index length - k
    steps_to_new_tail = length - k - 1
    new_tail = head
    for _ in range(steps_to_new_tail):
        new_tail = new_tail.next

    # 5. Find new head and break the cycle
    new_head = new_tail.next
    new_tail.next = None

    return new_head
```

---

### 4. Reorder List
`[MEDIUM]` `#rearrangement` `#two-pointers` `#reversal` `#linked-list`

#### Problem Statement
Given the `head` of a singly linked list, reorder it in-place such that the new order is `L0 → Ln → L1 → Ln-1 → L2 → Ln-2 → …`.

#### Implementation Overview
This is a multi-step problem that combines several patterns.
1.  **Find the Middle**: Use the slow/fast pointer method to find the middle of the list. This will split the list into two halves.
2.  **Reverse the Second Half**: Reverse the second half of the list starting from `slow.next`. After reversal, set `slow.next = None` to break the link between the two halves.
3.  **Merge the Two Halves**: Merge the first half (`head`) and the reversed second half (`reversed_head`) by interleaving their nodes. Use two pointers, one for each half, and carefully rewire their `next` pointers.

#### Python Code Snippet
```python
def reorder_list(head: ListNode) -> None:
    """
    Reorders the list in-place.
    """
    if not head or not head.next:
        return

    # 1. Find the middle of the list
    slow, fast = head, head
    while fast.next and fast.next.next:
        slow = slow.next
        fast = fast.next.next

    # 2. Reverse the second half
    # slow.next is the head of the second half
    prev, curr = None, slow.next
    while curr:
        next_node = curr.next
        curr.next = prev
        prev = curr
        curr = next_node
    slow.next = None # Split the list into two

    # 3. Merge the two halves
    # head1 is the first half, head2 is the reversed second half (prev)
    head1, head2 = head, prev
    while head2:
        # Store next nodes
        next1 = head1.next
        next2 = head2.next

        # Interleave
        head1.next = head2
        head2.next = next1

        # Move pointers
        head1 = next1
        head2 = next2
```

---

### 5. Palindrome Linked List
`[EASY]` `#reversal` `#two-pointers` `#linked-list`

#### Problem Statement
Given the `head` of a singly linked list, return `true` if it is a palindrome.

#### Implementation Overview
An efficient O(1) space solution follows a similar pattern to "Reorder List".
1.  **Find the Middle**: Use the slow/fast pointer method to find the middle.
2.  **Reverse the Second Half**: Reverse the list from the middle node onwards.
3.  **Compare Halves**: Compare the first half with the reversed second half. Initialize one pointer at the `head` and another at the head of the reversed second half. Traverse both. If any data values don't match, it's not a palindrome.
4.  **(Optional) Restore List**: If required, reverse the second half again to restore the original list structure.

#### Python Code Snippet
```python
def is_palindrome(head: ListNode) -> bool:
    if not head or not head.next:
        return True

    # 1. Find the middle
    slow, fast = head, head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next

    # 2. Reverse the second half (from slow pointer)
    prev = None
    curr = slow
    while curr:
        next_node = curr.next
        curr.next = prev
        prev = curr
        curr = next_node

    # 3. Compare the first half and the reversed second half
    left, right = head, prev # prev is the head of reversed second half
    while right: # Only need to check up to the end of the shorter (reversed) half
        if left.val != right.val:
            return False
        left = left.next
        right = right.next

    return True
```
