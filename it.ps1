[1mdiff --git a/README.md b/README.md[m
[1mindex a3455bd..b5871a7 100644[m
[1m--- a/README.md[m
[1m+++ b/README.md[m
[36m@@ -18,6 +18,23 @@[m
 This repository defines the formal substrate conditions needed for[m
 Structural Explainability theory.[m
 [m
[32m+[m[32m## Scope[m
[32m+[m
[32m+[m[32mNeutral Substrate owns:[m
[32m+[m
[32m+[m[32m- what a referential domain is[m
[32m+[m[32m- what individuation means[m
[32m+[m[32m- what co-reference means[m
[32m+[m[32m- what persistence means[m
[32m+[m[32m- how those concepts remain distinct[m
[32m+[m
[32m+[m[32mLater layers own:[m
[32m+[m
[32m+[m[32m- particular criteria[m
[32m+[m[32m- particular references[m
[32m+[m[32m- particular records[m
[32m+[m[32m- particular persistence judgments[m
[32m+[m
 ## Authority[m
 [m
 Lean source files are authoritative for formal definitions, predicates, axioms,[m
[36m@@ -26,13 +43,13 @@[m [mtheorems, proof obligations, and reference rules.[m
 Reference artifacts under `reference/` declare the repository-owned[m
 classification, traceability, and export intent for the Lean public surface.[m
 [m
[31m-Generated artifacts under `data/neutral-substrate/` are outputs.[m
[32m+[m[32mGenerated artifacts under `data/` are outputs.[m
 They do not define theory semantics independently of Lean or the reference artifacts.[m
 [m
 The reusable `se-theory-reference-kit` owns the generic validation,[m
 cataloging, inspection, and export machinery.[m
 This repository owns its Lean source, reference declarations, and[m
[31m-generated neutral-substrate artifacts.[m
[32m+[m[32mgenerated artifacts.[m
 [m
 ## Import[m
 [m
[36m@@ -154,6 +171,15 @@[m [mgit commit -m "update"[m
 git push -u origin main[m
 ```[m
 [m
[32m+[m[32m## Philosophy Roots[m
[32m+[m
[32m+[m[32m- [Stanford Philosophy: Identity](https://plato.stanford.edu/entries/identity/)[m
[32m+[m[32m- [Stanford Philosophy: Sortals](https://plato.stanford.edu/archives/fall2020/entries/sortals/) -[m
[32m+[m[32m  Most standard Substance Sortals carry both Identity and Unity (+U).[m
[32m+[m[32m  To be a countable, distinct object (Apple),[m
[32m+[m[32m  the entity must have a clear identity over time (Sortal)[m
[32m+[m[32m  and its physical matter must be bound together as a single whole (Unity).[m
[32m+[m
 ## Authority Manifest[m
 [m
 [.accountability/surfaces.toml](./.accountability/surfaces.toml)[m
