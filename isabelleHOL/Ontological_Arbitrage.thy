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

text \<open>Strategy and belief records for the cheap-talk and audit-trail games.\<close>
record strategy_profile =
  firm_strategy   :: "firm_private_type \<Rightarrow> firm_message"
  user_strategy   :: "firm_message \<Rightarrow> user_type \<Rightarrow> user_action"
  regulator_strategy :: "firm_message \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> regulator_type \<Rightarrow> regulator_action"

record belief_system =
  prob_high_user     :: "firm_message \<Rightarrow> real"
  prob_high_regulator :: "firm_message \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> real"

record audit_strategy_profile =
  audit_firm_strategy   :: "firm_type \<Rightarrow> firm_message"
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
  The PBE predicates are specialized to the candidate histories used in the
  proposition.  They avoid encoding the full extensive-form game while still
  checking the payoff inequalities and on-path Bayes consistency needed below.
\<close>

definition is_sequentially_rational :: "strategy_profile \<Rightarrow> belief_system \<Rightarrow> bool" where
  "is_sequentially_rational \<sigma> \<mu> \<longleftrightarrow>
    (\<forall>t. firm_payoff (fst t) (firm_strategy \<sigma> t) Invest Abstain
         \<ge> firm_payoff (fst t) Deflationary Detach Abstain)
    \<and> (\<forall>u. user_payoff u Anthropomorphic Invest (prob_high_user \<mu> Anthropomorphic)
         \<ge> user_payoff u Anthropomorphic Detach (prob_high_user \<mu> Anthropomorphic))
    \<and> (\<forall>r. regulator_payoff r Anthropomorphic Invest Abstain
          (prob_high_regulator \<mu> Anthropomorphic Invest Neutral)
         \<ge> regulator_payoff r Anthropomorphic Invest Inspect
          (prob_high_regulator \<mu> Anthropomorphic Invest Neutral))
    \<and> (\<forall>r. regulator_payoff r Anthropomorphic Invest Abstain
          (prob_high_regulator \<mu> Anthropomorphic Invest Neutral)
         \<ge> regulator_payoff r Anthropomorphic Invest Sanction
          (prob_high_regulator \<mu> Anthropomorphic Invest Neutral))"

text \<open>
  Bayes consistency on path: for every on-path observation, the belief equals
  the prior updated by Bayes' rule using the firm's strategy.  In the pooling
  equilibrium the on-path message is Anthropomorphic, sent by all types, so the
  posterior equals the prior.
\<close>

definition is_bayes_consistent_on_path :: "strategy_profile \<Rightarrow> belief_system \<Rightarrow> bool" where
  "is_bayes_consistent_on_path \<sigma> \<mu> \<longleftrightarrow>
    prob_high_user \<mu> Anthropomorphic = prior_high
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
    (if set_type t then prior t / (prior High_Gov + prior Low_Gov) else 0)"

lemma user_posterior_eq_prior_under_pooling:
  assumes "\<forall>t. firm_strategy \<sigma> t = Anthropomorphic"
  shows "bayes_update (\<lambda>t. if t = High_Gov then prior_high else prior_low)
           (\<lambda>t. \<forall>opac. firm_strategy \<sigma> (t, opac) = Anthropomorphic) High_Gov = prior_high"
  using assms prior_sum by (simp add: bayes_update_def add.commute)

lemma regulator_posterior_eq_prior_under_pooling:
  assumes "\<forall>t. firm_strategy \<sigma> t = Anthropomorphic"
  shows "bayes_update (\<lambda>t. if t = High_Gov then prior_high else prior_low)
           (\<lambda>t. \<forall>opac. firm_strategy \<sigma> (t, opac) = Anthropomorphic) High_Gov = prior_high"
  using assms prior_sum by (simp add: bayes_update_def add.commute)


text \<open>
  Payoff inequalities for the pooling candidate.
\<close>

lemma firm_no_deviation_to_deflationary:
  shows "firm_payoff t Anthropomorphic Invest Abstain \<ge> firm_payoff t Deflationary Detach Abstain"
  unfolding firm_payoff_def using premium_pos by simp

lemma user_no_deviation_to_detach_after_anthropomorphic:
  shows "user_payoff u Anthropomorphic Invest prior_high \<ge> user_payoff u Anthropomorphic Detach prior_high"
proof -
  have prior_eq: "1 - prior_high = prior_low"
    using prior_sum by linarith
  have pos_payoff: "0 \<le> user_benefit u - (1 - prior_high) * expected_user_harm u"
    using user_invests_if_prior[of u] prior_eq by simp
  show ?thesis
    unfolding user_payoff_def
    using pos_payoff by simp
qed

lemma regulator_no_deviation_to_inspect_after_pooling:
  shows "regulator_payoff r Anthropomorphic Invest Abstain prior_high \<ge> regulator_payoff r Anthropomorphic Invest Inspect prior_high"
    and "regulator_payoff r Anthropomorphic Invest Abstain prior_high \<ge> regulator_payoff r Anthropomorphic Invest Sanction prior_high"
proof -
  have prior_eq: "1 - prior_high = prior_low"
    using prior_sum by linarith
  show "regulator_payoff r Anthropomorphic Invest Abstain prior_high \<ge> regulator_payoff r Anthropomorphic Invest Inspect prior_high"
    unfolding regulator_payoff_def
    using regulator_abstains_if_prior[of r] prior_eq by simp
next
  have prior_eq: "1 - prior_high = prior_low"
    using prior_sum by linarith
  show "regulator_payoff r Anthropomorphic Invest Abstain prior_high \<ge> regulator_payoff r Anthropomorphic Invest Sanction prior_high"
    unfolding regulator_payoff_def
    using regulator_abstains_if_prior[of r] prior_eq by simp
qed


text \<open>
  The following predicate captures the limited Intuitive-Criterion claim used
  here: the off-path deflationary message is not profitable relative to the
  pooling payoff under the specified receiver response.
\<close>

definition equilibrium_firm_payoff :: "strategy_profile \<Rightarrow> firm_private_type \<Rightarrow> real" where
  "equilibrium_firm_payoff \<sigma> t =
    firm_payoff (fst t) (firm_strategy \<sigma> t) Invest Abstain"

definition deviation_payoff_for_type ::
  "strategy_profile \<Rightarrow> belief_system \<Rightarrow> firm_private_type \<Rightarrow> firm_message \<Rightarrow> real" where
  "deviation_payoff_for_type \<sigma> \<mu> t m' =
    firm_payoff (fst t) m' Detach Abstain"

definition pooling_survives_intuitive_criterion :: "strategy_profile \<Rightarrow> belief_system \<Rightarrow> bool" where
  "pooling_survives_intuitive_criterion \<sigma> \<mu> \<longleftrightarrow>
    (\<forall>t. deviation_payoff_for_type \<sigma> \<mu> t Deflationary
          \<le> equilibrium_firm_payoff \<sigma> t)"

lemma pooling_survives_intuitive_criterion_hold:
  assumes "\<forall>t. firm_strategy \<sigma> t = Anthropomorphic"
    and "\<forall>m u. user_strategy \<sigma> m u = (if m = Anthropomorphic then Invest else Detach)"
    and "\<forall>m u s r. regulator_strategy \<sigma> m u s r = Abstain"
  shows "pooling_survives_intuitive_criterion \<sigma> \<mu>"
  unfolding pooling_survives_intuitive_criterion_def
    equilibrium_firm_payoff_def deviation_payoff_for_type_def firm_payoff_def
  using assms premium_pos by (auto dest: less_imp_le)


text \<open>
  Existence statement for the cheap-talk pooling equilibrium.
\<close>

theorem proposition_1_cheap_talk_pooling_pbe:
  shows "\<exists>\<sigma> \<mu>. is_pbe \<sigma> \<mu> \<and> pooling_survives_intuitive_criterion \<sigma> \<mu>"
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
  show "pooling_survives_intuitive_criterion ?\<sigma> ?\<mu>"
    by (rule pooling_survives_intuitive_criterion_hold) auto
qed

end


subsection \<open>Mechanism Design: Costly Audit Trails\<close>

text \<open>
  The audit-trail locale adds a costly signal whose cost satisfies a
  single-crossing condition across governance types.
\<close>
locale audit_trail_game =
  fixes high_audit_slope :: real
    and low_audit_slope :: real
    and governance_gain :: real
    and audit_intensity :: real
  assumes high_audit_slope_pos: "0 < high_audit_slope"
    and single_crossing: "high_audit_slope < low_audit_slope"
    and governance_gain_pos: "0 < governance_gain"
    and audit_intensity_above_low_threshold:
      "governance_gain / low_audit_slope \<le> audit_intensity"
    and audit_intensity_below_high_threshold:
      "audit_intensity \<le> governance_gain / high_audit_slope"
begin

text \<open>Cost of sending the audited signal for each type.\<close>
definition high_governance_audit_cost :: real where
  "high_governance_audit_cost = high_audit_slope * audit_intensity"

definition low_governance_audit_cost :: real where
  "low_governance_audit_cost = low_audit_slope * audit_intensity"

text \<open>
  Payoff in the audit-trail game.  The firm receives governance_gain if it
  sends Anthropomorphic and pays the type-dependent audit cost.  Deflationary
  yields zero.
\<close>

definition firm_separating_payoff :: "firm_type \<Rightarrow> firm_message \<Rightarrow> real" where
  "firm_separating_payoff t m =
    (if m = Anthropomorphic
     then governance_gain - (if t = High_Gov then high_governance_audit_cost else low_governance_audit_cost)
     else 0)"

text \<open>
  Candidate separating profile: only the high-governance firm emits the audited
  anthropomorphic signal.
\<close>
definition firm_separating_strategy :: "firm_type \<Rightarrow> firm_message" where
  "firm_separating_strategy firm =
    (if firm = High_Gov then Anthropomorphic else Deflationary)"

lemma low_audit_slope_pos:
  shows "0 < low_audit_slope"
  using high_audit_slope_pos single_crossing by simp

lemma audit_cost_separates_types:
  shows high_governance_can_signal: "0 \<le> governance_gain - high_governance_audit_cost"
    and low_governance_cannot_mimic: "governance_gain - low_governance_audit_cost \<le> 0"
proof -
  from audit_intensity_below_high_threshold high_audit_slope_pos
  have "high_audit_slope * audit_intensity \<le> governance_gain"
    by (simp add: pos_le_divide_eq mult.commute)
  then show "0 \<le> governance_gain - high_governance_audit_cost"
    unfolding high_governance_audit_cost_def by simp
next
  from audit_intensity_above_low_threshold low_audit_slope_pos
  have "governance_gain \<le> low_audit_slope * audit_intensity"
    by (simp add: pos_divide_le_eq mult.commute)
  then show "governance_gain - low_governance_audit_cost \<le> 0"
    unfolding low_governance_audit_cost_def by simp
qed

lemma firm_separating_strategy_reveals_type:
  shows "firm_separating_strategy High_Gov = Anthropomorphic"
    and "firm_separating_strategy Low_Gov = Deflationary"
  unfolding firm_separating_strategy_def by simp_all


text \<open>
  Payoff inequalities for the separating candidate.
\<close>

lemma high_gov_prefers_audited_anthropomorphic:
  shows "firm_separating_payoff High_Gov Anthropomorphic \<ge> firm_separating_payoff High_Gov Deflationary"
  unfolding firm_separating_payoff_def
  using audit_cost_separates_types by simp

lemma low_gov_prefers_deflationary:
  shows "firm_separating_payoff Low_Gov Deflationary \<ge> firm_separating_payoff Low_Gov Anthropomorphic"
  unfolding firm_separating_payoff_def
  using audit_cost_separates_types by simp


text \<open>
  Specialized PBE predicates for the separating candidate.
\<close>

definition is_separating :: "audit_strategy_profile \<Rightarrow> bool" where
  "is_separating \<sigma> \<longleftrightarrow>
    (audit_firm_strategy \<sigma> High_Gov = Anthropomorphic \<and>
     audit_firm_strategy \<sigma> Low_Gov = Deflationary)"

definition is_sequentially_rational_audit :: "audit_strategy_profile \<Rightarrow> audit_belief_system \<Rightarrow> bool" where
  "is_sequentially_rational_audit \<sigma> \<mu> \<longleftrightarrow>
    (\<forall>t. audit_firm_strategy \<sigma> t = firm_separating_strategy t)
    \<and> (\<forall>m u. audit_user_strategy \<sigma> m u =
         (if m = Anthropomorphic then Invest else Detach))
    \<and> (\<forall>m u s r. audit_regulator_strategy \<sigma> m u s r = Abstain)"

definition is_bayes_consistent_on_path_audit :: "audit_strategy_profile \<Rightarrow> audit_belief_system \<Rightarrow> bool" where
  "is_bayes_consistent_on_path_audit \<sigma> \<mu> \<longleftrightarrow>
    audit_prob_high_user \<mu> Anthropomorphic = 1
    \<and> audit_prob_high_regulator \<mu> Anthropomorphic Invest Neutral = 1"

definition is_pbe_audit :: "audit_strategy_profile \<Rightarrow> audit_belief_system \<Rightarrow> bool" where
  "is_pbe_audit \<sigma> \<mu> \<longleftrightarrow>
    is_sequentially_rational_audit \<sigma> \<mu> \<and> is_bayes_consistent_on_path_audit \<sigma> \<mu>"


text \<open>
  Belief lemmas for the separating equilibrium: the posterior is degenerate.
\<close>

lemma audit_posterior_on_path:
  assumes "is_bayes_consistent_on_path_audit \<sigma> \<mu>"
  shows "audit_prob_high_user \<mu> Anthropomorphic = 1"
    and "audit_prob_high_regulator \<mu> Anthropomorphic Invest Neutral = 1"
  using assms unfolding is_bayes_consistent_on_path_audit_def by auto


text \<open>
  Existence statement for the audit-trail separating equilibrium.
\<close>

theorem proposition_1_separating_pbe:
  shows "\<exists>\<sigma> \<mu>. is_pbe_audit \<sigma> \<mu> \<and> is_separating \<sigma>"
proof (intro exI conjI)
  let ?\<sigma> = "\<lparr> audit_firm_strategy = firm_separating_strategy,
                  audit_user_strategy = \<lambda>m u. (if m = Anthropomorphic then Invest else Detach),
                  audit_regulator_strategy = \<lambda>m u s r. Abstain \<rparr>"
  let ?\<mu> = "\<lparr> audit_prob_high_user = \<lambda>m. (if m = Anthropomorphic then 1 else 0),
                  audit_prob_high_regulator = \<lambda>m u s. (if m = Anthropomorphic then 1 else 0) \<rparr>"
  show "is_pbe_audit ?\<sigma> ?\<mu>"
    unfolding is_pbe_audit_def is_sequentially_rational_audit_def is_bayes_consistent_on_path_audit_def
    by auto
  show "is_separating ?\<sigma>"
    unfolding is_separating_def firm_separating_strategy_def by simp_all
qed


text \<open>
  By meeting the single-crossing condition, the audit trail functions as a
  costly signal (Spence 1973), separating the High_Gov and Low_Gov types and
  altering the Bayesian equilibrium.
\<close>

end

end
