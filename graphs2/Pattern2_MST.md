# Pattern 2: Minimum Spanning Tree (MST)

A **Spanning Tree** of a connected, undirected graph is a subgraph that connects all the vertices together with the minimum possible number of edges (V-1), without forming a cycle. A graph can have many spanning trees.

A **Minimum Spanning Tree (MST)** is a spanning tree of a weighted, connected, undirected graph that has the minimum possible total edge weight. MSTs are fundamental in network design, like finding the cheapest way to connect a set of terminals.

There are two main greedy algorithms for finding the MST: **Prim's Algorithm** and **Kruskal's Algorithm**.

---

### 1. Prim's Algorithm
`[HARD]` `#mst` `#prims-algorithm` `#priority-queue`

#### Problem Statement
Given a weighted, connected, undirected graph, find a minimum spanning tree.

#### Implementation Overview
Prim's algorithm works by growing a single tree from an arbitrary starting vertex. It greedily adds the cheapest edge that connects a vertex in the growing tree to a vertex outside the tree.
1.  Initialize a `visited` array and a priority queue. The PQ will store `(weight, vertex)` tuples, helping us find the cheapest edge to an unvisited node.
2.  Start with an arbitrary vertex `s` (e.g., 0). Add `(0, s)` to the PQ.
3.  Initialize a variable `mst_weight = 0`.
4.  While the PQ is not empty and we haven't included V vertices:
    - Extract the edge with the minimum weight `(w, u)` from the PQ.
    - If vertex `u` is already visited, continue (this edge would form a cycle with an already included node).
    - Mark `u` as visited. Add the edge weight `w` to `mst_weight`.
    - For each neighbor `v` of `u` with edge weight `edge_w`:
        - If `v` is not visited, add the edge `(edge_w, v)` to the priority queue.
5.  The final `mst_weight` is the total weight of the MST.

Prim's is very similar to Dijkstra's algorithm. The key difference is that Dijkstra prioritizes the *total path distance from the source*, while Prim's only prioritizes the *weight of the next single edge*.

#### Python Code Snippet
```python
import heapq

def prims_algorithm(V, adj):
    # adj is a list of lists, where adj[u] = [(v, weight), ...]
    pq = [(0, 0)] # (weight, vertex)
    visited = [False] * V
    mst_weight = 0

    while pq:
        weight, u = heapq.heappop(pq)

        if visited[u]:
            continue

        visited[u] = True
        mst_weight += weight

        for v, edge_weight in adj[u]:
            if not visited[v]:
                heapq.heappush(pq, (edge_weight, v))

    return mst_weight
```

---

### 2. Kruskal's Algorithm
`[HARD]` `#mst` `#kruskals-algorithm` `#disjoint-set-union`

#### Problem Statement
Given a weighted, connected, undirected graph, find a minimum spanning tree.

#### Implementation Overview
Kruskal's algorithm works by building a forest of trees that gradually merge into a single MST. It greedily adds the next cheapest edge from the entire graph, as long as it doesn't form a cycle.
1.  Create a list of all edges in the graph: `(weight, u, v)`.
2.  **Sort all edges** by weight in non-decreasing order.
3.  Initialize a **Disjoint Set Union (DSU)** data structure, with each vertex in its own set. The DSU will be used to efficiently detect cycles.
4.  Initialize `mst_weight = 0`.
5.  Iterate through the sorted edges `(w, u, v)`:
    - Check if vertices `u` and `v` are already in the same component using the DSU's `find` operation (`find(u) != find(v)`).
    - If they are not in the same component, this edge will not form a cycle.
        - Add the edge to the MST. Add its weight `w` to `mst_weight`.
        - Merge the two components using the DSU's `union` operation (`union(u, v)`).
6.  Stop when `V-1` edges have been added to the MST. The final `mst_weight` is the answer.

Kruskal's is often preferred for very sparse graphs, while Prim's can be faster for dense graphs. It relies heavily on an efficient DSU implementation.
