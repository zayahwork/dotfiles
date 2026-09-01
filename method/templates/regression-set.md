# Regression set: <what this protects>

> A build is not verified because it exists or because it seemed to work. It is verified
> because a written check exists that will catch this breaking again, and that check
> passed.

**Protects:** <the issue or the incident this came out of>
**Written:** YYYY-MM-DD
**Last run:** YYYY-MM-DD, result

---

## R1 - <what this checks>

**Run:**
```
<the exact command>
```

**Correct output:** what a passing run prints, specifically enough that a person who has
never seen this before could tell pass from fail.

**Wrong output means:** what it tells you when it does not match.

---

## R2 - <the next one>

Same shape. One check per section, each one runnable on its own.

---

## Notes

- Write these from the outside. A check that reads the source tests what the code meant.
  A check that reads only output tests what the code does.
- Include at least one check for the failure that actually happened, not only for the
  behaviour that should happen. Quiet failure and quiet success look identical later.
- If a check cannot be run without a person looking at something, say so on the check
  rather than pretending it is automated.
