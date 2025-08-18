# Pattern 3: Classic Stack Applications

This pattern covers problems where the Last-In, First-Out (LIFO) property of a stack is used directly to solve problems related to parsing, validation, and expression evaluation.

---

### 1. Check for balanced parenthesis
`[MEDIUM]` `#stack` `#validation`

#### Problem Statement
Given a string `s` containing just the characters `(`, `)`, `{`, `}`, `[` and `]`, determine if the input string is valid. An input string is valid if:
1.  Open brackets must be closed by the same type of brackets.
2.  Open brackets must be closed in the correct order.
3.  Every close bracket has a corresponding open bracket of the same type.

#### Implementation Overview
This is a canonical problem for stack usage. We iterate through the string:
- If we see an opening bracket (`(`, `{`, `[`), we push it onto the stack.
- If we see a closing bracket (`)`, `}`, `]`), we check the top of the stack.
  - If the stack is empty or the top element is not the corresponding opening bracket, the string is invalid.
  - If it is the correct opening bracket, we pop the stack.
- After iterating through the entire string, if the stack is empty, the string is valid. Otherwise, it's invalid (e.g., unclosed opening brackets).

#### Python Code Snippet
```python
class Solution:
    def isValid(self, s: str) -> bool:
        stack = []
        bracket_map = {')': '(', '}': '{', ']': '['}
        for char in s:
            if char in bracket_map: # It's a closing bracket
                # Pop from stack if it's not empty and the top matches, otherwise push a dummy value to fail the final check
                top_element = stack.pop() if stack else '#'
                if bracket_map[char] != top_element:
                    return False
            else: # It's an opening bracket
                stack.append(char)

        return not stack # True if stack is empty, False otherwise
```

---

### 2. Infix to Postfix Conversion
`[MEDIUM]` `#stack` `#expression-parsing`

#### Problem Statement
Given an infix expression string, convert it to a postfix expression. Infix notation is the common mathematical form (e.g., `a+b*c`). Postfix notation (or Reverse Polish Notation) places operators after their operands (e.g., `abc*+`).

#### Implementation Overview
We use a stack to hold operators. We iterate through the infix expression:
1.  **Operand**: If the character is an operand (a letter or number), append it to the result string.
2.  **Opening Parenthesis `(`**: Push it onto the stack.
3.  **Closing Parenthesis `)`**: Pop operators from the stack and append them to the result until an opening parenthesis `(` is encountered. Pop and discard the `(`.
4.  **Operator**: If the character is an operator:
    - While the stack is not empty, the top is not `(`, and the precedence of the current operator is less than or equal to the precedence of the operator at the top of the stack, pop operators from the stack and append them to the result.
    - After the loop, push the current operator onto the stack.

After iterating through the expression, pop any remaining operators from the stack and append them to the result.

#### Python Code Snippet
```python
def infix_to_postfix(expression):
    precedence = {'+': 1, '-': 1, '*': 2, '/': 2, '^': 3}
    stack = []
    postfix = []

    for char in expression:
        if char.isalnum():
            postfix.append(char)
        elif char == '(':
            stack.append(char)
        elif char == ')':
            while stack and stack[-1] != '(':
                postfix.append(stack.pop())
            if stack and stack[-1] == '(':
                stack.pop() # Pop '('
        else: # Operator
            while (stack and stack[-1] != '(' and
                   precedence.get(char, 0) <= precedence.get(stack[-1], 0)):
                postfix.append(stack.pop())
            stack.append(char)

    while stack:
        postfix.append(stack.pop())

    return "".join(postfix)
```

---

### 3. Postfix to Infix Conversion
`[MEDIUM]` `#stack` `#expression-parsing`

#### Problem Statement
Given a postfix expression, convert it to an infix expression.

#### Implementation Overview
Iterate through the postfix expression:
- If the character is an operand, push it onto a stack.
- If the character is an operator, pop two operands from the stack (`op2` then `op1`). Form a string `(op1 operator op2)` and push this new string back onto the stack.
- The final result is the single string remaining on the stack.

---

### 4. Prefix to Infix Conversion
`[MEDIUM]` `#stack` `#expression-parsing`

#### Problem Statement
Given a prefix expression, convert it to an infix expression.

#### Implementation Overview
This is similar to postfix-to-infix, but we iterate through the prefix expression in **reverse**.
- If the character is an operand, push it onto a stack.
- If the character is an operator, pop two operands from the stack (`op1` then `op2`). Form a string `(op1 operator op2)` and push it back.
- The final result is the single string on the stack.

---

### 5. Prefix to Postfix Conversion
`[MEDIUM]` `#stack` `#expression-parsing`

#### Problem Statement
Given a prefix expression, convert it to a postfix expression.

#### Implementation Overview
Iterate through the prefix expression in **reverse**.
- If the character is an operand, push it onto a stack.
- If the character is an operator, pop two operands (`op1`, `op2`) from the stack. Form a new string `op1 + op2 + operator` and push it back.
- The final result is the single string on the stack.

---

### 6. Postfix to Prefix Conversion
`[MEDIUM]` `#stack` `#expression-parsing`

#### Problem Statement
Given a postfix expression, convert it to a prefix expression.

#### Implementation Overview
Iterate through the postfix expression.
- If the character is an operand, push it onto a stack.
- If the character is an operator, pop two operands (`op2` then `op1`) from the stack. Form a new string `operator + op1 + op2` and push it back.
- The final result is the single string on the stack.

---

### 7. Convert Infix To Prefix Notation
`[MEDIUM]` `#stack` `#expression-parsing`

#### Problem Statement
Given an infix expression, convert it to a prefix expression.

#### Implementation Overview
This is a variation of Infix to Postfix that reuses the same logic.
1.  Reverse the infix expression.
2.  While reversing, swap every `(` with `)` and every `)` with `(`.
3.  Find the postfix expression of this new modified string using the standard algorithm.
4.  Reverse the resulting postfix expression. This gives the final prefix expression.

This clever trick avoids creating a new algorithm from scratch.
