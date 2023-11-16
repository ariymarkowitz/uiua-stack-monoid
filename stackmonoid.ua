# ############## #
# stackmonoid.ua #
# ############## #

# A stack monoid is a data structure consisting of a series of `pushes` and `pops`.
# A stack monoid is not itself a stack - rather, it is a sequence of operations
# to apply to a stack.

# In this implementation, a stack monoid is represented by an array of boxed pairs
# [□a, □b], where 'a' is a Boolean value equal to 1 if the entry is a push, and 'b' is
# the value associated to the push or pop.

# Each entry of a stack monoid has an associated depth - a push increases the depth,
# while a pop decreases the depth. By convention, the first element has depth 0.

# A forest is a stack monoid in which every push has an associated pop.

# A tree is a forest in which the last element pops the first element.
# The stack monoid of a tree corresponds to an Euler walk, which is a walk
# that visits every node exactly once.
# To see the connection between stack monoids and trees, note that a collection of
# brackets (like '(()())()(())') is a representation of a stack monoid, where each
# left bracket is a push and each right bracket is a pop.

# A leaf is a push that is followed by a pop. In a tree, this corresponds to a
# leaf node.

# ################ #
# Helper functions #
# ################ #

Split ← |1.2 ⊃⊢(↘1)
AssertRooted ← |1.0 ⍤ "Stack monoid has a negative depth push" ≠0⧻

# The empty stack monoid.
Void ← |0 ↯0_2[]

# ############## #
# Main functions #
# ############## #

# Recusively grow a forest.
# The input function takes a stack value and returns an array of child stack values.
# An initial array of values is required.
# Example: `Grow!⇡ [3 2]` outputs a stack monoid with two roots of values 3 and 2, and the children of an element with
# value n is every integer in the range 0..n-1.
Grow! ← |1 ⇌;⍢((;|⊂⊂≡{1∘}^1⊙{0 []})=1∩⊔⍘⊟⊃⊙∘⟜⊂Split)(≠0⧻) ⊃≡{1∘}Void

# Test if an element is a push.
# `≡IsPush` gets a Boolean mask of pushes in a stack monoid.
IsPush ← |1 ⊔⊢

# Get the value of an element.
# `≡Value` gets all of the values in a stack monoid.
# Because the pop values are usually empty, you probably want to use
# `≡Value▽≡IsPush.`
Value ← |1 ⊔⊢⇌

# Get a list of depths of a stack monoid.
# The first element has depth 0. Every push increments the depth, and every pop
# decrements the depth.
# In a forest, all pushes have depth >= 0, and all pops have depth >= -1.
# In a tree, the last element (and only the last element) is a pop with depth -1.
Depths ← |1 -1\+≡((¯1|1)IsPush)

# Get the pop matching the push at the given index.
Closure ← |2 ⊗¯1↘1Depths↘

# Get the subtree containing the first element.
# `Tree Grow!⇡ [3 2]` is equal to `Tree Grow!⇡ [3]`.
# The subforest corresponding to the string of brackets `(())()(` is `(())`, which
# is the substring enclosed by the initial opening bracket.
Tree ← |1 ↙Closure0.

# Get the largest subforest containing the first element.
# The subforest corresponding to the string of brackets `(())()(` is `(())()`, which
# is the largest substring in which all brackets are matched.
Forest ← |1 ↙+1⊢⇌⊂0⊚⌕¯1Depths.

# Get a boolean mask of the leaves of a stack monoid.
Leaves ← |1 ⊂∶0∺≍1_0◫2≡IsPush

# Reduce along every path, keeping intermediate values in a stack monoid
# Examples: `Flow!+ 0` gives the cumulative sum of every element.
Flow! ← |2 ;∧~⋄⋄((⋅⊓(↘1)(⊂∶{0[]})|⊃(⊂□)⟜(⊂∶{1∘})^2⊔∶Value⊙⊃⊃⊢∘AssertRooted)IsPush.)⊃⊃⋅∘[□∘]Void

# Reduce along every path, returning the leaf values in an array.
# Collect! ← ⇌≡⊔ ;∧~~⋄⋄((↘1;;|⊃⋅⊂(;;|⟜⊂) ⊃⋅∘(⍜⊔^2∶⊃Value⋅⋅(⊃⊢∘AssertRooted.)))IsPush.) ⊃⊃⊃⋅∘⋅Leaves[□∘][]
Collect! ← |2 ≡Value ▽Leaves. Flow!^2

# Get the list of indices of push and pop pairs.
Pairs ← |1 ;∧~~⋄⋄(⊃⋅(↘1)(⊂∶⊂⊢∶)|⊂)⊃⊃≡IsPush(⇡⧻)⋅([]↯0_2[])

# ######## #
# Examples #
# ######## #

# Get all subsets of [0 ... n-1]
Subsets ← ⊐≡Value▽≡IsPush. Flow!⊂[] Grow!⇡ ⇡
Subsets 4

# Find the unmatched open brace
Braces ← "()(()())(()()"
⧻Forest ∵[□∘] ⊗∶")(" Braces
# Alternative solutions:
# ⊢⇌⊚⌕¯1 Depths ∵[□∘] ⊗∶")(" Braces
# ⊢⊚¬⍘⊚♭Pairs ∵[□∘] ⊗∶")(" Braces
