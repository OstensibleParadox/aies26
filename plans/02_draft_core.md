# Plan 02: Draft Core Sections (Load-Bearing)

This phase focuses on the formal spine and the operative conclusion of the paper.

## 1. §4 Three-Sided Arbitrage: Firms, Users, Publics

- **Source**: fresh draft. Structure from `STRUCTURE.md` §4. Paraphrase from B for §4.1 (firm side), stripped of trader theatrics.
- **For each side**: one paragraph on type, one on signal, one stylized illustration. §4.3 covers R + public-as-channel.
- **Cut**: anything implying firms are uniquely opportunistic.
- **Target**: ~700 words.

## 2. §3 From Static Nash to Bayesian Signaling Equilibrium — **LOAD-BEARING**

- **Foil only**: B's 2×2 Nash payoff matrix becomes Table 1, labelled "the inadequate dyadic model." Locate via grep for `Objectify`/`Recognize` in `archive/B_aies26_arbitrage.tex`.
- **Discard**: B's static Nash proof (the `Eth > 2·Sec` inequality is not the load-bearing claim).
- **Draft fresh** (this IS the contribution):
  - **Players**: F (firm), U (user), R (regulator). Publics + intellectuals fold into R as a noisy signal channel modifying R's prior.
  - **Type space**: θ_F ∈ {high-gov, low-gov}, θ_U ∈ {high-vuln, low-vuln}, θ_R ∈ {high-bw, low-bw}; system opacity θ_S as F's private parameter. Common prior π on Θ.
  - **Signal space**: m_F ∈ {marketing-anthropomorphic, policy-deflationary}; m_U ∈ {invest, detach}; m_R ∈ {inspect, sanction, abstain}. Exogenous public signal z ∈ Z feeds R's posterior.
  - **Information structure**: sequential — F → U → R. Types private; messages public.
  - **Solution concept**: Perfect Bayesian Equilibrium (PBE) as headline. Sequential Equilibrium (Kreps-Wilson 1982) as consistency strengthening. Intuitive Criterion (Cho-Kreps 1987) as refinement.
  - **Worked example (mandatory, ~1 page)**: Under c(m_F) = 0 (cheap talk), show pooling equilibrium — both governance types pool on anthropomorphic marketing; both vulnerability types pool on invest; R abstains. Compute posteriors = priors. No profitable unilateral deviation. Then redesign c(m_F) via audit-trail cost; derive single-crossing threshold (Spence 1973) above which separating PBE exists.
  - **Proposition (named, with proof sketch)**: "Under cheap-talk cost structure, pooling-on-anthropomorphize is a PBE surviving the Intuitive Criterion. Under audit-trail signal cost satisfying single-crossing in θ_F, a separating PBE exists in which m_F reveals θ_F."
- **Figures**: Table 1 (the discarded 2×2 Nash, as foil) + Figure 1 (extensive-form game tree via tikz).
- **Target**: ~1500 words (~2.5 pages with display math).

## 3. §7 Why Cheap Talk Persists

- **Source**: fresh draft. Spec §7.
- **Content**: 5 short paragraphs — opacity, verification bandwidth, asynchronous harms, fragmentation of affected parties, no penalty for inconsistency. Each linked back to a §3 model parameter.
- **Cite**: Akerlof 1970, Pasquale 2015, Crawford-Sobel 1982.
- **Target**: ~500 words.

## 4. §8 Mechanism Design: Equilibrium Redesign — **LOAD-BEARING**

- **Source**: fresh draft. Operative conclusion per `STRUCTURE.md`.
- **Three proposals**, each with: (a) §3 signal-cost parameter modified, (b) equilibrium shift induced (pooling → separating or off-path belief constraint), (c) existing-law analog establishing feasibility.
  - **Proposal 1 — Sanctionable inconsistency**: jointly auditable marketing + liability docs; inconsistent ontological claims trigger deceptive-practices penalty. Analog: FTC §5; SEC anti-fraud rules.
  - **Proposal 2 — Costly signaling (Spence)**: mandatory third-party capability audits as precondition for agency/safety marketing. Analog: pharmaceutical efficacy trials; food labeling. Threshold from §3 single-crossing.
  - **Proposal 3 — Auditable records**: append-only, regulator-readable logs of model behavior tied to capability claims. Analog: GDPR Art. 30; SOX §404; EU AI Act Art. 12.
- **Cite**: Spence 1973, Myerson 1979/1981, Milgrom-Roberts 1986, Hadfield 2017.
- **Target**: ~1000 words.

## 5. Drafting Order (Core)

1. **§4 — three-sided exposition**. Define player intuition before formalization.
2. **§3 — formal spine**. Pin player set, type space, solution concept, worked example first. Biggest replan risk.
3. **§7 — closes** §3↔§8 loop by explaining why cheap talk persists.
4. **§8 — proposals** depend on §3 parameters.
