theory Sanctionable_Inconsistency
  imports Ontological_Arbitrage
begin

section \<open>Mechanism: Sanctionable Inconsistency\<close>

text \<open>
  This theory extends the base ontological arbitrage model to formalize the
  "Sanctionable Inconsistency" mechanism. Firms make claims across multiple
  institutional channels. Inconsistency across these channels (e.g. 
  anthropomorphic marketing vs deflationary liability) becomes sanctionable.
\<close>

datatype claim_channel =
    Marketing
  | Product_UI
  | Safety_Documentation
  | Terms_of_Service
  | Litigation_Position
  | Regulatory_Filing

type_synonym claim_register = "claim_channel \<Rightarrow> firm_message"

definition user_facing :: "claim_channel \<Rightarrow> bool" where
  "user_facing c \<longleftrightarrow> c = Marketing \<or> c = Product_UI"

text \<open>
  Safety_Documentation is left neutral because it occupies an intermediate position 
  between consumer-facing marketing and formal legally binding filings, not directly 
  triggering the simple user_facing/liability_facing dichotomy in our baseline model.
\<close>

definition liability_facing :: "claim_channel \<Rightarrow> bool" where
  "liability_facing c \<longleftrightarrow>
     c = Terms_of_Service \<or> c = Litigation_Position \<or> c = Regulatory_Filing"

definition inconsistent_register :: "claim_register \<Rightarrow> bool" where
  "inconsistent_register r \<longleftrightarrow>
     (\<exists>u l. user_facing u \<and> liability_facing l
        \<and> r u = Anthropomorphic
        \<and> r l = Deflationary)"

record register_strategy_profile =
  register_firm_strategy :: "firm_private_type \<Rightarrow> claim_register"
  register_user_strategy :: "claim_register \<Rightarrow> user_type \<Rightarrow> user_action"
  register_regulator_strategy :: "claim_register \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> regulator_type \<Rightarrow> regulator_action"

record register_belief_system =
  register_prob_high_user :: "claim_register \<Rightarrow> real"
  register_prob_high_regulator :: "claim_register \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> real"

locale sanctionable_inconsistency = cheap_talk_game +
  fixes rho_R :: real
    and sanction_cost :: real
    and agentic_commitment_cost :: real
  assumes rho_R_bounds: "0 \<le> rho_R \<and> rho_R \<le> 1"
    and sanction_cost_nonneg: "0 \<le> sanction_cost"
    and agentic_commitment_cost_pos: "0 < agentic_commitment_cost"
begin

definition expected_sanction :: real where
  "expected_sanction = rho_R * sanction_cost"

text \<open>
  Register classes.  Safety_Documentation remains neutral in the baseline
  model: these classes constrain user-facing and liability-facing channels.
\<close>
definition arbitrage_register :: "claim_register \<Rightarrow> bool" where
  "arbitrage_register r \<longleftrightarrow>
     (\<forall>u. user_facing u \<longrightarrow> r u = Anthropomorphic) \<and>
     (\<forall>l. liability_facing l \<longrightarrow> r l = Deflationary)"

definition all_agentic_register :: "claim_register \<Rightarrow> bool" where
  "all_agentic_register r \<longleftrightarrow>
     (\<forall>u. user_facing u \<longrightarrow> r u = Anthropomorphic) \<and>
     (\<forall>l. liability_facing l \<longrightarrow> r l = Anthropomorphic)"

definition harmonized_deflationary_register :: "claim_register \<Rightarrow> bool" where
  "harmonized_deflationary_register r \<longleftrightarrow>
     (\<forall>c. user_facing c \<or> liability_facing c \<longrightarrow> r c = Deflationary)"

text \<open>
  The firm earns the ontological premium only from the arbitrage register:
  user-facing anthropomorphic claims paired with liability-facing deflation.
  A fully agentic register does not earn that arbitrage premium and instead
  incurs a positive liability-facing commitment cost.
\<close>
definition register_premium :: "claim_register \<Rightarrow> real" where
  "register_premium r =
    (if arbitrage_register r then ontological_premium else 0)"

definition register_sanction :: "claim_register \<Rightarrow> real" where
  "register_sanction r =
    (if inconsistent_register r then expected_sanction else 0)"

definition register_commitment_cost :: "claim_register \<Rightarrow> real" where
  "register_commitment_cost r =
    (if all_agentic_register r then agentic_commitment_cost else 0)"

definition firm_payoff_register :: "claim_register \<Rightarrow> real" where
  "firm_payoff_register r =
     register_premium r - register_sanction r - register_commitment_cost r"

text \<open>
  Best response is pure payoff maximization.
\<close>
definition is_best_response_register :: "claim_register \<Rightarrow> bool" where
  "is_best_response_register r \<longleftrightarrow>
    (\<forall>r'. firm_payoff_register r \<ge> firm_payoff_register r')"

theorem harmonized_deflationary_payoff_zero:
  shows "firm_payoff_register (\<lambda>c. Deflationary) = 0"
proof -
  let ?r = "\<lambda>c. Deflationary"
  have not_arbitrage: "\<not> arbitrage_register ?r"
    unfolding arbitrage_register_def user_facing_def by auto
  have not_inconsistent: "\<not> inconsistent_register ?r"
    unfolding inconsistent_register_def by simp
  have not_all_agentic: "\<not> all_agentic_register ?r"
    unfolding all_agentic_register_def user_facing_def by auto
  show ?thesis
    using not_arbitrage not_inconsistent not_all_agentic
    unfolding firm_payoff_register_def register_premium_def register_sanction_def
      register_commitment_cost_def
    by simp
qed

lemma harmonized_deflationary_register_fallback:
  shows "harmonized_deflationary_register (\<lambda>c. Deflationary)"
  unfolding harmonized_deflationary_register_def by simp

lemma all_agentic_register_payoff:
  assumes "all_agentic_register r"
  shows "firm_payoff_register r = - agentic_commitment_cost"
proof -
  have not_inconsistent: "\<not> inconsistent_register r"
    using assms unfolding all_agentic_register_def inconsistent_register_def
    by auto
  have not_arbitrage: "\<not> arbitrage_register r"
    using assms unfolding all_agentic_register_def arbitrage_register_def
      liability_facing_def
    by auto
  have no_premium: "register_premium r = 0"
    using not_arbitrage unfolding register_premium_def by simp
  have no_sanction: "register_sanction r = 0"
    using not_inconsistent unfolding register_sanction_def by simp
  have commitment: "register_commitment_cost r = agentic_commitment_cost"
    using assms unfolding register_commitment_cost_def by simp
  show ?thesis
    unfolding firm_payoff_register_def no_premium no_sanction commitment by simp
qed

theorem all_agentic_register_not_best_response:
  assumes "all_agentic_register r"
  shows "\<not> is_best_response_register r"
proof -
  let ?r_harm = "\<lambda>c. Deflationary"
  have payoff_r: "firm_payoff_register r = - agentic_commitment_cost"
    using all_agentic_register_payoff assms by simp
  have payoff_harm: "firm_payoff_register ?r_harm = 0"
    using harmonized_deflationary_payoff_zero by simp
  have strict: "firm_payoff_register r < firm_payoff_register ?r_harm"
    using payoff_r payoff_harm agentic_commitment_cost_pos by simp
  show ?thesis
    using strict unfolding is_best_response_register_def by (meson less_le_not_le)
qed

text \<open>
  To bridge this game-theoretic result with equilibrium definitions, we introduce
  sequential rationality predicates for the multi-channel register game.
  Note that while the strategy profile and belief system records are defined 
  to represent the full register game structure, the bridge theorem below 
  focuses specifically on firm-side sequential rationality (demonstrating that 
  arbitrage inconsistency is pruned from any equilibrium path), rather than 
  constructing a full register-game PBE.
\<close>

definition register_is_best_response_firm :: "firm_private_type \<Rightarrow> claim_register \<Rightarrow> bool" where
  "register_is_best_response_firm t r \<longleftrightarrow> is_best_response_register r"

definition register_firm_sequentially_rational :: "register_strategy_profile \<Rightarrow> bool" where
  "register_firm_sequentially_rational \<sigma> \<longleftrightarrow>
     (\<forall>t. register_is_best_response_firm t (register_firm_strategy \<sigma> t))"

theorem all_agentic_on_path_not_sequentially_rational:
  assumes "all_agentic_register (register_firm_strategy \<sigma> t)"
  shows "\<not> register_firm_sequentially_rational \<sigma>"
proof -
  from assms have "\<not> is_best_response_register (register_firm_strategy \<sigma> t)"
    using all_agentic_register_not_best_response by simp
  then have "\<not> register_is_best_response_firm t (register_firm_strategy \<sigma> t)"
    unfolding register_is_best_response_firm_def by simp
  then show ?thesis
    unfolding register_firm_sequentially_rational_def by metis
qed

end

text \<open>
  We define a sublocale for regimes where the expected sanction dominates the
  ontological premium. This avoids repeating the hypothesis in every theorem.
\<close>
locale strong_enforcement = sanctionable_inconsistency +
  assumes expected_sanction_dominates: "expected_sanction > ontological_premium"
begin

lemma arbitrage_register_inconsistent:
  assumes "arbitrage_register r"
  shows "inconsistent_register r"
  using assms unfolding arbitrage_register_def inconsistent_register_def
    user_facing_def liability_facing_def
  by blast

theorem inconsistent_register_not_best_response:
  assumes "inconsistent_register r"
  shows "\<not> is_best_response_register r"
proof -
  have payoff_r_bound: "firm_payoff_register r \<le> ontological_premium - expected_sanction"
  proof -
    have "register_premium r \<le> ontological_premium"
      unfolding register_premium_def using premium_pos by auto
    moreover have "register_sanction r = expected_sanction"
      using assms(1) unfolding register_sanction_def by simp
    moreover have "0 \<le> register_commitment_cost r"
      unfolding register_commitment_cost_def
      using agentic_commitment_cost_pos by auto
    ultimately show ?thesis
      unfolding firm_payoff_register_def by simp
  qed

  text \<open>Construct a harmonized register as a profitable deviation.\<close>
  let ?r_harm = "\<lambda>c. Deflationary"
  have payoff_harm: "firm_payoff_register ?r_harm = 0"
    using harmonized_deflationary_payoff_zero by simp

  from expected_sanction_dominates payoff_r_bound payoff_harm
  have strictly_less: "firm_payoff_register r < firm_payoff_register ?r_harm"
    by simp

  show ?thesis
  proof (rule ccontr)
    assume "\<not> \<not> is_best_response_register r"
    then have "is_best_response_register r" by simp
    then have "\<forall>r'. firm_payoff_register r \<ge> firm_payoff_register r'"
      unfolding is_best_response_register_def by simp
    then have "firm_payoff_register r \<ge> firm_payoff_register ?r_harm"
      by simp
    with strictly_less show False by simp
  qed
qed

theorem arbitrage_register_not_best_response:
  assumes "arbitrage_register r"
  shows "\<not> is_best_response_register r"
  using assms arbitrage_register_inconsistent inconsistent_register_not_best_response by blast

theorem inconsistent_on_path_not_sequentially_rational:
  assumes "inconsistent_register (register_firm_strategy \<sigma> t)"
  shows "\<not> register_firm_sequentially_rational \<sigma>"
proof -
  from assms(1) have "\<not> is_best_response_register (register_firm_strategy \<sigma> t)"
    using inconsistent_register_not_best_response by simp
  then have "\<not> register_is_best_response_firm t (register_firm_strategy \<sigma> t)"
    unfolding register_is_best_response_firm_def by simp
  then show ?thesis
    unfolding register_firm_sequentially_rational_def by metis
qed

theorem arbitrage_on_path_not_sequentially_rational:
  assumes "arbitrage_register (register_firm_strategy \<sigma> t)"
  shows "\<not> register_firm_sequentially_rational \<sigma>"
proof -
  from assms have "\<not> is_best_response_register (register_firm_strategy \<sigma> t)"
    using arbitrage_register_not_best_response by simp
  then have "\<not> register_is_best_response_firm t (register_firm_strategy \<sigma> t)"
    unfolding register_is_best_response_firm_def by simp
  then show ?thesis
    unfolding register_firm_sequentially_rational_def by metis
qed

end

end
