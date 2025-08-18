# Agent Instructions for Striver 450 Documentation

This document outlines the process for creating structured, detailed documentation for lists of programming problems.

## Core Principles
1.  **Solution-Based Categorization:** The primary structure for each topic (e.g., "Binary Search") must be based on the underlying **solution pattern** (e.g., "Binary Search on Answers"), not just the problem's data structure.
2.  **Completeness and Explicitness:** Every single problem from the provided list must have its own dedicated section (`### Problem Name`). Do not group problems under a single heading, even if their solutions are identical.
3.  **Transparency via Progress File:** For each new topic, the first step is to create a `PROGRESS.md` file (e.g., `Topic/PROGRESS.md`). This file must contain a complete checklist of all problems from the user's list. It should be methodically updated as each problem is documented.

## Structure for each Problem Entry
Each problem must be documented using the following template:

---

### [Problem Number]. [Problem Name]
`[FLAGS]` `#solution-tag-1` `#solution-tag-2`

#### Problem Statement
A clear description of the problem, including constraints and 1-2 illustrative examples.

#### Implementation Overview
A detailed, step-by-step explanation of the logic behind the optimal solution. This should be clear enough for someone to understand the algorithm before writing code.

#### Python Code Snippet
For fundamental, important, or tricky problems, provide a clean, commented Python code snippet demonstrating the core logic. This makes the pattern concrete and reusable.

#### Tricks/Gotchas
Detail any non-obvious tricks, edge cases (e.g., duplicates, empty arrays, integer overflows), or common pitfalls associated with the problem.

#### Related Problems
Link to other problems in the documentation that are direct variations or use a very similar core concept. This helps in understanding how patterns evolve.

---

## Flags and Tags
- **Flags `[...]`:** High-level categorizations.
    - `[FUNDAMENTAL]`: A core concept for the topic.
    - `[EASY]`/`[MEDIUM]`/`[HARD]`: The general difficulty.
    - `[TRICK]`: Relies on a specific, non-obvious insight.
- **Solution Tags `#...`:** Fine-grained tags describing the specific technique.
    - Examples: `#binary-search`, `#two-pointers`, `#prefix-sum`, `#hashmap`, `#reversal-algorithm`, `#inplace`, `#greedy`, `#divide-and-conquer`.

## Workflow for a New Topic
1.  Receive the list of problems for the new topic from the user.
2.  Propose a set of **solution-based patterns** for the topic (e.g., 5-6 pattern files).
3.  Upon approval, create the `Topic/PROGRESS.md` file with all problems unchecked.
4.  Methodically create each pattern file (`Topic/PatternX_Name.md`).
5.  After creating each pattern file, update the `Topic/PROGRESS.md` file to mark the completed problems.
6.  After creating all pattern files, conduct a final review to ensure all problems in `PROGRESS.md` are checked off and the documentation is consistent.
7.  Submit the final, complete work for the topic.
