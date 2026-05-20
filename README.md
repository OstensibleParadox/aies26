# Project: Ontological Arbitrage (AIES 26 Submission)

This project is a clean-rebuild of the "Ontological Arbitrage" paper, retitled **"Ontological Arbitrage: Bayesian Equilibrium under Substrate Chauvinism"**, specifically formatted for AIES 26 submission using the AAAI 2026 template.

The implementation plan has been broken down into sequential phases to ensure structural integrity and formal rigor, incorporating recommendations from a structural logician audit.

## Execution Plans

1.  **[Phase 1: Scaffold and Configuration](plans/01_scaffold.md)**
    *   Setup target directory structure and archive source inputs.
    *   Configure LaTeX environment with AAAI 2026 styles.
    *   Establish the modular document structure.

2.  **[Phase 2: Draft Core Sections (Load-Bearing)](plans/02_draft_core.md)**
    *   **§4 Three-Sided Arbitrage**: Defining player intuition.
    *   **§3 Bayesian Signaling Equilibrium**: The formal mathematical contribution.
    *   **§7 Why Cheap Talk Persists**: Structural justification for the model.
    *   **§8 Mechanism Design**: The operative governance proposals.

3.  **[Phase 3: Draft Supporting Sections and Bibliography](plans/03_draft_supporting.md)**
    *   **§1 Introduction** & **§2 Conceptual Core**.
    *   **§5 Stylized Facts**: Consolidating market theory and illustrative arena.
    *   **§9 Epilogue**: Final synthesis.
    *   Reconcile and verify the bibliography.

4.  **[Phase 4: Build, Risks, and Verification](plans/04_build_and_verify.md)**
    *   Final compilation and acceptance checks.
    *   Risk mitigation strategies.
    *   End-to-end verification protocol.

## Build Command

To compile the paper from the root directory:

```bash
pdflatex arbitrage && bibtex arbitrage && pdflatex arbitrage && pdflatex arbitrage
```
