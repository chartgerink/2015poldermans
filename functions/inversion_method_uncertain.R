xs <- 0:(bouri_data$control_n[bouri_data$decrease == 1][1] + 
           bouri_data$beta_n[bouri_data$decrease == 1][1])

result_almost_i_uncertain <- rep(0, length(xs))

# Loop for DECREASE-I
for (x in xs){
  for (iter in 1:iterations){
    # Setup data handling
    working_df <- data.frame(condition = c(rep('control', bouri_data$control_n[bouri_data$decrease == 1][1]),
                                           rep('beta', bouri_data$beta_n[bouri_data$decrease == 1][1])), 
                             fabricated = rep(NA, max(xs)),
                             event = rep(NA, max(xs)))
    working_df$fabricated <- sample(x = c(rep(0, max(xs) - x), rep(1, x)), replace = FALSE)
    
    # Sample the proportion of events from population effects
    # min() ensures that probabilities are truncated to be at most 1
    cont_prop <- min(exp(rnorm(1,
                               cont_pred,
                               cont_var)), 1)
    beta_prop <- min(exp(rnorm(1,
                               beta_pred,
                               beta_var)), 1)
    
    cont_decrease_prop <- min(exp(rnorm(1,
                                        cont_decrease_pred,
                                        cont_decrease_var)), 1)
    beta_decrease_prop <- min(exp(rnorm(1,
                                        beta_decrease_pred,
                                        beta_decrease_var)), 1)
    
    # Simulate the different data
    # Control non-fabricated
    working_df$event[working_df$condition == 'control' &
                       working_df$fabricated == 0] <- rbinom(n = sum(working_df$condition == 'control' & working_df$fabricated == 0),
                                                             size = 1,
                                                             cont_prop)
    
    # Beta non-fabricated
    working_df$event[working_df$condition == 'beta' &
                       working_df$fabricated == 0] <- rbinom(n = sum(working_df$condition == 'beta' & working_df$fabricated == 0),
                                                             size = 1,
                                                             beta_prop)
    
    # Control fabricated
    working_df$event[working_df$condition == 'control' &
                       working_df$fabricated == 1] <- rbinom(n = sum(working_df$condition == 'control' & working_df$fabricated == 1),
                                                             size = 1,
                                                             cont_decrease_prop)
    
    # Beta fabricated
    working_df$event[working_df$condition == 'beta' &
                       working_df$fabricated == 1] <- rbinom(n = sum(working_df$condition == 'beta' & working_df$fabricated == 1),
                                                             size = 1,
                                                             beta_decrease_prop)
    
    # Calculate the cell counts
    n_exp_mort <- sum(working_df$event[working_df$condition == 'beta'])
    n_exp_liv <- sum(working_df$event[working_df$condition == 'beta'] == 0)
    n_cont_mort <- sum(working_df$event[working_df$condition == 'control'])
    n_cont_liv <- sum(working_df$event[working_df$condition == 'control'] == 0)
    
    
    # Likelihood under DECREASE
    l_fab <- beta_decrease_prop^n_exp_mort *
      (1 - beta_decrease_prop)^n_exp_liv *
      cont_decrease_prop^n_cont_mort * (1 - cont_decrease_prop)^n_cont_liv
    l_tru <- beta_prop^n_exp_mort *
      (1 - beta_prop)^n_exp_liv *
      cont_prop^n_cont_mort * (1 - cont_prop)^n_cont_liv
    
    result_almost_i_uncertain[x + 1] <- result_almost_i_uncertain[x + 1] + (l_fab > l_tru )
    
    # cat(sprintf('DECREASE-I: %s fabricated data points, iteration %s\n', x, iter))
  }
}

# Set the number of datapoints to be fabricated
xs <- 0:(bouri_data$control_n[bouri_data$decrease == 1][2] + 
           bouri_data$beta_n[bouri_data$decrease == 1][2])

result_almost_iv_uncertain <- rep(0, length(xs))

# Loop for DECREASE-IV
for (x in xs){
  for (iter in 1:iterations){
    # Setup data handling
    working_df <- data.frame(condition = c(rep('control', bouri_data$control_n[bouri_data$decrease == 1][2]),
                                           rep('beta', bouri_data$beta_n[bouri_data$decrease == 1][2])), 
                             fabricated = rep(NA, max(xs)),
                             event = rep(NA, max(xs)))
    working_df$fabricated <- sample(x = c(rep(0, max(xs) - x), rep(1, x)), replace = FALSE)
    
    # Sample the proportion of events from population effects
    # min() ensures that probabilities are truncated to be at most 1
    cont_prop <- min(exp(rnorm(1,
                               cont_pred,
                               cont_var)), 1)
    beta_prop <- min(exp(rnorm(1,
                               beta_pred,
                               beta_var)), 1)
    
    cont_decrease_prop <- min(exp(rnorm(1,
                                        cont_decrease_pred,
                                        cont_decrease_var)), 1)
    beta_decrease_prop <- min(exp(rnorm(1,
                                        beta_decrease_pred,
                                        beta_decrease_var)), 1)
    
    # Simulate the different data
    # Control non-fabricated
    working_df$event[working_df$condition == 'control' &
                       working_df$fabricated == 0] <- rbinom(n = sum(working_df$condition == 'control' & working_df$fabricated == 0),
                                                             size = 1,
                                                             cont_prop)
    
    # Beta non-fabricated
    working_df$event[working_df$condition == 'beta' &
                       working_df$fabricated == 0] <- rbinom(n = sum(working_df$condition == 'beta' & working_df$fabricated == 0),
                                                             size = 1,
                                                             beta_prop)
    
    # Control fabricated
    working_df$event[working_df$condition == 'control' &
                       working_df$fabricated == 1] <- rbinom(n = sum(working_df$condition == 'control' & working_df$fabricated == 1),
                                                             size = 1,
                                                             cont_decrease_prop)
    
    # Beta fabricated
    working_df$event[working_df$condition == 'beta' &
                       working_df$fabricated == 1] <- rbinom(n = sum(working_df$condition == 'beta' & working_df$fabricated == 1),
                                                             size = 1,
                                                             beta_decrease_prop)
    
    # Calculate the cell counts
    n_exp_mort <- sum(working_df$event[working_df$condition == 'beta'])
    n_exp_liv <- sum(working_df$event[working_df$condition == 'beta'] == 0)
    n_cont_mort <- sum(working_df$event[working_df$condition == 'control'])
    n_cont_liv <- sum(working_df$event[working_df$condition == 'control'] == 0)
    
    
    # Likelihood under DECREASE
    l_fab <- beta_decrease_prop^n_exp_mort *
      (1 - beta_decrease_prop)^n_exp_liv *
      cont_decrease_prop^n_cont_mort * (1 - cont_decrease_prop)^n_cont_liv
    l_tru <- beta_prop^n_exp_mort *
      (1 - beta_prop)^n_exp_liv *
      cont_prop^n_cont_mort * (1 - cont_prop)^n_cont_liv
    
    result_almost_iv_uncertain[x + 1] <- result_almost_iv_uncertain[x + 1] + (l_fab > l_tru)
    
    # cat(sprintf('DECREASE-IV: %s fabricated data points, iteration %s\n', x, iter))
  }
}

save(result_almost_i_uncertain, file = '../data/result_almost_i_uncertain')
save(result_almost_iv_uncertain, file = '../data/result_almost_iv_uncertain')