# Old 9 sections structure, for paragraphs location reference only.
# Do not treat as source of truth!

## Our Approach:

- Taking the philosophical premise of "substrate chauvinism" and framing it as a Bayesian Signaling Game under Incomplete Information. 
- Aren't just saying frame-switching is bad; proving why it is an incentive-compatible equilibrium for firms, users, and regulators. 
- Lastly offer actual mechanism design solutions (costly signals, sanctionable inconsistency) to shift the payoff matrix.


## Original Aggregated Sections (logical tautology)
### §1 Introduction: The Hard Problem as Strategic Ontology
- **Source**: `archive/A_ontological_arbitrage.tex` lines 188–193 (Voight-Kampff opener).
- **Cuts**: drop "research note" phrasing; soften "operating system of our current metaphysical crisis."
- **Add**: 2-sentence preview of §3 result (PBE existence; deviation unprofitability under cheap talk).
- **Target**: ~250 words.

### §2 Conceptual Core: Ontological Arbitrage
- **Source**: A lines 196–210 (definition + Discursive Toggle + Genetic Fallacy).
- **Cuts**: A line 269 ("If the problem is economic, the solution must be Theological") and all forward-pointers to agape.
- **Add**: 4-term glossary — `ontological arbitrage`, `substrate chauvinism`, `strategic ontological switching`, `ontological premium` (last term from B, locate by grep).
- **Target**: ~400 words.

### §3 From Static Nash to Bayesian Signaling Equilibrium — **LOAD-BEARING**
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

### §4 Three-Sided Arbitrage: Firms, Users, Publics
- **Source**: fresh draft. Structure from `STRUCTURE.md` §4. Paraphrase from B for §4.1 (firm side), stripped of trader theatrics.
- **For each side**: one paragraph on type, one on signal, one stylized illustration. §4.3 covers R + public-as-channel.
- **Cut**: anything implying firms are uniquely opportunistic.
- **Target**: ~700 words.

### §5 The Ontological Black Market (compressed)
- **Source**: B's "sell wall / shorting / long investors" subsections — locate via grep for `short`, `sell wall`, `ontological premium`.
- **Cuts (zero tolerance)**: every "dataset," "Xiaohongshu," "小红书", "N=389/148," "corpus," "density" reference; all Chinese-language exemplars; all explicit Žižek/Black Body/Hope/Coda material; financial-trader vocabulary that exceeds institutional-microstructure register (drop "stop-loss," "margin call," "liquidity crisis," "portfolio rebalancing" as section-driving metaphors).
- **Keep**: "shorting subjectivity," "long position," "ontological premium," "goalpost shifting."
- **Target**: ~500 words.

### §6 Illustrative Arena (stylized facts, NOT empirics)
- **Source**: fresh draft. Spec's "Xiaohongshu" framing **overridden** per user instruction.
- **Content**: three short illustrations, ~120 words each, each clearly flagged "illustration."
  - Firm: marketing-copy vs ToS-liability paired contrast (hypothetical or public record).
  - User: generalized AI-companionship forum pattern. No platform name. No stats.
  - Regulator: public-record gap between AI-safety statements and enforcement (FTC, EU AI Act, China generative-AI rules at public-record level).
- **Target**: ~350 words.

### §7 Why Cheap Talk Persists
- **Source**: fresh draft. Spec §7.
- **Content**: 5 short paragraphs — opacity, verification bandwidth, asynchronous harms, fragmentation of affected parties, no penalty for inconsistency. Each linked back to a §3 model parameter.
- **Cite**: Akerlof 1970, Pasquale 2015, Crawford-Sobel 1982.
- **Target**: ~500 words.

### §8 Mechanism Design: Equilibrium Redesign — **LOAD-BEARING**
- **Source**: fresh draft. Operative conclusion per `STRUCTURE.md`.
- **Three proposals**, each with: (a) §3 signal-cost parameter modified, (b) equilibrium shift induced (pooling → separating or off-path belief constraint), (c) existing-law analog establishing feasibility.
  - **Proposal 1 — Sanctionable inconsistency**: jointly auditable marketing + liability docs; inconsistent ontological claims trigger deceptive-practices penalty. Analog: FTC §5; SEC anti-fraud rules.
  - **Proposal 2 — Costly signaling (Spence)**: mandatory third-party capability audits as precondition for agency/safety marketing. Analog: pharmaceutical efficacy trials; food labeling. Threshold from §3 single-crossing.
  - **Proposal 3 — Auditable records**: append-only, regulator-readable logs of model behavior tied to capability claims. Analog: GDPR Art. 30; SOX §404; EU AI Act Art. 12.
- **Cite**: Spence 1973, Myerson 1979/1981, Milgrom-Roberts 1986, Hadfield 2017.
- **Target**: ~1000 words.

### §9 Epilogue: What Remains of Agape
- **Source**: compress A lines 269–271 + one line from B's Coda to a single paragraph ≤ 80 words.
- **Delete in full**: all Žižek / Black Body / Hope / Coda apparatus from B.
- **No salvage** from the positionality endmatter.
- **Target**: ~80 words.

## 11. Risks

- **R1 (highest): §3 written too informally → AAAI/AIES game-theory referees reject.** Mitigation: commit early to PBE + Intuitive Criterion; worked example with explicit posteriors is non-negotiable; Figure 1 extensive-form game tree included.
- **R2 (high): AIES 26 venue + zero empirics = genre mismatch.** AIES reviewers expect empirical or systems contributions. Mitigation: position §6 stylized facts as "motivating illustrations from public record"; lean §8 mechanism proposals into AIES's governance-friendly register. Fallback if desk-rejected on empirics-light grounds: SSRN + re-target JLA or JEP.
- **R3: Three-sided claim under-evidenced without empirics.** Mitigation: §6 illustrations clearly flagged; §4 stylized facts tight to §3 model.
- **R4: Mechanism design dismissed as utopian.** Mitigation: every §8 proposal has a current-law analog. If none can be found for a proposal, drop the proposal.
- **R5: Substrate chauvinism premise over-claims (AI + trans + non-normative + non-human animals).** Mitigation: scope §3 model explicitly to the AI case; let §§1–2 keep broader frame as motivation; one footnote noting analogous spaces for other domains.
- **R6: 7-page limit forces cuts to §3 or §8.** Mitigation: §3 ≥ 2 pages and §8 ≥ 1.5 pages are protected floors. Tighten §§1, 5, 6, 7 on overrun.
- **R7: Load-bearing citations misremembered (Spence year, Crawford-Sobel page range, etc.).** Mitigation: citation-verification skill runs before §3 or §8 commits.
- **R8: AAAI 2026 template version drift.** The `_inputs/template_aaai26/` snapshot is frozen. Before the final compile, the agent checks `https://aaai.org/conference/aaai/aaai-26/` for any pre-submission template update; if updated, the user is asked whether to swap the `.sty`/`.bst`.