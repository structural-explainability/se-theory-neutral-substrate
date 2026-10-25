# SE Theory: Neutral Substrate

> Lean 4 formalization of the Neutral Substrate layer of
> Structural Explainability theory.

This repository formalizes the substrate conditions needed to remain compatible
with admissible interpretive frameworks without settling contested causal or
normative propositions at the foundational layer.

Lean source files under `SE/` are authoritative for formal definitions,
predicates, assumptions, theorems, and proof obligations.

- [Lean API Reference](https://structural-explainability.github.io/se-theory-neutral-substrate/lean/)
- [GitHub Repository](https://github.com/structural-explainability/se-theory-neutral-substrate)
- [Paper: Neutral Substrates (arXiv:2601.14271)](https://doi.org/10.48550/arXiv.2601.14271)
- [Reference registries](https://github.com/structural-explainability/se-theory-neutral-substrate/tree/main/reference)
  mapping the paper's stable `se100.*` tags to Lean declarations

## Neutral Substrate

The Neutral Substrate theory separates foundational commitments from
framework-relative interpretation.

This library states neutrality conditions in the abstract.
It does not certify any concrete realization: a realization must justify
its own referential fixing and framework compatibility.

## Theory Structure

```mermaid
flowchart TB
    subgraph L1["Foundations"]
        A["Propositional Language"]
        B["Commitment Theory and Consequence"]
        T["Design-Time Guarantees"]
    end
    subgraph L2["Frameworks, referents, and substrates"]
        C["Frameworks, Referent Carriers, Referential Regimes, and Substrates"]
    end
    subgraph L3["Neutral substrate vocabulary"]
        D["Referential Commitments"]
        E["Classification, Attribution, and Interpretation"]
        F["Framework-Relative Properties"]
    end
    subgraph L4["Properties and assumptions"]
        H["Interpretive Non-Commitment and Extension Stability"]
        G1["Referential Common Ground"]
        G2["Contestability"]
    end
    subgraph L5["Neutrality"]
        I["Neutrality and Neutrality by Design"]
    end
    subgraph L6["Results and hypotheses"]
        J["Semantic Sufficiency of the Foundational-Layer Restriction"]
        K["Characterization Hypothesis"]
    end

    A --> B
    B --> C
    C --> D
    D --> E
    C --> F
    F --> H
    T --> I
    H --> I
    E --> G1
    F --> G1
    E --> G2
    F --> G2
    T --> G2
    I --> J
    G1 --> J
    E --> J
    I --> K
    G1 --> K
    G2 --> K
    E --> K

    style L1 fill:#f5f5f5,stroke:#b0b0b0
    style L2 fill:#f5f5f5,stroke:#b0b0b0
    style L3 fill:#f5f5f5,stroke:#b0b0b0
    style L4 fill:#f5f5f5,stroke:#b0b0b0
    style L5 fill:#f5f5f5,stroke:#b0b0b0
    style L6 fill:#f5f5f5,stroke:#b0b0b0
```

The diagram summarizes the dependency structure of the Lean theory.
Arrows summarize theory dependencies, not logical implication;
the sufficiency result is proved,
while the characterization remains an explicit hypothesis on realizations.

## Scope

Repository scope is defined in `SE_MANIFEST.toml`.

## Exclusions

Repository exclusions are defined in `SE_MANIFEST.toml`.

## Import

Downstream Lean projects should import the public surface:

`import SE.NeutralSubstrate`
