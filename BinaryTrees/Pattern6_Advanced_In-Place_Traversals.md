# Pattern 6: Advanced & In-Place Traversals (Morris)

This pattern is dedicated to the Morris Traversal, a sophisticated and space-efficient way to traverse a binary tree without using recursion or a stack, achieving O(1) space complexity. It works by temporarily modifying the tree structure to create "threads" or links to navigate back up the tree.

---

### 1. Morris Preorder Traversal of a Binary Tree
`[MEDIUM]` `#traversal` `#morris-traversal` `#preorder` `#in-place`

#### Problem Statement
Given the root of a binary tree, return the preorder traversal of its nodes' values using Morris Traversal, which uses O(1) extra space.

#### Implementation Overview
Morris Traversal works by creating temporary "threads" (links) from a node's inorder predecessor back to the node itself. This allows us to return to the node after visiting its left subtree, all without using a stack.

The algorithm for **preorder** is a slight modification of the inorder version.

1.  Initialize `current = root` and an empty `result` list.
2.  While `current` is not null:
    a. If `current` has no left child:
        i.  Visit the node (add `current.val` to `result`).
        ii. Move to the right child: `current = current.right`.
    b. If `current` has a left child:
        i. Find the inorder predecessor of `current`. This is the rightmost node in the left subtree. Let's call it `predecessor`.
        ii. **Case 1: The thread does not exist.** (`predecessor.right` is null).
            - Visit the current node (add `current.val` to `result`). This is the key difference from inorder.
            - Create the thread: `predecessor.right = current`.
            - Move to the left: `current = current.left`.
        iii. **Case 2: The thread already exists.** (`predecessor.right == current`).
            - This means we have finished visiting the left subtree and are returning via the thread.
            - Remove the thread: `predecessor.right = None`.
            - Move to the right: `current = current.right`.
3.  Return `result`.

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
    def preorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        result = []
        current = root

        while current:
            if not current.left:
                result.append(current.val)
                current = current.right
            else:
                # Find the inorder predecessor
                predecessor = current.left
                while predecessor.right and predecessor.right != current:
                    predecessor = predecessor.right

                if not predecessor.right:
                    # Thread doesn't exist, create it
                    result.append(current.val) # Visit before going left
                    predecessor.right = current
                    current = current.left
                else:
                    # Thread exists, remove it
                    predecessor.right = None
                    current = current.right

        return result
```

#### Tricks/Gotchas
- The only difference between Morris Inorder and Preorder is *when* you visit the node. In Preorder, you visit the node right before you create the thread and move left. In Inorder, you visit it after returning from the left subtree (when you discover the thread already exists).
- This is a complex algorithm. Drawing it out is the best way to understand the threading and un-threading process.

#### Related Problems
- `[Pattern 6]` Morris Inorder Traversal of a Binary Tree.
- `[Pattern 5]` Flatten Binary Tree to LinkedList (can be solved with a similar Morris-style iteration).

---

### 2. Morris Inorder Traversal of a Binary Tree
`[MEDIUM]` `#traversal` `#morris-traversal` `#inorder` `#in-place`

#### Problem Statement
Given the root of a binary tree, return the inorder traversal of its nodes' values using Morris Traversal, which uses O(1) extra space.

#### Implementation Overview
The Morris Inorder Traversal is the canonical version of this algorithm. It avoids recursion and stacks by creating temporary links ("threads") to navigate the tree.

1.  Initialize `current = root` and an empty `result` list.
2.  While `current` is not null:
    a. If `current` has no left child:
        i.  Visit the node (add `current.val` to `result`).
        ii. Move to the right child: `current = current.right`.
    b. If `current` has a left child:
        i. Find the inorder predecessor of `current`. This is the rightmost node in the left subtree.
        ii. **Case 1: The thread does not exist.** (`predecessor.right` is null).
            - Create the thread: `predecessor.right = current`.
            - Move to the left to process the left subtree: `current = current.left`.
        iii. **Case 2: The thread already exists.** (`predecessor.right == current`).
            - This means we have finished visiting the entire left subtree and have returned to `current` via our thread.
            - Visit the node (add `current.val` to `result`).
            - Remove the thread to restore the tree's original structure: `predecessor.right = None`.
            - Move to the right: `current = current.right`.
3.  Return `result`.

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
    def inorderTraversal(self, root: Optional[TreeNode]) -> List[int]:
        result = []
        current = root

        while current:
            if not current.left:
                result.append(current.val)
                current = current.right
            else:
                # Find the inorder predecessor
                predecessor = current.left
                while predecessor.right and predecessor.right != current:
                    predecessor = predecessor.right

                if not predecessor.right:
                    # Thread doesn't exist, create it
                    predecessor.right = current
                    current = current.left
                else:
                    # Thread exists, we've finished the left subtree
                    predecessor.right = None # Remove the thread
                    result.append(current.val) # Visit the node
                    current = current.right

        return result
```

#### Tricks/Gotchas
- The logic for finding the predecessor and checking for an existing thread is the core of the algorithm.
- It is absolutely crucial to remove the thread (`predecessor.right = None`) after using it. Forgetting this will leave the tree in a modified state with cycles.
- This algorithm is a brilliant example of in-place modification to save space, but it's less intuitive than the standard recursive or stack-based solutions.

#### Related Problems
- `[Pattern 6]` Morris Preorder Traversal of a Binary Tree.
- `[Pattern 1]` Iterative Inorder Traversal (the O(N) space version).
