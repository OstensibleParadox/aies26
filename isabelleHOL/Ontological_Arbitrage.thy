theory Ontological_Arbitrage
  imports Complex_Main
begin

section \<open>Ontological Arbitrage: Bayesian Signaling Equilibrium\<close>

text \<open>
  This theory formalizes a simplified Bayesian signaling model for
  ontological arbitrage.  It records two equilibrium claims: cheap talk admits
  a pooling perfect Bayesian equilibrium, while a single-crossing audit cost
  supports a separating equilibrium.

  Paper notation:
    prior_low            \<leftrightarrow> \<pi>(L)
    prior_high           \<leftrightarrow> \<pi>(H)
    ontological_premium  \<leftrightarrow> \<Delta>_F
    user_benefit         \<leftrightarrow> B_U(u)
    expected_user_harm   \<leftrightarrow> \<bar>H\<bar>_U(u)
    regulator_cost       \<leftrightarrow> c_R(r)
    regulatory_damage    \<leftrightarrow> D_R
    high_audit_slope     \<leftrightarrow> k_H
    low_audit_slope      \<leftrightarrow> k_L
    governance_gain      \<leftrightarrow> G
    audit_intensity      \<leftrightarrow> e
\<close>

subsection \<open>Types and Action Spaces\<close>

text \<open>
  The model has three players: a firm, a user, and a regulator.  The firm's
  private information includes both governance quality and system opacity;
  receivers observe only the messages, actions, and public signal encoded
  below.
\<close>

datatype firm_type = High_Gov | Low_Gov

datatype user_type = High_Vuln | Low_Vuln

datatype regulator_type = High_Bandwidth | Low_Bandwidth

datatype firm_message = Anthropomorphic | Deflationary

datatype user_action = Invest | Detach

datatype regulator_action = Inspect | Sanction | Abstain

datatype public_signal = Neutral | Adverse_Public_Signal

datatype opacity = High_Opacity | Low_Opacity

type_synonym firm_private_type = "firm_type \<times> opacity"

text \<open>Observation spaces used in the strategy-profile records.\<close>
type_synonym firm_observation = "firm_private_type"
type_synonym user_observation = "firm_message \<times> user_type"
type_synonym regulator_observation = "firm_message \<times> user_action \<times> public_signal \<times> regulator_type"

text \<open>
  Finite action sets for each player.  These are used in the best-response
  definitions below to require optimality over the full action space, rather
  than checking only specific action pairs.
\<close>

definition firm_actions :: "firm_message set" where
  "firm_actions = {Anthropomorphic, Deflationary}"

definition user_actions :: "user_action set" where
  "user_actions = {Invest, Detach}"

definition regulator_actions :: "regulator_action set" where
  "regulator_actions = {Inspect, Sanction, Abstain}"

text \<open>Strategy and belief records for the cheap-talk and audit-trail games.\<close>
record strategy_profile =
  firm_strategy   :: "firm_private_type \<Rightarrow> firm_message"
  user_strategy   :: "firm_message \<Rightarrow> user_type \<Rightarrow> user_action"
  regulator_strategy :: "firm_message \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> regulator_type \<Rightarrow> regulator_action"

record belief_system =
  prob_high_user     :: "firm_message \<Rightarrow> real"
  prob_high_regulator :: "firm_message \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> real"

record audit_strategy_profile =
  audit_firm_strategy   :: "firm_private_type \<Rightarrow> firm_message"
  audit_user_strategy   :: "firm_message \<Rightarrow> user_type \<Rightarrow> user_action"
  audit_regulator_strategy :: "firm_message \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> regulator_type \<Rightarrow> regulator_action"

record audit_belief_system =
  audit_prob_high_user     :: "firm_message \<Rightarrow> real"
  audit_prob_high_regulator :: "firm_message \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> real"

subsection \<open>Cheap-Talk Game: Pooling Equilibrium\<close>

text \<open>
  The cheap-talk locale fixes the payoff primitives and the parameter region in
  which users invest and regulators abstain after the pooling message.
\<close>
locale cheap_talk_game =
  fixes prior_low :: real
    and prior_high :: real
    and ontological_premium :: real
    and user_benefit :: "user_type \<Rightarrow> real"
    and expected_user_harm :: "user_type \<Rightarrow> real"
    and regulator_cost :: "regulator_type \<Rightarrow> real"
    and regulatory_damage :: real
  assumes prior_low_pos: "0 < prior_low"
    and prior_high_pos: "0 < prior_high"
    and prior_sum: "prior_low + prior_high = 1"
    and premium_pos: "0 < ontological_premium"
    and user_invests_if_prior:
      "\<And>u. 0 < user_benefit u - prior_low * expected_user_harm u"
    and regulator_abstains_if_prior:
      "\<And>r. prior_low * regulatory_damage < regulator_cost r"
begin

text \<open>
  Payoffs are normalized so that inactive or default choices yield zero.
\<close>

definition firm_payoff :: "firm_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_action \<Rightarrow> real" where
  "firm_payoff t m u r =
    (if m = Anthropomorphic \<and> u = Invest then ontological_premium else 0)"

definition user_payoff :: "user_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> real \<Rightarrow> real" where
  "user_payoff u m a p_high =
    (if a = Invest
     then (if m = Anthropomorphic
           then user_benefit u - (1 - p_high) * expected_user_harm u
           else 0)
     else 0)"

definition regulator_payoff :: "regulator_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_action \<Rightarrow> real \<Rightarrow> real" where
  "regulator_payoff r m u a p_high =
    (if a = Abstain then 0
     else - regulator_cost r + (1 - p_high) * regulatory_damage)"

text \<open>
  Candidate pooling profile: both governance types send the anthropomorphic
  message, users invest after it, and regulators abstain.
\<close>

definition firm_pooling_strategy :: "firm_type \<Rightarrow> firm_message" where
  "firm_pooling_strategy firm = Anthropomorphic"

definition user_pooling_strategy :: "firm_message \<Rightarrow> user_type \<Rightarrow> user_action" where
  "user_pooling_strategy message user =
    (if message = Anthropomorphic then Invest else Detach)"

definition regulator_pooling_strategy ::
  "firm_message \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> regulator_type \<Rightarrow> regulator_action"
where
  "regulator_pooling_strategy message action signal regulator = Abstain"

definition posterior_high_after_pooling :: real where
  "posterior_high_after_pooling = prior_high"

lemma firm_pooling_strategy_eq_anthropomorphic:
  shows "firm_pooling_strategy High_Gov = Anthropomorphic"
    and "firm_pooling_strategy Low_Gov = Anthropomorphic"
  unfolding firm_pooling_strategy_def by simp_all

lemma user_invests_after_anthropomorphic:
  shows "user_pooling_strategy Anthropomorphic user = Invest"
  unfolding user_pooling_strategy_def by simp

lemma regulator_abstains_after_pooling:
  shows "regulator_pooling_strategy message action signal regulator = Abstain"
  unfolding regulator_pooling_strategy_def by simp

text \<open>
  In this pooling equilibrium, the posterior belief of the regulator and user
  after the anthropomorphic message remains equal to the prior because the
  message is uninformative.
\<close>
lemma posterior_eq_prior_if_pooling:
  shows "posterior_high_after_pooling = prior_high"
  unfolding posterior_high_after_pooling_def by simp


text \<open>
  The PBE predicates are specialized to the candidate on-path histories used
  in the proposition.  Sequential rationality is defined via best-response
  operators that require each player's action to maximize payoff over the
  full (finite) action space, given beliefs --- rather than checking only
  specific action-pair inequalities.  This aligns the formalization with the
  standard extensive-form PBE requirement:

    @{text "\<sigma>_i(h) \<in> argmax_{a_i} E_\<mu>(h)[u_i(a_i, a_{-i}) | h]"}

  The check remains specialized to the on-path information sets of the
  pooling candidate.  Abstracting over the full information-set space is a
  non-trivial extension left to future work.
\<close>

definition is_best_response_firm ::
    "firm_private_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_action \<Rightarrow> bool" where
  "is_best_response_firm t m u r \<longleftrightarrow>
     (\<forall>m' \<in> firm_actions. firm_payoff (fst t) m u r \<ge> firm_payoff (fst t) m' u r)"

definition is_best_response_user ::
    "user_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> real \<Rightarrow> bool" where
  "is_best_response_user u m a p_high \<longleftrightarrow>
     (\<forall>a' \<in> user_actions. user_payoff u m a p_high \<ge> user_payoff u m a' p_high)"

definition is_best_response_regulator ::
    "regulator_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_action \<Rightarrow> real \<Rightarrow> bool" where
  "is_best_response_regulator r m u a p_high \<longleftrightarrow>
     (\<forall>a' \<in> regulator_actions. regulator_payoff r m u a p_high \<ge> regulator_payoff r m u a' p_high)"

definition is_sequentially_rational :: "strategy_profile \<Rightarrow> belief_system \<Rightarrow> bool" where
  "is_sequentially_rational \<sigma> \<mu> \<longleftrightarrow>
    (\<forall>t. is_best_response_firm t (firm_strategy \<sigma> t) Invest Abstain)
    \<and> (\<forall>u. is_best_response_user u Anthropomorphic
             (user_strategy \<sigma> Anthropomorphic u) (prob_high_user \<mu> Anthropomorphic))
    \<and> (\<forall>r. is_best_response_regulator r Anthropomorphic Invest
             (regulator_strategy \<sigma> Anthropomorphic Invest Neutral r)
             (prob_high_regulator \<mu> Anthropomorphic Invest Neutral))"

text \<open>
  Bayes consistency on path: for every on-path observation, the belief equals
  the prior updated by Bayes' rule using the firm's strategy.  In the pooling
  equilibrium the on-path message is Anthropomorphic, sent by all types, so the
  posterior equals the prior.
\<close>

definition is_bayes_consistent_on_path :: "strategy_profile \<Rightarrow> belief_system \<Rightarrow> bool" where
  "is_bayes_consistent_on_path \<sigma> \<mu> \<longleftrightarrow>
    (\<forall>opac. firm_strategy \<sigma> (High_Gov, opac) = Anthropomorphic)
    \<and> (\<forall>opac. firm_strategy \<sigma> (Low_Gov, opac) = Anthropomorphic)
    \<and> prob_high_user \<mu> Anthropomorphic = prior_high
    \<and> prob_high_regulator \<mu> Anthropomorphic Invest Neutral = prior_high"

definition is_pbe :: "strategy_profile \<Rightarrow> belief_system \<Rightarrow> bool" where
  "is_pbe \<sigma> \<mu> \<longleftrightarrow>
    is_sequentially_rational \<sigma> \<mu> \<and> is_bayes_consistent_on_path \<sigma> \<mu>"


text \<open>
  For the pooling message, Bayes' rule reduces to prior normalization over all
  governance types.
\<close>

definition bayes_update :: "(firm_type \<Rightarrow> real) \<Rightarrow> (firm_type \<Rightarrow> bool) \<Rightarrow> firm_type \<Rightarrow> real" where
  "bayes_update prior set_type t =
    (if set_type t
     then prior t /
       ((if set_type High_Gov then prior High_Gov else 0) +
        (if set_type Low_Gov then prior Low_Gov else 0))
     else 0)"

text \<open>
  Under pooling, every governance type sends the same message, so the
  likelihood ratio is uniform and the posterior equals the prior.  Both the
  user and the regulator perform this identical Bayesian update; a single
  player-agnostic lemma therefore suffices for both.
\<close>

lemma posterior_eq_prior_under_pooling:
  assumes "\<forall>t. firm_strategy \<sigma> t = Anthropomorphic"
  shows "bayes_update (\<lambda>t. if t = High_Gov then prior_high else prior_low)
           (\<lambda>t. \<forall>opac. firm_strategy \<sigma> (t, opac) = Anthropomorphic) High_Gov = prior_high"
  using assms prior_sum by (simp add: bayes_update_def add.commute)


text \<open>
  Payoff inequalities for the pooling candidate.  Each lemma now discharges
  best-response optimality over the full finite action set by case-splitting.
\<close>

lemma firm_no_deviation_to_deflationary:
  shows "is_best_response_firm t Anthropomorphic Invest Abstain"
  unfolding is_best_response_firm_def firm_actions_def firm_payoff_def
  using premium_pos by auto

lemma user_no_deviation_to_detach_after_anthropomorphic:
  shows "is_best_response_user u Anthropomorphic Invest prior_high"
proof -
  have prior_eq: "1 - prior_high = prior_low"
    using prior_sum by linarith
  have pos_payoff: "0 \<le> user_benefit u - (1 - prior_high) * expected_user_harm u"
    using user_invests_if_prior[of u] prior_eq by simp
  show ?thesis
    unfolding is_best_response_user_def user_actions_def user_payoff_def
    using pos_payoff by auto
qed

lemma regulator_no_deviation_to_inspect_after_pooling:
  shows "is_best_response_regulator r Anthropomorphic Invest Abstain prior_high"
proof -
  have prior_eq: "1 - prior_high = prior_low"
    using prior_sum by linarith
  show ?thesis
    unfolding is_best_response_regulator_def regulator_actions_def regulator_payoff_def
    using regulator_abstains_if_prior[of r] prior_eq by auto
qed


text \<open>
  Limited Intuitive Criterion (Cho and Kreps 1987).

  Disclosure: the predicate below encodes a necessary condition for the
  pooling equilibrium to survive the Intuitive Criterion, not the full
  refinement.  Specifically, it verifies that deviation to the off-path
  deflationary message is unprofitable for every firm type under the
  punishing belief in which the receiver plays Detach after observing the
  deviation.

  The full Cho--Kreps (1987) elimination requires additionally defining the
  set of rationalizable receiver best-responses to the deviating message and
  showing that if some type @{term t} could profit from deviation under some
  such response while no other type @{term "t'"} would ever profit under any
  response that gives @{term t} at least its equilibrium payoff, then the
  receiver should assign zero belief to @{term "t'"}.  Formalizing this
  properly would require an explicit best-response correspondence for the
  receiver after arbitrary off-path messages---a non-trivial extension that
  is left to future work.
\<close>

definition equilibrium_firm_payoff :: "strategy_profile \<Rightarrow> firm_private_type \<Rightarrow> real" where
  "equilibrium_firm_payoff \<sigma> t =
    firm_payoff (fst t) (firm_strategy \<sigma> t) Invest Abstain"

definition deviation_payoff_for_type ::
  "strategy_profile \<Rightarrow> belief_system \<Rightarrow> firm_private_type \<Rightarrow> firm_message \<Rightarrow> real" where
  "deviation_payoff_for_type \<sigma> \<mu> t m' =
    firm_payoff (fst t) m' Detach Abstain"

definition pooling_survives_limited_intuitive_criterion :: "strategy_profile \<Rightarrow> belief_system \<Rightarrow> bool" where
  "pooling_survives_limited_intuitive_criterion \<sigma> \<mu> \<longleftrightarrow>
    (\<forall>t. deviation_payoff_for_type \<sigma> \<mu> t Deflationary
          \<le> equilibrium_firm_payoff \<sigma> t)"

lemma pooling_survives_limited_intuitive_criterion_hold:
  assumes "\<forall>t. firm_strategy \<sigma> t = Anthropomorphic"
    and "\<forall>m u. user_strategy \<sigma> m u = (if m = Anthropomorphic then Invest else Detach)"
    and "\<forall>m u s r. regulator_strategy \<sigma> m u s r = Abstain"
  shows "pooling_survives_limited_intuitive_criterion \<sigma> \<mu>"
  unfolding pooling_survives_limited_intuitive_criterion_def
    equilibrium_firm_payoff_def deviation_payoff_for_type_def firm_payoff_def
  using assms premium_pos by (auto dest: less_imp_le)


text \<open>
  Existence statement for the cheap-talk pooling equilibrium.
\<close>

theorem proposition_1_cheap_talk_pooling_pbe:
  shows "\<exists>\<sigma> \<mu>. is_pbe \<sigma> \<mu> \<and> pooling_survives_limited_intuitive_criterion \<sigma> \<mu>"
proof (intro exI conjI)
  let ?\<sigma> = "\<lparr> firm_strategy = \<lambda>t. Anthropomorphic,
                  user_strategy = \<lambda>m u. (if m = Anthropomorphic then Invest else Detach),
                  regulator_strategy = \<lambda>m u s r. Abstain \<rparr>"
  let ?\<mu> = "\<lparr> prob_high_user = \<lambda>m. prior_high,
                  prob_high_regulator = \<lambda>m u s. prior_high \<rparr>"
  have sr: "is_sequentially_rational ?\<sigma> ?\<mu>"
    unfolding is_sequentially_rational_def
    by (auto intro!: firm_no_deviation_to_deflationary
                     user_no_deviation_to_detach_after_anthropomorphic
                     regulator_no_deviation_to_inspect_after_pooling)
  have bc: "is_bayes_consistent_on_path ?\<sigma> ?\<mu>"
    unfolding is_bayes_consistent_on_path_def by simp
  show "is_pbe ?\<sigma> ?\<mu>"
    unfolding is_pbe_def using sr bc by simp
  show "pooling_survives_limited_intuitive_criterion ?\<sigma> ?\<mu>"
    by (rule pooling_survives_limited_intuitive_criterion_hold) auto
qed

end


subsection \<open>Mechanism Design: Costly Audit Trails\<close>

text \<open>
  The audit-trail locale extends the cheap-talk game with a costly signal whose
  cost satisfies a single-crossing condition across governance types.

  Discretization note.  The current formalization fixes @{text audit_intensity}
  as an exogenous constant, reducing the firm's signal choice to a binary
  decision (emit audited signal vs.\ not).  The classic Spence (1973)
  single-crossing property (SCP) is defined over a continuous signal space
  @{text "e \<in> \<real>\<^sub>\<ge>\<^sub>0"} with @{text "\<partial>C(H,e)/\<partial>e < \<partial>C(L,e)/\<partial>e"}, and firms choose
  @{text e} optimally.  The assumption @{text single_crossing} below
  (@{text "high_audit_slope < low_audit_slope"}) is the discrete analogue of
  this marginal-cost ordering.

  Opacity is part of the firm's private type.  The base locale therefore
  includes an additive @{text opacity_penalty} in the audit cost and proves
  separately when that penalty blocks high-governance signaling.  The
  separating-equilibrium theorem is placed in the stronger
  @{text audit_trail_separating_game} locale, where the high-governance type
  can afford the audit at both opacity levels.
\<close>
locale audit_trail_game = cheap_talk_game +
  fixes high_audit_slope :: real
    and low_audit_slope :: real
    and governance_gain :: real
    and audit_intensity :: real
    and opacity_penalty :: real
  assumes high_audit_slope_pos: "0 < high_audit_slope"
    and single_crossing: "high_audit_slope < low_audit_slope"
    and governance_gain_pos: "0 < governance_gain"
    and audit_intensity_above_low_threshold:
      "governance_gain / low_audit_slope \<le> audit_intensity"
    and audit_intensity_below_high_threshold:
      "audit_intensity \<le> governance_gain / high_audit_slope"
    and opacity_penalty_nonneg: "0 \<le> opacity_penalty"
begin

text \<open>
  Cost of sending the audited signal for each private type.  High-opacity
  firms pay an additive penalty, reflecting the added cost of producing
  credible audit evidence when internals are structurally opaque.
\<close>

definition audit_cost :: "firm_private_type \<Rightarrow> real" where
  "audit_cost t =
     (if fst t = High_Gov then high_audit_slope else low_audit_slope) * audit_intensity
     + (if snd t = High_Opacity then opacity_penalty else 0)"

definition audit_firm_payoff :: "firm_private_type \<Rightarrow> firm_message \<Rightarrow> real" where
  "audit_firm_payoff t m =
    (if m = Anthropomorphic then governance_gain - audit_cost t else 0)"

lemma low_audit_slope_pos:
  shows "0 < low_audit_slope"
  using high_audit_slope_pos single_crossing by simp

lemma high_governance_low_opacity_can_signal:
  shows "0 \<le> governance_gain - audit_cost (High_Gov, Low_Opacity)"
proof -
  from audit_intensity_below_high_threshold high_audit_slope_pos
  have "high_audit_slope * audit_intensity \<le> governance_gain"
    by (simp add: pos_le_divide_eq mult.commute)
  then show ?thesis
    unfolding audit_cost_def by simp
qed

lemma low_governance_cannot_mimic:
  shows "governance_gain - audit_cost (Low_Gov, opac) \<le> 0"
proof -
  from audit_intensity_above_low_threshold low_audit_slope_pos
  have base: "governance_gain \<le> low_audit_slope * audit_intensity"
    by (simp add: pos_divide_le_eq mult.commute)
  show ?thesis
    using base opacity_penalty_nonneg
    by (cases opac) (simp_all add: audit_cost_def)
qed

text \<open>
  Opacity can block signaling.  If the penalty exceeds the high-governance
  type's low-opacity net gain, a high-governance high-opacity firm cannot
  profitably send the audited anthropomorphic signal.
\<close>

lemma opacity_blocks_signaling:
  assumes "opacity_penalty > governance_gain - high_audit_slope * audit_intensity"
  shows "governance_gain - audit_cost (High_Gov, High_Opacity) < 0"
  unfolding audit_cost_def using assms by simp

end


text \<open>
  The separating locale adds the extra assumptions needed for a full
  governance-separating audit equilibrium.  In particular, high opacity must
  not make the high-governance audit unprofitable; otherwise the base
  @{text opacity_blocks_signaling} lemma explains why separation fails.
\<close>
locale audit_trail_separating_game = audit_trail_game +
  assumes high_governance_high_opacity_can_signal:
      "high_audit_slope * audit_intensity + opacity_penalty \<le> governance_gain"
    and audit_user_benefit_nonneg:
      "\<And>u. 0 \<le> user_benefit u"
    and audit_regulator_cost_nonneg:
      "\<And>r. 0 \<le> regulator_cost r"
begin

text \<open>
  Candidate separating profile: every high-governance private type emits the
  audited anthropomorphic signal; every low-governance type sends the
  deflationary message.
\<close>

definition firm_separating_strategy :: "firm_private_type \<Rightarrow> firm_message" where
  "firm_separating_strategy t =
    (if fst t = High_Gov then Anthropomorphic else Deflationary)"

lemma high_governance_can_signal:
  shows "0 \<le> governance_gain - audit_cost (High_Gov, opac)"
proof (cases opac)
  case High_Opacity
  then show ?thesis
    using high_governance_high_opacity_can_signal
    unfolding audit_cost_def by simp
next
  case Low_Opacity
  then show ?thesis
    using high_governance_low_opacity_can_signal by simp
qed

lemma firm_separating_strategy_reveals_type:
  shows "firm_separating_strategy (High_Gov, opac) = Anthropomorphic"
    and "firm_separating_strategy (Low_Gov, opac) = Deflationary"
  unfolding firm_separating_strategy_def by simp_all

definition is_best_response_audit_firm ::
    "firm_private_type \<Rightarrow> firm_message \<Rightarrow> bool" where
  "is_best_response_audit_firm t m \<longleftrightarrow>
     (\<forall>m' \<in> firm_actions. audit_firm_payoff t m \<ge> audit_firm_payoff t m')"

lemma firm_separating_strategy_best_response [simp]:
  shows "is_best_response_audit_firm t (firm_separating_strategy t)"
  unfolding is_best_response_audit_firm_def firm_actions_def
    audit_firm_payoff_def firm_separating_strategy_def
  using high_governance_can_signal low_governance_cannot_mimic
  by (cases t; cases "fst t"; cases "snd t"; auto)

lemma audit_user_strategy_best_response [simp]:
  shows "is_best_response_user u m
    (if m = Anthropomorphic then Invest else Detach)
    (if m = Anthropomorphic then 1 else 0)"
  unfolding is_best_response_user_def user_actions_def user_payoff_def
  using audit_user_benefit_nonneg[of u] by (cases m) auto

lemma audit_regulator_strategy_best_response [simp]:
  shows "is_best_response_regulator r m u
    (if m = Deflationary \<and> 0 \<le> regulatory_damage - regulator_cost r
     then Inspect else Abstain)
    (if m = Anthropomorphic then 1 else 0)"
  unfolding is_best_response_regulator_def regulator_actions_def regulator_payoff_def
  using audit_regulator_cost_nonneg[of r] by (cases m) auto

definition is_separating :: "audit_strategy_profile \<Rightarrow> bool" where
  "is_separating \<sigma> \<longleftrightarrow>
    (\<forall>opac. audit_firm_strategy \<sigma> (High_Gov, opac) = Anthropomorphic)
    \<and> (\<forall>opac. audit_firm_strategy \<sigma> (Low_Gov, opac) = Deflationary)"

definition is_sequentially_rational_audit :: "audit_strategy_profile \<Rightarrow> audit_belief_system \<Rightarrow> bool" where
  "is_sequentially_rational_audit \<sigma> \<mu> \<longleftrightarrow>
    (\<forall>t. is_best_response_audit_firm t (audit_firm_strategy \<sigma> t))
    \<and> (\<forall>m u. is_best_response_user u m
         (audit_user_strategy \<sigma> m u) (audit_prob_high_user \<mu> m))
    \<and> (\<forall>m u s r. is_best_response_regulator r m u
         (audit_regulator_strategy \<sigma> m u s r)
         (audit_prob_high_regulator \<mu> m u s))"

definition is_bayes_consistent_on_path_audit :: "audit_strategy_profile \<Rightarrow> audit_belief_system \<Rightarrow> bool" where
  "is_bayes_consistent_on_path_audit \<sigma> \<mu> \<longleftrightarrow>
    is_separating \<sigma>
    \<and> audit_prob_high_user \<mu> Anthropomorphic = 1
    \<and> audit_prob_high_user \<mu> Deflationary = 0
    \<and> (\<forall>a s. audit_prob_high_regulator \<mu> Anthropomorphic a s = 1)
    \<and> (\<forall>a s. audit_prob_high_regulator \<mu> Deflationary a s = 0)"

definition is_pbe_audit :: "audit_strategy_profile \<Rightarrow> audit_belief_system \<Rightarrow> bool" where
  "is_pbe_audit \<sigma> \<mu> \<longleftrightarrow>
    is_sequentially_rational_audit \<sigma> \<mu> \<and> is_bayes_consistent_on_path_audit \<sigma> \<mu>"

lemma audit_posterior_on_path:
  assumes "is_bayes_consistent_on_path_audit \<sigma> \<mu>"
  shows "audit_prob_high_user \<mu> Anthropomorphic = 1"
    and "audit_prob_high_user \<mu> Deflationary = 0"
    and "audit_prob_high_regulator \<mu> Anthropomorphic a s = 1"
    and "audit_prob_high_regulator \<mu> Deflationary a s = 0"
  using assms unfolding is_bayes_consistent_on_path_audit_def by auto

text \<open>
  Existence statement for the audit-trail separating equilibrium.  Unlike the
  earlier candidate check, this theorem discharges explicit best-response
  obligations for the firm, user, and regulator at the modeled information
  sets, and its Bayes-consistency predicate depends on the strategy profile.
\<close>

theorem proposition_1_separating_pbe:
  shows "\<exists>\<sigma> \<mu>. is_pbe_audit \<sigma> \<mu> \<and> is_separating \<sigma>"
proof (intro exI conjI)
  let ?\<sigma> = "\<lparr> audit_firm_strategy = firm_separating_strategy,
                  audit_user_strategy = \<lambda>m u. (if m = Anthropomorphic then Invest else Detach),
                  audit_regulator_strategy =
                    \<lambda>m u s r. if m = Deflationary \<and> 0 \<le> regulatory_damage - regulator_cost r
                              then Inspect else Abstain \<rparr>"
  let ?\<mu> = "\<lparr> audit_prob_high_user = \<lambda>m. (if m = Anthropomorphic then 1 else 0),
                  audit_prob_high_regulator = \<lambda>m u s. (if m = Anthropomorphic then 1 else 0) \<rparr>"
  have sr: "is_sequentially_rational_audit ?\<sigma> ?\<mu>"
    unfolding is_sequentially_rational_audit_def
  proof (intro conjI allI)
    fix t
    show "is_best_response_audit_firm t (audit_firm_strategy ?\<sigma> t)"
      by simp
  next
    fix m u
    show "is_best_response_user u m
      (audit_user_strategy ?\<sigma> m u) (audit_prob_high_user ?\<mu> m)"
      by simp
  next
    fix m u s r
    show "is_best_response_regulator r m u
      (audit_regulator_strategy ?\<sigma> m u s r)
      (audit_prob_high_regulator ?\<mu> m u s)"
      unfolding is_best_response_regulator_def regulator_actions_def regulator_payoff_def
      using audit_regulator_cost_nonneg[of r] by (cases m) auto
  qed
  have bc: "is_bayes_consistent_on_path_audit ?\<sigma> ?\<mu>"
    unfolding is_bayes_consistent_on_path_audit_def is_separating_def
      firm_separating_strategy_def by auto
  show "is_pbe_audit ?\<sigma> ?\<mu>"
    unfolding is_pbe_audit_def using sr bc by simp
  show "is_separating ?\<sigma>"
    unfolding is_separating_def firm_separating_strategy_def by simp_all
qed

text \<open>
  Under the strengthened separating-locale assumptions, the audit trail
  functions as a costly signal (Spence 1973), separating the High_Gov and
  Low_Gov governance types while still exposing opacity as a condition that
  can defeat separation outside this locale.
\<close>

end

end
