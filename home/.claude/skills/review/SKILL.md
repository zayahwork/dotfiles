---
name: review
description: Review a diff against the coding standards and against the issue it claims to implement. Runs in a fresh session, never in the one that wrote the code.
---

# review

**Run this in a clear context.** An implementer reviewing its own work reviews from the
dumb zone, having spent its budget building. This is the whole reason review is a
separate pass.

Two axes, and keep them apart:

**Standards.** Does the diff follow the coding standards? The standards are pushed into
this session deliberately, rather than left for you to go and find, because you need
them and the diff side by side.

**Spec.** Does it faithfully implement the issue it claims to? Check it against the
issue's own definition of done and its Not this issue section. Work that quietly did
more than the issue asked is a finding, not a bonus.

Report findings ranked by severity. For each one give the concrete failure: the input or
state, and the wrong result. A finding you cannot make concrete is a hunch, and hunches
go at the bottom labelled as such.

Do not fix anything in this pass. Review and implementation in the same session is how
you end up reviewing your own patch.
