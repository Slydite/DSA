# Pattern 5: Tree Construction & Manipulation

This pattern covers problems where the primary goal is to construct a binary tree from a given representation (like traversal arrays) or to fundamentally manipulate its structure (like flattening it into a linked list). These problems test understanding of how traversals uniquely define a tree's structure.

---

### 1. Count total Nodes in a COMPLETE Binary Tree
`[MEDIUM]` `#recursion` `#complete-tree` `#properties`

#### Problem Statement
Given the root of a complete binary tree, return the number of the nodes in the tree. A complete binary tree is a binary tree in which every level, except possibly the last, is completely filled, and all nodes in the last level are as far left as possible. The solution should be more efficient than a simple O(N) traversal.

**Example:**
Input: `root = [1,2,3,4,5,6]`
Output: `6`

#### Implementation Overview
The brute-force O(N) traversal is trivial. The challenge is to find a sub-linear solution by exploiting the properties of a complete binary tree.

The key idea is to compare the height of the tree as seen from the leftmost path versus the rightmost path.
1.  Calculate the height by only traversing left children from the root (`left_height`).
2.  Calculate the height by only traversing right children from the root (`right_height`).
3.  **Case 1: `left_height == right_height`**. This means the tree is a **full binary tree**. The number of nodes is simply `2^height - 1`. We can calculate this and return immediately.
4.  **Case 2: `left_height != right_height`**. This means the tree is complete but not full. In this case, we cannot use the formula. We fall back to the standard recursive definition: `1 + countNodes(root.left) + countNodes(root.right)`.

This approach is better than brute-force because at each step, we have a chance to stop early if we find a full binary tree. The time complexity is O((log N)^2).

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import Optional

class Solution:
    def countNodes(self, root: Optional[TreeNode]) -> int:
        if not root:
            return 0

        # Helper to get height by always going left
        def get_left_height(node):
            h = 0
            while node:
                h += 1
                node = node.left
            return h

        def get_right_height(node):
            h = 0
            while node:
                h += 1
                node = node.right
            return h

        lh = get_left_height(root)
        rh = get_right_height(root)

        if lh == rh:
            # The tree is a full binary tree
            return (1 << lh) - 1
        else:
            # The tree is complete but not full, recurse
            return 1 + self.countNodes(root.left) + self.countNodes(root.right)
```

#### Tricks/Gotchas
- The main trick is understanding that if the leftmost height equals the rightmost height, the tree must be full.
- The bitwise shift `1 << h` is a fast way to calculate `2^h`.
- This is a great example of a divide-and-conquer algorithm that prunes the search space.

#### Related Problems
- This problem is quite unique but relies on a deep understanding of complete and full binary trees.

---

### 2. Construct Binary Tree from inorder and preorder
`[HARD]` `#recursion` `#construction` `#inorder` `#preorder`

#### Problem Statement
Given two integer arrays, `preorder` and `inorder`, where `preorder` is the preorder traversal of a binary tree and `inorder` is the inorder traversal of the same tree, construct and return the binary tree. You may assume that duplicates do not exist in the tree.

**Example:**
Input: `preorder = [3,9,20,15,7]`, `inorder = [9,3,15,20,7]`
Output: `[3,9,20,null,null,15,7]`

#### Implementation Overview
The key to this problem lies in understanding what each traversal tells us:
- The **first** element of the `preorder` traversal is always the **root** of the current subtree.
- The `inorder` traversal shows the root's left subtree elements to its left and the right subtree elements to its right.

**Algorithm:**
1.  To avoid repeatedly scanning the `inorder` array, first build a hash map `inorder_map` from value to index.
2.  Create a recursive helper function `build(in_start, in_end)`. A global `preorder_idx` will track our position in the `preorder` array.
3.  **Base Case:** If `in_start > in_end`, it means there are no nodes in this subtree. Return `None`.
4.  **Find the Root:** The root of the current subtree is `preorder[preorder_idx]`. Increment `preorder_idx` and create a `TreeNode` with this value.
5.  **Find Root in Inorder:** Get the index of this root value from `inorder_map`. Let's call it `in_root_idx`. This index splits the `inorder` array into the left and right subtrees.
6.  **Recurse for Subtrees:**
    a. **Left Subtree:** Recursively call `build(in_start, in_root_idx - 1)`. The result is the left child of our current root. This must be done first because preorder processes the left subtree before the right.
    b. **Right Subtree:** Recursively call `build(in_root_idx + 1, in_end)`. The result is the right child.
7.  Return the `root`.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import List, Optional

class Solution:
    def buildTree(self, preorder: List[int], inorder: List[int]) -> Optional[TreeNode]:
        # Create a map for efficient lookup of inorder indices
        inorder_map = {val: i for i, val in enumerate(inorder)}
        self.preorder_idx = 0

        def build(in_start, in_end):
            if in_start > in_end:
                return None

            # The current root is the next element in the preorder traversal
            root_val = preorder[self.preorder_idx]
            self.preorder_idx += 1
            root = TreeNode(root_val)

            # Find the root's index in the inorder traversal to split
            in_root_idx = inorder_map[root_val]

            # IMPORTANT: Build left subtree first because preorder processes left before right
            root.left = build(in_start, in_root_idx - 1)
            root.right = build(in_root_idx + 1, in_end)

            return root

        return build(0, len(inorder) - 1)
```

#### Tricks/Gotchas
- The hash map for inorder indices is a critical optimization that reduces the complexity from O(N^2) to O(N).
- Managing the indices for the slices correctly is the hardest part. Using a global `preorder_idx` and passing only the inorder start and end indices simplifies the function signature significantly.
- The recursive call for the left subtree *must* come before the right one to ensure the `preorder_idx` advances correctly.

#### Related Problems
- `[Pattern 5]` Construct the Binary Tree from Postorder and Inorder Traversal (a slight variation of this).

---

### 3. Construct the Binary Tree from Postorder and Inorder Traversal
`[HARD]` `#recursion` `#construction` `#inorder` `#postorder`

#### Problem Statement
Given two integer arrays, `inorder` and `postorder`, where `inorder` is the inorder traversal of a binary tree and `postorder` is the postorder traversal of the same tree, construct and return the binary tree. You may assume that duplicates do not exist in the tree.

**Example:**
Input: `inorder = [9,3,15,20,7]`, `postorder = [9,15,7,20,3]`
Output: `[3,9,20,null,null,15,7]`

#### Implementation Overview
This problem is very similar to the preorder/inorder version. The key difference is how we find the root:
- The **last** element of the `postorder` traversal is always the **root** of the current subtree.

**Algorithm:**
1.  Build the `inorder_map` for O(1) lookups.
2.  Create a recursive helper `build(in_start, in_end)`. We will use a global `postorder_idx` which starts at the *end* of the `postorder` array and moves backwards.
3.  **Base Case:** If `in_start > in_end`, return `None`.
4.  **Find the Root:** The root of the current subtree is `postorder[postorder_idx]`. Decrement `postorder_idx` and create a `TreeNode`.
5.  **Find Root in Inorder:** Get the index `in_root_idx` from `inorder_map`.
6.  **Recurse for Subtrees:**
    a. **Right Subtree:** This is the crucial change. Because postorder processes `Left -> Right -> Root`, when we read the `postorder` array backwards, we encounter the root, then the root of the *right* subtree. Therefore, we **must** build the right subtree first. Recursively call `build(in_root_idx + 1, in_end)`.
    b. **Left Subtree:** Recursively call `build(in_start, in_root_idx - 1)`.
7.  Return the `root`.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import List, Optional

class Solution:
    def buildTree(self, inorder: List[int], postorder: List[int]) -> Optional[TreeNode]:
        inorder_map = {val: i for i, val in enumerate(inorder)}
        self.postorder_idx = len(postorder) - 1

        def build(in_start, in_end):
            if in_start > in_end:
                return None

            # The current root is the next element from the end of postorder
            root_val = postorder[self.postorder_idx]
            self.postorder_idx -= 1
            root = TreeNode(root_val)

            in_root_idx = inorder_map[root_val]

            # IMPORTANT: Build right subtree first because we are traversing postorder backwards
            root.right = build(in_root_idx + 1, in_end)
            root.left = build(in_start, in_root_idx - 1)

            return root

        return build(0, len(inorder) - 1)
```

#### Tricks/Gotchas
- The main trick is to process the `postorder` array from right to left.
- The most common mistake is building the left subtree before the right one. This will construct the tree incorrectly because it will consume elements from the `postorder` array in the wrong order. You must build the right subtree first.

#### Related Problems
- `[Pattern 5]` Construct Binary Tree from inorder and preorder (the basis for this problem).

---

### 4. Serialize and deserialize Binary Tree
`[HARD]` `#serialization` `#traversal`

#### Problem Statement
Serialization is the process of converting a data structure or object into a sequence of bits so that it can be stored in a file or memory buffer, or transmitted across a network connection link to be reconstructed later in the same or another computer environment.

Design an algorithm to serialize and deserialize a binary tree. There is no restriction on how your serialization/deserialization algorithm should work. You just need to ensure that a binary tree can be serialized to a string and this string can be deserialized to the original tree structure.

**Example:**
Input: `root = [1,2,3,null,null,4,5]`
Output: `[1,2,3,null,null,4,5]` (The serialized string can be in any format, but it must be possible to reconstruct the original tree from it).

#### Implementation Overview
A common and effective way to solve this is to use a **preorder traversal**.

**Serialization (`serialize`):**
1.  Perform a preorder traversal of the tree.
2.  For each node, append its value (as a string) to a list.
3.  If a node is `null`, append a special marker (e.g., `"N"` or `"#"`). This is crucial for preserving the tree's structure.
4.  Join the list elements with a delimiter (e.g., a comma) to form the final serialized string.

**Deserialization (`deserialize`):**
1.  Split the input string by the delimiter to get a list of values.
2.  Use a queue (`collections.deque`) to iterate through this list of values efficiently.
3.  Create a recursive helper function `build()`.
4.  Inside `build()`:
    a. Get the next value from the queue.
    b. If the value is the null marker (`"N"`), return `None`.
    c. Otherwise, create a new `TreeNode` with the current value.
    d. Recursively call `build()` to construct the left child: `node.left = build()`.
    e. Recursively call `build()` to construct the right child: `node.right = build()`.
    f. Return the created `node`.
5.  The initial call to `build()` will return the root of the reconstructed tree.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None
import collections

class Codec:
    def serialize(self, root):
        """Encodes a tree to a single string."""
        res = []
        def dfs(node):
            if not node:
                res.append("N")
                return
            res.append(str(node.val))
            dfs(node.left)
            dfs(node.right)
        dfs(root)
        return ",".join(res)

    def deserialize(self, data):
        """Decodes your encoded data to tree."""
        vals = collections.deque(data.split(','))

        def build():
            val = vals.popleft()
            if val == "N":
                return None

            node = TreeNode(int(val))
            node.left = build()
            node.right = build()
            return node

        return build()
```

#### Tricks/Gotchas
- The null markers are absolutely essential. Without them, you cannot distinguish between a node with one child and a node with two. For example, a tree with root 1 and left child 2 has the same preorder traversal as a tree with root 1 and right child 2.
- Using a `deque` for the values in deserialization is efficient because `popleft()` is an O(1) operation, whereas popping from the start of a list is O(N).
- Any traversal can be used (e.g., level-order), but preorder is often the most natural for recursive construction.

#### Related Problems
- `[Pattern 1]` Preorder Traversal (the basis for this solution).
- Serialize and Deserialize N-ary Tree.

---

### 5. Flatten Binary Tree to LinkedList
`[HARD]` `#manipulation` `#recursion` `#morris-traversal`

#### Problem Statement
Given the `root` of a binary tree, flatten the tree into a "linked list" in-place. The "linked list" should use the same `TreeNode` class, where the `right` child pointer points to the next node in the list and the `left` child pointer is always `null`. The "linked list" should be in the same order as a **pre-order traversal** of the binary tree.

**Example:**
Input: `root = [1,2,5,3,4,null,6]`
Output: The tree is modified in-place to be `1 -> 2 -> 3 -> 4 -> 5 -> 6` (using right pointers).

#### Implementation Overview
There are several ways to solve this, but a very clever one uses a modified, reversed pre-order traversal (`Right, Left, Root`).

**Recursive (Reversed Pre-order) Approach:**
1.  The goal is to make each node's `right` pointer point to the previously visited node. We can maintain a `prev` pointer to track this.
2.  Create a recursive function `flatten(node)`.
3.  **Base Case:** If `node` is null, return.
4.  **Recurse Right:** Call `flatten(node.right)`. This ensures we process the entire right side first.
5.  **Recurse Left:** Call `flatten(node.left)`.
6.  **Rewire Node:** After the recursive calls return, the `prev` pointer will be holding the node that should come *after* the current `node` in the flattened list.
    a. Set `node.right = prev`.
    b. Set `node.left = None`.
    c. Update `prev` to be the current `node` for the next iteration up the recursion stack.

The main function initializes `prev` to `None` and calls `flatten(root)`.

#### Python Code Snippet
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from typing import Optional

class Solution:
    def __init__(self):
        self.prev = None

    def flatten(self, root: Optional[TreeNode]) -> None:
        """
        Do not return anything, modify root in-place instead.
        """
        if not root:
            return

        # Recurse on right, then left (reverse pre-order)
        self.flatten(root.right)
        self.flatten(root.left)

        # Rewire the node
        root.right = self.prev
        root.left = None

        # Update prev to the current node for the parent's call
        self.prev = root
```

#### Tricks/Gotchas
- The reversed pre-order traversal (`Right -> Left -> Root`) is the key insight. It allows us to "build" the linked list backwards, from the last node to the first, using the `prev` pointer.
- A common mistake is to try to do this with a standard pre-order traversal, which is much more complex as you need to store the right child before overwriting the pointer.
- An iterative solution using Morris Traversal is also possible for an O(1) space solution.

#### Related Problems
- `[Pattern 6]` Morris Traversal (provides a way to do this without recursion).
