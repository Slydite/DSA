---

### 1. Middle of a LinkedList [Tortoise-Hare Method]
`[MEDIUM]` `[EASY]` `#two-pointers` `#slow-fast-pointers` `#linked-list`

#### Problem Statement
Given the `head` of a non-empty singly linked list, return the middle node of the linked list. If there are two middle nodes (in case of an even number of nodes), return the second middle node.

#### Implementation Overview
This is a classic application of the **slow and fast pointer** (or "tortoise and hare") technique.
1.  Initialize two pointers, `slow` and `fast`, both starting at the `head` of the list.
2.  Traverse the list with these pointers, but move `slow` by one step and `fast` by two steps in each iteration.
3.  The loop continues as long as `fast` and `fast.next` are not `None`.
4.  When the `fast` pointer reaches the end of the list, the `slow` pointer will be at the middle.
    -   If the list has an odd number of nodes, `fast` will end up on the last node.
    -   If the list has an even number of nodes, `fast` will become `None`.
    -   In both cases, `slow` points to the desired middle node (the second one in the even case).

#### Python Code Snippet
```python
def find_middle(head):
    """
    Finds the middle node of a linked list using the tortoise and hare method.
    """
    slow = head
    fast = head

    while fast is not None and fast.next is not None:
        slow = slow.next
        fast = fast.next.next

    return slow
```

#### Tricks/Gotchas
- **Loop Condition**: The condition `while fast and fast.next` is crucial. It correctly handles both even and odd length lists and prevents errors from trying to access `fast.next.next` when `fast.next` is `None`.
- **Empty/Single Node List**: The code works for a single-node list (returns the node itself) and should handle an empty list if the problem allowed it (returns `None`).

#### Related Problems
- Delete the middle node of LL
- Check if LL is palindrome or not

---

### 2. Detect a loop in LL
`[MEDIUM]` `#two-pointers` `#floyd-cycle-detection` `#linked-list`

#### Problem Statement
Given the `head` of a linked list, determine if the linked list has a cycle in it. A cycle exists if some node in the list can be reached again by continuously following the `next` pointer.

#### Implementation Overview
This is the canonical problem for **Floyd's Cycle-Finding Algorithm**, which also uses a slow and fast pointer.
1.  Initialize `slow` and `fast` pointers to the `head`.
2.  Move `slow` one step at a time and `fast` two steps at a time.
3.  If the list has no cycle, the `fast` pointer will reach the end (`None`) and the function can return `False`.
4.  If the list *does* have a cycle, the `fast` pointer will eventually lap the `slow` pointer. At some point, `slow` and `fast` will point to the same node.
5.  If a meeting occurs (`slow == fast`), you have detected a loop, and the function should return `True`.

#### Python Code Snippet
```python
def has_cycle(head):
    slow = head
    fast = head

    while fast is not None and fast.next is not None:
        slow = slow.next
        fast = fast.next.next

        if slow == fast:
            return True  # Cycle detected

    return False  # No cycle
```

#### Tricks/Gotchas
- **Initialization**: Both pointers must start at the same location. If `fast` starts one step ahead, the logic for finding the start of the loop changes.
- **Proof of Correctness**: The reason this works is that the relative speed between the pointers is 1. If there is a cycle, the fast pointer enters it first and the slow pointer follows. The distance between them decreases by one at each step within the cycle, guaranteeing they will eventually meet.

#### Related Problems
- Find the starting point in LL
- Length of Loop in LL

---

### 3. Find the starting point in LL
`[MEDIUM]` `#two-pointers` `#floyd-cycle-detection` `#linked-list`

#### Problem Statement
Given the `head` of a linked list that may contain a cycle, return the node where the cycle begins. If there is no cycle, return `null`.

#### Implementation Overview
This is an extension of Floyd's Cycle-Finding Algorithm.
1.  **Detect the Cycle**: First, use the slow/fast pointer approach described above to find a meeting point inside the cycle. If they don't meet, there is no cycle.
2.  **Find the Start Node**: If a meeting point (`meet`) is found, reset one of the pointers (e.g., `slow`) back to the `head` of the list. Keep the other pointer (`fast`) at the `meet` point.
3.  **Move in Unison**: Now, move both `slow` and `fast` one step at a time.
4.  The node where they meet again is the starting node of the cycle.

The mathematical proof for this is that the distance from the `head` to the cycle's start is equal to the distance from the `meet` point to the cycle's start.

#### Python Code Snippet
```python
def detect_cycle_start(head):
    slow = head
    fast = head

    # Find the meeting point
    while fast is not None and fast.next is not None:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            break  # Meeting point found
    else:
        return None # No cycle

    # Find the start of the cycle
    slow = head
    while slow != fast:
        slow = slow.next
        fast = fast.next

    return slow
```

#### Tricks/Gotchas
- **No Cycle Case**: Ensure you handle the case where no cycle exists (the first loop terminates naturally).
- **Two-Phase Process**: Don't confuse the two phases. The first finds a meeting point; the second finds the cycle's start.

#### Related Problems
- Detect a loop in LL

---

### 8. Find pairs with given sum in DLL
`[MEDIUM]` `#two-pointers` `#doubly-linked-list`

#### Problem Statement
Given a *sorted* doubly linked list of distinct elements, find all pairs of nodes whose sum is equal to a given value `x`.

#### Implementation Overview
This problem is a classic two-pointer pattern, adapted for a doubly linked list. Because the list is sorted and we can traverse backward, we can solve this efficiently.
1.  **Initialize Pointers**:
    -   Create a `left` pointer and initialize it to the `head` of the list.
    -   Create a `right` pointer and initialize it to the `tail` of the list. To find the tail, you must traverse the list once.
2.  **Traverse Inward**:
    -   Loop as long as the `left` pointer is not the same as the `right` pointer and `right.next` is not `left` (to prevent crossing).
    -   Calculate the `current_sum = left.data + right.data`.
    -   **Case 1: `current_sum == x`**: A pair is found. Record it. Move both pointers inward (`left = left.next`, `right = right.prev`).
    -   **Case 2: `current_sum < x`**: The sum is too small. We need a larger value, so move the `left` pointer forward (`left = left.next`).
    -   **Case 3: `current_sum > x`**: The sum is too large. We need a smaller value, so move the `right` pointer backward (`right = right.prev`).
3.  The loop terminates when the pointers meet or cross, meaning all possible pairs have been checked.

#### Python Code Snippet
```python
def find_pairs_with_sum(head, x):
    if not head or not head.next:
        return []

    # Find the tail of the list
    tail = head
    while tail.next:
        tail = tail.next

    left = head
    right = tail
    pairs = []

    while left != right and right.next != left:
        current_sum = left.data + right.data

        if current_sum == x:
            pairs.append((left.data, right.data))
            left = left.next
            right = right.prev
        elif current_sum < x:
            left = left.next
        else:
            right = right.prev

    return pairs
```

#### Tricks/Gotchas
- **Finding the Tail**: An initial O(N) traversal is required to find the tail pointer before the two-pointer traversal can begin.
- **Pointer Crossing Condition**: The loop must terminate correctly. `left != right` handles the odd-length case, and `right.next != left` handles the even-length case, preventing pointers from overlapping and re-checking pairs.
- **Sorted List**: This approach fundamentally relies on the list being sorted.

#### Related Problems
- Two Sum (in an array)

---

### 4. Length of Loop in LL
`[MEDIUM]` `#two-pointers` `#floyd-cycle-detection` `#linked-list`

#### Problem Statement
Given a linked list with a cycle, find the length of the cycle.

#### Implementation Overview
1.  **Find Meeting Point**: First, use the standard slow/fast pointer approach to find any node within the cycle. Let's call this `meet_node`. If there's no cycle, the length is 0.
2.  **Count Nodes in Cycle**: Once you have a node inside the cycle (`meet_node`), keep a pointer (`temp`) at this node.
3.  Start traversing from the *next* node (`meet_node.next`) with another pointer and count the steps until you get back to `meet_node`.
4.  The final count is the length of the loop.

#### Python Code Snippet
```python
def length_of_cycle(head):
    # Find meeting point first
    slow = head
    fast = head
    while fast is not None and fast.next is not None:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            break
    else:
        return 0 # No cycle

    # Count the length of the loop
    count = 1
    temp = slow.next
    while temp != slow:
        count += 1
        temp = temp.next

    return count
```

#### Tricks/Gotchas
- **Starting the Count**: After finding a meeting point, initialize the count to 1 and start the counting traversal from the *next* node.

#### Related Problems
- Detect a loop in LL

---

### 5. Remove Nth node from the back of the LL
`[MEDIUM]` `#two-pointers` `#linked-list`

#### Problem Statement
Given the `head` of a linked list, remove the `n`-th node from the end of the list and return its head.

#### Implementation Overview
The most efficient way to do this in a single pass is with two pointers.
1.  Initialize two pointers, `fast` and `slow`, both at the `head`.
2.  Move the `fast` pointer `n` steps ahead.
3.  Now, `fast` is `n` nodes ahead of `slow`.
4.  Move both `fast` and `slow` one step at a time until `fast` reaches the *last node* (`fast.next` is `None`). At this point, `slow` will be pointing to the node *just before* the one we want to delete.
5.  To delete the target node, set `slow.next = slow.next.next`.
6.  **Edge Case**: If you need to remove the head (i.e., `n` is the length of the list), the `fast` pointer will become `None` after the initial `n` steps. You should detect this and simply return `head.next`. A dummy node can simplify this.

#### Python Code Snippet
```python
def remove_nth_from_end(head, n):
    # Use a dummy node to handle edge case of removing the head
    dummy = Node(0)
    dummy.next = head
    fast = dummy
    slow = dummy

    # Move fast pointer n steps ahead
    for _ in range(n + 1):
        fast = fast.next

    # Move both until fast reaches the end
    while fast is not None:
        slow = slow.next
        fast = fast.next

    # Delete the Nth node
    slow.next = slow.next.next

    return dummy.next
```

#### Tricks/Gotchas
- **Dummy Node**: Using a dummy node that points to the head simplifies the logic significantly, especially for the edge case where the head itself needs to be removed. The `n+1` initial steps for `fast` ensures `slow` lands just before the target.
- **Off-by-one**: Be careful with pointer positioning. The goal is to have `slow` point to the node *before* the target.

#### Related Problems
- Middle of a LinkedList

---

### 6. Delete the middle node of LL
`[MEDIUM]` `#two-pointers` `#linked-list`

#### Problem Statement
Given the `head` of a singly linked list, delete the middle node and return the `head` of the modified list. The middle node is determined similarly to the "Middle of a LinkedList" problem.

#### Implementation Overview
This problem combines finding the middle node with deletion.
1.  **Handle Edge Cases**: If the list is empty or has only one node, deleting the middle results in an empty list, so return `None`.
2.  **Find Node Before Middle**: Use the slow and fast pointer technique. However, you need to stop the `slow` pointer at the node *just before* the middle node.
3.  To do this, you can modify the standard middle-finding loop or simply keep a `prev` pointer that trails the `slow` pointer.
4.  A common pattern is to move `fast` by `2` and `slow` by `1`. When `fast` reaches the end, `slow` is at the middle. To get the node *before* the middle, you need another pointer.
5.  Once you have the node `prev_to_slow`, you can delete the middle node by setting `prev_to_slow.next = prev_to_slow.next.next`.

#### Python Code Snippet
```python
def delete_middle_node(head):
    if head is None or head.next is None:
        return None

    slow = head
    fast = head
    prev = None # Pointer to the node before slow

    while fast is not None and fast.next is not None:
        prev = slow
        slow = slow.next
        fast = fast.next.next

    # slow is now the middle node, prev is the node before it
    if prev:
        prev.next = slow.next

    return head
```

#### Tricks/Gotchas
- **Finding the Predecessor**: The key is not just to find the middle node, but its predecessor, which is needed for deletion. Keeping a `prev` pointer is a straightforward way to do this.

#### Related Problems
- Middle of a LinkedList

---

### 7. Find the intersection point of Y LL
`[MEDIUM]` `#two-pointers` `#linked-list`

#### Problem Statement
Given the heads of two singly linked-lists `headA` and `headB`, return the node at which the two lists intersect. If the two linked lists have no intersection at all, return `null`. The lists are guaranteed to have no cycles.

#### Implementation Overview
There are a few methods, but a clever two-pointer approach is very efficient.
1.  Initialize two pointers, `ptrA = headA` and `ptrB = headB`.
2.  Traverse both lists. In each step, advance `ptrA` and `ptrB`.
3.  If `ptrA` reaches the end of list A, redirect it to `headB`.
4.  If `ptrB` reaches the end of list B, redirect it to `headA`.
5.  If the lists intersect, the pointers will eventually meet at the intersection node. If they don't intersect, they will both become `None` at the same time after traversing both lists.

This works because by switching heads, both pointers travel the same total distance (`lenA + lenB`) to reach the end of the combined path. Any difference in path length before the intersection is canceled out.

#### Python Code Snippet
```python
def get_intersection_node(headA, headB):
    if not headA or not headB:
        return None

    ptrA = headA
    ptrB = headB

    while ptrA != ptrB:
        # If you reach the end of one list, redirect to the head of the other
        ptrA = headB if ptrA is None else ptrA.next
        ptrB = headA if ptrB is None else ptrB.next

    return ptrA # This will be the intersection node or None
```

#### Tricks/Gotchas
- **Termination**: The loop condition `while ptrA != ptrB` elegantly handles both cases (intersection and no intersection). If there's no intersection, both pointers become `None` after traversing `lenA + lenB` nodes, `None == None` is true, and the loop terminates, correctly returning `None`.
- **Alternative Method**: A less efficient but valid method is to find the lengths of both lists, calculate the difference `d`, move the pointer of the longer list `d` steps forward, and then traverse both lists in unison until they meet.

#### Related Problems
- Detect a loop in LL
