# Pattern 6: Advanced & In-Place Traversals (Morris)

This pattern is dedicated to the Morris Traversal, a sophisticated and space-efficient way to traverse a binary tree without using recursion or a stack, achieving O(1) space complexity. It works by temporarily modifying the tree structure to create "threads" or links to navigate back up the tree.

---

### 1. Morris Preorder Traversal of a Binary Tree
`[MEDIUM]` `#traversal` `#morris-traversal` `#preorder` `#in-place`

#### Problem Statement
*(Explanation of the Morris Preorder Traversal algorithm, highlighting how it differs slightly from the Inorder version in terms of when the node is "visited".)*

---

### 2. Morris Inorder Traversal of a Binary Tree
`[MEDIUM]` `#traversal` `#morris-traversal` `#inorder` `#in-place`

#### Problem Statement
*(Explanation of the classic Morris Inorder Traversal algorithm. This involves finding the inorder predecessor of a node and creating a temporary link (thread) to it, allowing the traversal to return to the node after visiting its left subtree.)*
