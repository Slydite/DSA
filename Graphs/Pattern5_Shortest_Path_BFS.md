# Pattern 5: Shortest Path in Unweighted Graphs via BFS

A fundamental property of Breadth-First Search (BFS) is that it explores a graph level by level. This makes it the ideal algorithm for finding the shortest path between two nodes in an **unweighted graph**. The first time BFS reaches a target node, it is guaranteed to have done so via a shortest possible path.

This pattern focuses on problems where the graph is not given explicitly but must be inferred from the input. The "nodes" and "edges" represent relationships between data points (like words differing by one letter).

---

### 1. Word Ladder - 1
`[HARD]` `#bfs` `#shortest-path` `#implicit-graph`

#### Problem Statement
Given a `beginWord`, an `endWord`, and a `wordList`, return the length of the shortest transformation sequence from `beginWord` to `endWord`, where each transformation consists of changing a single letter. Each transformed word must exist in the `wordList`. If no such sequence exists, return 0.

#### Implementation Overview
This is a shortest path problem on an implicit graph.
- **Nodes**: The words in the `wordList` (plus `beginWord`).
- **Edges**: An edge exists between two words if they differ by exactly one letter.

A brute-force graph construction would be too slow. Instead, we generate neighbors on the fly during the BFS.
1.  Add the `wordList` to a `Set` for O(1) lookups.
2.  Initialize a queue for BFS and add `(beginWord, 1)` where 1 is the path length.
3.  Use a `visited` set to avoid cycles.
4.  **BFS Loop**:
    - Dequeue `(current_word, length)`.
    - If `current_word` is the `endWord`, return `length`.
    - **Generate Neighbors**: For each character in `current_word`, try substituting it with every letter from 'a' to 'z'.
    - For each `new_word` generated:
        - If `new_word` is in the `wordList` set and has not been visited, add it to the `visited` set and enqueue `(new_word, length + 1)`.
5.  If the queue becomes empty and we haven't reached the `endWord`, no path exists. Return 0.

#### Python Code Snippet
```python
from collections import deque

def ladderLength(beginWord, endWord, wordList):
    wordSet = set(wordList)
    if endWord not in wordSet:
        return 0

    q = deque([(beginWord, 1)])
    visited = {beginWord}

    while q:
        word, length = q.popleft()

        if word == endWord:
            return length

        for i in range(len(word)):
            original_char = word[i]
            for char_code in range(ord('a'), ord('z') + 1):
                new_char = chr(char_code)
                if new_char == original_char:
                    continue
                new_word = word[:i] + new_char + word[i+1:]

                if new_word in wordSet and new_word not in visited:
                    visited.add(new_word)
                    q.append((new_word, length + 1))

    return 0
```

---

### 2. Word Ladder - 2
`[HARD]` `#bfs` `#shortest-path` `#implicit-graph` `#backtracking`

#### Problem Statement
Given a `beginWord`, an `endWord`, and a `wordList`, return *all* the shortest transformation sequences from `beginWord` to `endWord`.

#### Implementation Overview
This is much harder than Word Ladder 1 because we need to reconstruct all shortest paths. A simple BFS is not enough. A common and efficient approach is a two-phase process:
1.  **Phase 1: BFS to find shortest path distances.**
    - Perform a BFS starting from `beginWord`.
    - Instead of just a `visited` set, use a `distance_map` (a hash map) to store the shortest distance from `beginWord` to every reachable word.
    - During the BFS, only explore paths that lead to a shorter or equal distance to a node, ensuring we build a layered graph of shortest paths. Stop the BFS once the level containing `endWord` has been fully explored.

2.  **Phase 2: DFS with Backtracking to reconstruct paths.**
    - Once we have the `distance_map`, we can find all valid paths.
    - Start a DFS from `beginWord`. The `distance_map` will guide the DFS, ensuring it only follows edges that lead along a shortest path.
    - `dfs(word, current_path)`:
        - Add `word` to `current_path`.
        - If `word` is `endWord`, a valid path has been found. Add a copy of `current_path` to the results.
        - For each neighbor of `word`, if `distance_map[neighbor] == distance_map[word] + 1`, it means this neighbor is part of a valid shortest path. Recursively call DFS on it.
        - Backtrack by removing `word` from `current_path` before returning.
This two-phase approach prevents exploring longer paths and efficiently reconstructs all shortest ones.
