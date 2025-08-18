## Task Instructions

My primary task is to process lists of programming problems (e.g., from the Striver 450 sheet) topic by topic. For each topic, I will create a structured set of Markdown files that classify each problem into a specific subtopic and pattern.

### Directory and File Structure

I will organize the generated files using the following hierarchical structure:

`./<Topic>/<Subtopic>/<Pattern>.md`

-   `<Topic>`: The main subject area (e.g., `Arrays`, `BinarySearch`, `DynamicProgramming`).
-   `<Subtopic>`: A logical grouping within the topic (e.g., `Answers` for Binary Search on Answers, `2D` for problems on 2D arrays).
-   `<Pattern>.md`: A Markdown file containing one or more problems that fit a specific, identified pattern (e.g., `Rotation.md` for problems involving rotated sorted arrays).

### Markdown File Content Requirements

Each Markdown file dedicated to a problem or a pattern of problems must contain the following sections:

1.  **Problem Name:** The title of the problem.
2.  **Problem Statement:** A clear description of the problem, including constraints and 1-2 illustrative examples.
3.  **Implementation Overview:**
    -   Focus exclusively on optimal, efficient solutions. **Do not include brute-force approaches.**
    -   Provide a high-level overview of the logic and data structures used.
4.  **Tricks/Gotchas:**
    -   Detail any non-obvious tricks, edge cases, or common pitfalls associated with the problem. This is for insights that are not easily derivable during an interview.
5.  **Flags:**
    -   Mark problems with specific flags to highlight their nature. A problem can have multiple flags.
    -   `[FUNDAMENTAL]`: For problems that test core, foundational concepts.
    -   `[HARD]`: For problems that are particularly difficult.
    -   `[TRICK]`: For problems that rely on a specific, non-obvious trick or insight.
6.  **Variations (If Applicable):**
    -   If a problem has well-known variations, list them and explain the key differences in the implementation.
7.  **Alternative Solutions (If Applicable):**
    -   If a problem has multiple optimal solutions, describe each one.
    -   **Cross-Topic Solutions:** Briefly mention if the problem can be solved using techniques from other topics (e.g., "This array problem can also be solved using a HashMap from the Hashing topic").
    -   **Same-Topic Solutions:** If there are multiple solutions with the same time/space complexity within the same topic (e.g., two-pointer vs. stack approach), provide a proper overview of each and discuss their trade-offs.

### General Instructions

-   I will process the problems list by list as provided by the user.
-   My goal is to identify and create meaningful sub-topics and patterns, even if they are not explicitly defined in the source list.
-   I must adhere strictly to these content guidelines for every problem I document.
