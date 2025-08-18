# Pattern 1: Graph Foundations & Core Traversal Algorithms

This pattern covers the absolute fundamentals of graph theory. Before solving any problem, it's essential to understand what a graph is, its types, how to represent it in code, and the two primary methods for exploring it: Breadth-First Search (BFS) and Depth-First Search (DFS).

---

### 1. Graph and Types
`[EASY]` `[FUNDAMENTAL]` `#theory`

#### Description
A graph is a non-linear data structure consisting of **nodes** (or **vertices**) and **edges**. The edges connect pairs of nodes.

**Key Types of Graphs:**
1.  **Undirected Graph:** Edges have no orientation. An edge `(u, v)` is the same as `(v, u)`. Think of a two-way street.
2.  **Directed Graph (Digraph):** Edges have a direction. An edge `(u, v)` goes from `u` to `v`, but not necessarily the other way. Think of a one-way street.
3.  **Weighted Graph:** Each edge has a numerical weight or cost associated with it. This is used to represent concepts like distance, time, or cost.
4.  **Unweighted Graph:** Edges have no weight.
5.  **Cyclic Graph:** Contains at least one path that starts and ends at the same vertex.
6.  **Acyclic Graph:** Contains no cycles. A directed acyclic graph is called a **DAG**.

---

### 2. Graph Representation
`[EASY]` `[FUNDAMENTAL]` `#implementation`

#### Overview
How we store a graph in memory is crucial for performance. The two most common methods are the Adjacency Matrix and the Adjacency List.

1.  **Adjacency Matrix:**
    - A 2D array of size `V x V` where `V` is the number of vertices.
    - `matrix[i][j] = 1` (or a weight) if there is an edge from vertex `i` to `j`. Otherwise, `0`.
    - **Pros:** Fast to check for an edge between two vertices (O(1)).
    - **Cons:** Uses O(V^2) space, which is inefficient for **sparse graphs** (graphs with few edges).

2.  **Adjacency List:**
    - An array of lists. The size of the array is `V`.
    - `adj[i]` contains a list of all vertices that are adjacent to vertex `i`.
    - **Pros:** Space-efficient for sparse graphs (O(V + E) where E is the number of edges). Easy to iterate over all neighbors of a vertex.
    - **Cons:** Slower to check for a specific edge `(u, v)` (O(degree(u))).

**Adjacency List is the most common representation in competitive programming and interviews.**

#### C++ Code Snippet (Adjacency List)
```cpp
#include <iostream>
#include <vector>

// For an undirected graph
void addEdge(std::vector<int> adj[], int u, int v) {
    adj[u].push_back(v);
    adj[v].push_back(u);
}
```

#### Java Code Snippet (Adjacency List)
```java
import java.util.ArrayList;
import java.util.List;

class Graph {
    private int V;
    private List<List<Integer>> adj;

    Graph(int v) {
        V = v;
        adj = new ArrayList<>(V);
        for (int i = 0; i < V; ++i) {
            adj.add(new ArrayList<>());
        }
    }

    // For an undirected graph
    void addEdge(int u, int v) {
        adj.get(u).add(v);
        adj.get(v).add(u);
    }
}
```

---

### 3. Breadth-First Search (BFS)
`[MEDIUM]` `[FUNDAMENTAL]` `#traversal` `#queue`

#### Implementation Overview
BFS explores a graph level by level, using a **queue** to manage the order of nodes to visit. It's ideal for finding the shortest path in an unweighted graph.
1.  Create a `visited` array/set to avoid cycles and redundant processing.
2.  Create a queue and add the starting `source` vertex to it. Mark the `source` as visited.
3.  While the queue is not empty:
    - Dequeue a vertex `u`.
    - For every neighbor `v` of `u`:
        - If `v` has not been visited, mark it as visited and enqueue it.

---

### 4. Depth-First Search (DFS)
`[MEDIUM]` `[FUNDAMENTAL]` `#traversal` `#stack` `#recursion`

#### Implementation Overview
DFS explores a graph by going as deep as possible down one path before backtracking. It's typically implemented with **recursion** (which uses the call stack).
1.  Create a `visited` array/set.
2.  Define a recursive function `dfs(u)`:
    - Mark the current vertex `u` as visited.
    - For every neighbor `v` of `u`:
        - If `v` has not been visited, recursively call `dfs(v)`.

---

### 5. Connected Components | Logic Explanation
`[MEDIUM]` `#traversal` `#bfs` `#dfs`

#### Problem Statement
In an undirected graph, find and count the number of disconnected subgraphs (components).

#### Implementation Overview
This is a direct application of BFS or DFS to count the number of times we have to start a new traversal.
1.  Initialize a `visited` array of size `V` to all `false`.
2.  Initialize a `component_count` to 0.
3.  Iterate through all vertices from `i = 0` to `V-1`:
    - If `visited[i]` is `false`:
        - This means we've found a new, unvisited component.
        - Increment `component_count`.
        - Start a traversal (either BFS or DFS) from vertex `i`. The traversal will automatically visit every node in the current component and mark them as visited.
4.  The final `component_count` is the answer.
