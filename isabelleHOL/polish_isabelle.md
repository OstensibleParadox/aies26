# Replacement Isabelle Quality Plan

This replaces the earlier reviewer-response plan.  The old plan mostly added
documentation and candidate checks; the replacement focuses on making the
formal names match the obligations actually proved in
`isabelleHOL/Ontological_Arbitrage.thy`.

## Implemented Changes

1. Bayes consistency now depends on the strategy profile.

   The cheap-talk `is_bayes_consistent_on_path` predicate no longer ignores
   `sigma`: it requires both governance types, at both opacity levels, to send
   the pooling message before assigning the pooling posterior.

2. `bayes_update` no longer hard-codes the full prior mass.

   The denominator is now the probability mass of the event being conditioned
   on, specialized to the finite two-governance-type space.

3. Audit firm strategies use the full private type.

   `audit_firm_strategy` is now a function from `firm_private_type` to
   `firm_message`, so opacity is not modeled in payoffs while being invisible
   to the firm strategy.

4. Opacity is separated from the separating-equilibrium theorem.

   The base `audit_trail_game` locale defines opacity-sensitive audit costs
   and proves `opacity_blocks_signaling`.  The PBE theorem is moved into the
   stronger `audit_trail_separating_game` locale, which explicitly assumes that
   high-governance firms can still afford the audit at high opacity.

5. Audit sequential rationality is payoff-based.

   `is_sequentially_rational_audit` now requires firm, user, and regulator
   best responses rather than equality with the candidate profile.  The proof
   discharges the candidate through explicit best-response lemmas.

6. Audit Bayes consistency checks both on-path messages.

   The audit belief predicate now requires the separating strategy and assigns
   posterior high-governance probability `1` after `Anthropomorphic` and `0`
   after `Deflationary`, for both user and regulator beliefs.

## Deliberate Scope

The audit theorem still models a discrete audit/no-audit signal rather than a
continuous Spence signal space.  The text now states that limitation directly.

The regulator's deflationary-message response is chosen by payoff comparison:
inspect if `regulatory_damage - regulator_cost r >= 0`, otherwise abstain.
This avoids assuming away the regulator's incentive at the low-governance
on-path message.

## Verification

`isabelle build -D isabelleHOL` passes.
