---

### 1. Reverse a LinkedList [Iterative]
`[MEDIUM]` `[FUNDAMENTAL]` `#reversal` `#linked-list` `#iterative`

#### Problem Statement
Given the `head` of a singly linked list, reverse the list and return the new `head`.

#### Implementation Overview
The iterative approach uses three pointers to reverse the list in-place.
1.  Initialize three pointers:
    -   `prev = None` (this will eventually be the new tail)
    -   `current = head` (the node we are currently visiting)
    -   `next_node = None` (to store the next node before we overwrite the pointer)
2.  Traverse the list while `current` is not `None`.
3.  In each iteration:
    -   Store the next node: `next_node = current.next`.
    -   Reverse the pointer of the current node: `current.next = prev`.
    -   Move the pointers one step forward: `prev = current` and `current = next_node`.
4.  When the loop finishes, `prev` will be pointing to the new `head` of the reversed list. Return `prev`.

#### Python Code Snippet
```python
def reverse_list_iterative(head):
    """
    Reverses a linked list iteratively.
    """
    prev = None
    current = head
    while current is not None:
        next_node = current.next  # Store the next node
        current.next = prev       # Reverse the current node's pointer
        prev = current            # Move prev one step forward
        current = next_node       # Move current one step forward
    return prev # prev is the new head
```

#### Tricks/Gotchas
- **Pointer Order**: The order of operations is crucial. You must store `current.next` before you reassign it.
- **New Head**: The final `head` of the reversed list is the `prev` pointer. The original `head` becomes the tail.

#### Related Problems
- Reverse a LL [Recursive]
- Reverse a DLL

---

### 2. Reverse a LL [Recursive]
`[MEDIUM]` `#reversal` `#linked-list` `#recursive`

#### Problem Statement
Given the `head` of a singly linked list, reverse the list using recursion and return the new `head`.

#### Implementation Overview
The recursive approach breaks the problem down.
1.  **Base Case**: If the list is empty (`head is None`) or has only one node (`head.next is None`), it is already reversed. Return `head`.
2.  **Recursive Step**:
    -   Recursively call the reverse function on the rest of the list: `new_head = reverse_list_recursive(head.next)`.
    -   This call will reverse the sublist starting from `head.next` and return its new head (`new_head`).
    -   Now, the `head` node is still pointing to the (now) last node of the reversed sublist. We need to attach `head` to the end.
    -   The node `head.next` is the tail of the original sublist, which is now the head of the reversed sublist. Its `next` pointer is `None`. We need to make it point back to `head`.
    -   So, `head.next.next = head`.
    -   Finally, sever the original forward link: `head.next = None`.
3.  **Return Value**: The `new_head` returned by the first recursive call is the head of the fully reversed list. Propagate this value up the call stack.

#### Python Code Snippet
```python
def reverse_list_recursive(head):
    """
    Reverses a linked list using recursion.
    """
    # Base case: if list is empty or has only one node
    if head is None or head.next is None:
        return head

    # Reverse the rest of the list
    new_head = reverse_list_recursive(head.next)

    # Put the first element at the end
    head.next.next = head
    head.next = None

    return new_head
```

#### Tricks/Gotchas
- **Visualizing Recursion**: This can be hard to visualize. Think of the recursion unwinding. The links are reversed one by one as the call stack pops.
- **Returning the New Head**: The base case returns the last node of the original list, which becomes the `new_head`. This value must be passed all the way back up.

#### Related Problems
- Reverse a LinkedList [Iterative]

---

### 3. Check if LL is palindrome or not
`[MEDIUM]` `#two-pointers` `#reversal` `#linked-list`

#### Problem Statement
Given the `head` of a singly linked list, return `true` if it is a palindrome, `false` otherwise.

#### Implementation Overview
A common and efficient approach involves reversing the second half of the list.
1.  **Find the Middle**: Use the slow/fast pointer method to find the middle of the linked list.
2.  **Reverse Second Half**: Reverse the linked list from the node *after* the middle (`slow.next`).
3.  **Compare Halves**:
    -   Initialize one pointer at the `head` and another at the `head` of the reversed second half.
    -   Iterate through both halves, comparing the data of the nodes.
    -   If at any point the data does not match, the list is not a palindrome.
4.  **Restore List (Optional)**: If the list needs to be returned to its original state, reverse the second half again to restore the links.

#### Python Code Snippet
```python
def is_palindrome(head):
    if not head or not head.next:
        return True

    # 1. Find the middle
    slow, fast = head, head
    while fast.next and fast.next.next:
        slow = slow.next
        fast = fast.next.next

    # 2. Reverse the second half
    second_half_head = reverse_list_iterative(slow.next)
    slow.next = None # Split the list

    # 3. Compare the two halves
    first_half_head = head
    p1, p2 = first_half_head, second_half_head
    is_pal = True
    while p1 and p2:
        if p1.data != p2.data:
            is_pal = False
            break
        p1 = p1.next
        p2 = p2.next

    # 4. (Optional) Restore the list
    slow.next = reverse_list_iterative(second_half_head)

    return is_pal
```

#### Tricks/Gotchas
- **Odd vs. Even Length**: The middle-finding logic must correctly handle both cases. The standard slow/fast approach naturally does this. `slow` will be the end of the first half.
- **Splitting the List**: After finding the middle (`slow`), you must sever the link (`slow.next = None`) before comparing to ensure the first half terminates correctly.

#### Related Problems
- Middle of a LinkedList
- Reverse a LinkedList [Iterative]

---

### 4. Segregate odd and even nodes in LL
`[MEDIUM]` `#rearrangement` `#linked-list` `#inplace`

#### Problem Statement
Given the `head` of a singly linked list, group all the nodes with odd indices together followed by the nodes with even indices, and return the reordered list. The relative order within the odd and even groups should remain the same. This should be done in-place.

#### Implementation Overview
The goal is to create two separate lists—one for odd-indexed nodes and one for even-indexed nodes—and then link them.
1.  **Handle Edge Cases**: If the list has 0, 1, or 2 nodes, it's already segregated.
2.  **Initialize Pointers**:
    -   `odd = head` (points to the tail of the odd-indexed list)
    -   `even = head.next` (points to the tail of the even-indexed list)
    -   `even_head = head.next` (a fixed pointer to the head of the even list)
3.  **Traverse and Relink**:
    -   Iterate as long as `even` and `even.next` are valid.
    -   Link the next odd node: `odd.next = even.next`. Move `odd` forward: `odd = odd.next`.
    -   Link the next even node: `even.next = odd.next`. Move `even` forward: `even = even.next`.
4.  **Connect the Lists**: After the loop, the `odd` pointer is at the tail of the odd list. Connect it to the head of the even list: `odd.next = even_head`.
5.  Return the original `head`.

#### Python Code Snippet
```python
def odd_even_list(head):
    if not head or not head.next:
        return head

    odd = head
    even = head.next
    even_head = head.next

    while even and even.next:
        odd.next = even.next
        odd = odd.next

        even.next = odd.next
        even = even.next

    # Connect the odd list to the even list
    odd.next = even_head

    return head
```

#### Tricks/Gotchas
- **Pointer Management**: This problem is all about careful pointer manipulation. Drawing the nodes and tracing the pointer changes is highly recommended.
- **Saving `even_head`**: You must save the head of the even list at the beginning because you'll need to link to it at the end.

#### Related Problems
- Sort a LL of 0's 1's and 2's by changing links

---

### 5. Sort a LL of 0's 1's and 2's by changing links
`[MEDIUM]` `#rearrangement` `#linked-list` `#inplace`

#### Problem Statement
Given a linked list of `0`s, `1`s, and `2`s, sort it by modifying the links, not by swapping data.

#### Implementation Overview
This is similar to the Dutch National Flag problem for arrays, but applied to linked lists. The idea is to create three separate lists for `0`s, `1`s, and `2`s, and then concatenate them.
1.  **Create Dummy Heads**: Create three dummy nodes (`zero_head`, `one_head`, `two_head`) to serve as the starting points for the three new lists. This simplifies handling empty sublists.
2.  **Create Tail Pointers**: Create three tail pointers (`zero_tail`, `one_tail`, `two_tail`) initialized to the dummy heads.
3.  **Iterate and Segregate**: Traverse the original list. For each node:
    -   If its value is `0`, append it to the `zero_tail`.
    -   If its value is `1`, append it to the `one_tail`.
    -   If its value is `2`, append it to the `two_tail`.
    -   Move the corresponding tail pointer forward.
4.  **Concatenate the Lists**:
    -   Connect the `zero` list to the `one` list.
    -   Connect the `one` list to the `two` list.
    -   Be careful to handle cases where one or more of the sublists might be empty.
5.  **Terminate the Final List**: Set the `next` of the final tail (`two_tail`) to `None`.
6.  Return the head of the combined list, which is `zero_head.next`.

#### Python Code Snippet
```python
def sort_list_of_012(head):
    if not head or not head.next:
        return head

    zero_head = Node(0)
    one_head = Node(0)
    two_head = Node(0)

    zero_tail, one_tail, two_tail = zero_head, one_head, two_head
    curr = head

    while curr:
        if curr.data == 0:
            zero_tail.next = curr
            zero_tail = zero_tail.next
        elif curr.data == 1:
            one_tail.next = curr
            one_tail = one_tail.next
        else:
            two_tail.next = curr
            two_tail = two_tail.next
        curr = curr.next

    # Concatenate lists
    one_tail.next = two_head.next
    zero_tail.next = one_head.next if one_head.next else two_head.next
    two_tail.next = None

    return zero_head.next
```

#### Tricks/Gotchas
- **Dummy Nodes**: Dummy heads are essential for this approach to avoid complex conditional logic for the first node of each sublist.
- **Concatenation Logic**: The concatenation logic must correctly handle empty sublists. For example, if there are no `1`s, the `zero` list must be connected directly to the `two` list.
- **Termination**: Remember to set the `next` of the final tail to `None` to avoid cycles.

#### Related Problems
- Segregate odd and even nodes in LL

---

### 6. Add 1 to a number represented by LL
`[MEDIUM]` `#reversal` `#linked-list` `#math`

#### Problem Statement
A non-negative integer is represented by a singly linked list of digits, where the head is the most significant digit. Add one to the number.

#### Implementation Overview
The main challenge is that addition starts from the least significant digit (the tail), but we only have access to the head.
1.  **Reverse the List**: The most straightforward approach is to reverse the linked list first. This makes the tail node the head, which is where addition begins.
2.  **Add with Carry**:
    -   Traverse the reversed list.
    -   Start with a `carry` of `1`.
    -   For each node, calculate `sum = node.data + carry`.
    -   Update the node's data: `node.data = sum % 10`.
    -   Update the carry: `carry = sum // 10`.
    -   If `carry` becomes `0`, you can stop early.
3.  **Handle Final Carry**: If after the loop there is still a `carry` (e.g., for `999 + 1`), you need to create a new node with the carry value and append it to the end of the reversed list.
4.  **Reverse Back**: Reverse the list again to restore the original order of most-significant-digit first.

#### Python Code Snippet
```python
def add_one(head):
    # 1. Reverse the list
    head = reverse_list_iterative(head)

    # 2. Add with carry
    current = head
    carry = 1
    while current:
        sum_val = current.data + carry
        current.data = sum_val % 10
        carry = sum_val // 10

        if carry == 0:
            break # No need to continue if carry is zero

        # If this is the last node and there's a carry, we'll handle it after loop
        if not current.next and carry > 0:
            break

        current = current.next

    # 3. Handle final carry
    if carry > 0:
        # We need to find the tail to append the new node
        tail = head
        while tail.next:
            tail = tail.next
        tail.next = Node(carry)

    # 4. Reverse back
    head = reverse_list_iterative(head)
    return head
```

#### Tricks/Gotchas
- **Reversal**: This approach is simple to understand but modifies the list twice. An alternative is to use recursion, which implicitly uses the call stack to simulate moving backward from the tail.
- **The `999` case**: The case where adding `1` causes a cascade of carries that results in a new most significant digit (e.g., `999 -> 1000`) is the most important edge case.

#### Related Problems
- Add 2 numbers in LL

---

### 7. Add 2 numbers in LL
`[MEDIUM]` `#reversal` `#linked-list` `#math`

#### Problem Statement
You are given two non-empty linked lists representing two non-negative integers. The digits are stored in reverse order, and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.

#### Implementation Overview
This version is easier than "Add 1" because the digits are already in reverse order (least significant digit first).
1.  **Initialize**: Create a dummy `head` for the result list and a `current` pointer for building it. Initialize `carry = 0`.
2.  **Iterate and Add**:
    -   Loop as long as there are nodes in `l1`, `l2`, or there is a remaining `carry`.
    -   In each iteration, get the values from the current nodes of `l1` and `l2`. If a list is exhausted, its value is `0`.
    -   Calculate `sum = val1 + val2 + carry`.
    -   Update `carry = sum // 10`.
    -   Create a new node with the value `sum % 10` and append it to the result list.
    -   Move `l1`, `l2`, and the result `current` pointer forward.
3.  **Return Result**: The final sum list is `dummy_head.next`.

#### Python Code Snippet
```python
def add_two_numbers(l1, l2):
    dummy_head = Node(0)
    current = dummy_head
    carry = 0

    p1, p2 = l1, l2

    while p1 or p2 or carry:
        val1 = p1.data if p1 else 0
        val2 = p2.data if p2 else 0

        sum_val = val1 + val2 + carry
        carry = sum_val // 10
        digit = sum_val % 10

        current.next = Node(digit)
        current = current.next

        p1 = p1.next if p1 else None
        p2 = p2.next if p2 else None

    return dummy_head.next
```

#### Tricks/Gotchas
- **Unequal Lengths**: The code must handle lists of different lengths by treating exhausted lists as having a value of `0`.
- **Final Carry**: The loop condition `while p1 or p2 or carry` elegantly handles the final carry case (e.g., `8 + 7 = 15`). If the loop finished but `carry` is still `1`, a new node must be created.
- **Most Significant Digit First**: If the problem stated digits were in MSB-first order, you would need to reverse both lists first, perform the addition, and then reverse the result.

#### Related Problems
- Add 1 to a number represented by LL

---

### 8. Remove duplicates from sorted DLL
`[MEDIUM]` `#doubly-linked-list` `#deletion` `#rearrangement`

#### Problem Statement
Given a doubly linked list sorted in ascending order, delete all duplicate nodes.

#### Implementation Overview
Since the list is sorted, all duplicate nodes will be adjacent to each other. We can solve this by traversing the list and checking if the current node's data is the same as the next node's data.

1.  Initialize a `current` pointer to the `head`.
2.  Traverse the list as long as `current` and `current.next` are not `None`.
3.  If `current.data == current.next.data`, a duplicate is found.
    -   The node `current.next` needs to be deleted.
    -   Store a reference to the node *after* the duplicate: `next_node = current.next.next`.
    -   Bypass the duplicate node: `current.next = next_node`.
    -   If `next_node` is not `None`, update its `prev` pointer to `current`.
4.  If the data is not the same, no duplicate is found at this position, so just move to the next node: `current = current.next`.

#### Python Code Snippet
```python
def remove_duplicates_sorted_dll(head):
    if not head or not head.next:
        return head

    current = head
    while current and current.next:
        if current.data == current.next.data:
            # Duplicate found, bypass the next node
            duplicate = current.next
            current.next = duplicate.next
            if duplicate.next:
                duplicate.next.prev = current
            # The 'current' pointer stays, to check for more duplicates
        else:
            # No duplicate, move to the next node
            current = current.next

    return head
```

#### Tricks/Gotchas
- **Multiple Duplicates**: If there are more than two identical nodes in a row (e.g., `1->1->1`), the logic must handle it. By *not* advancing `current` after a deletion, the code will re-check `current` against the new `current.next` in the next iteration, correctly handling multiple duplicates.
- **Updating `prev` pointer**: When deleting a node, it's crucial to update the `prev` pointer of the node that comes *after* the deleted one. A null check is required for this (`if duplicate.next:`).

#### Related Problems
- Delete all occurrences of a key in DLL
