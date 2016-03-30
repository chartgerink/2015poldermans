xs <- 0:(bouri_data$control_n[bouri_data$decrease == 1][1] + 
           bouri_data$beta_n[bouri_data$decrease == 1][1])

result_almost_i_certain <- matrix(nrow = iterations, ncol = length(xs))

# Loop for DECREASE-I
j <- 1

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
    
    cont_decrease_prop <- exp(cont_decrease_pred)
    beta_decrease_prop <- exp(beta_decrease_pred)
    
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
    
    # Estimate the ln(RR) for this sample
    a <- sum(working_df$condition == 'control' & working_df$event == 0)
    b <- sum(working_df$condition == 'beta' & working_df$event == 0)
    c <- sum(working_df$condition == 'control' & working_df$event == 1)
    d <- sum(working_df$condition == 'beta' & working_df$event == 1)
    
    # Add .5 to studies with zero-count
    if (0 %in% c(a, b, c, d)){
      a <- a + .5
      b <- b + .5
      c <- c + .5
      d <- d + .5
    }
    
    ln_rr <- log((d/(b+d))/(c/(a+c)))
    
    # Determine whether more likely under DECREASE or non-DECREASE
    # TRUE indicates more likely under DECREASE
    # the computation just circumvents having to adjust left- or 
    # right tailed selection.
    decrease_p <- 1 - 2 * abs(pnorm(q = ln_rr, mod_dirty_pred$pred, (mod_dirty_pred$pred - mod_dirty_pred$cr.lb) / 1.96) - .5)
    non_decrease_p <- 1 - 2 * abs(pnorm(q = ln_rr, mod_clean_pred$pred, (mod_clean_pred$pred - mod_clean_pred$cr.lb) / 1.96) - .5)
    
    result_almost_i_certain[iter, j] <- decrease_p > non_decrease_p 
    
    # Extra check to ensure no NAs produced
    if(is.na(decrease_p > non_decrease_p )){
      stop('NA produced, check objects decrease_p and non_decrease_p')
    }
    
    cat(sprintf('DECREASE-I: %s fabricated data points, iteration %s\n', x, iter))
  }
  
  j <- j + 1
}

# Set the number of datapoints to be fabricated
xs <- 0:(bouri_data$control_n[bouri_data$decrease == 1][2] + 
           bouri_data$beta_n[bouri_data$decrease == 1][2])

result_almost_iv_certain <- matrix(nrow = iterations, ncol = length(xs))

# Loop for DECREASE-IV
j <- 1

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
    
    cont_decrease_prop <- exp(cont_decrease_pred)
    beta_decrease_prop <- exp(beta_decrease_pred)
    
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
    
    # Estimate the ln(RR) for this sample
    a <- sum(working_df$condition == 'control' & working_df$event == 0)
    b <- sum(working_df$condition == 'beta' & working_df$event == 0)
    c <- sum(working_df$condition == 'control' & working_df$event == 1)
    d <- sum(working_df$condition == 'beta' & working_df$event == 1)
    
    # Add .5 to studies with zero-count
    if (0 %in% c(a, b, c, d)){
      a <- a + .5
      b <- b + .5
      c <- c + .5
      d <- d + .5
    }
    
    ln_rr <- log((d/(b+d))/(c/(a+c)))
    
    # Determine whether more likely under DECREASE or non-DECREASE
    # TRUE indicates more likely under DECREASE
    # the computation just circumvents having to adjust left- or 
    # right tailed selection.
    decrease_p <- 1 - 2 * abs(pnorm(q = ln_rr, mod_dirty_pred$pred, (mod_dirty_pred$pred - mod_dirty_pred$cr.lb) / 1.96) - .5)
    non_decrease_p <- 1 - 2 * abs(pnorm(q = ln_rr, mod_clean_pred$pred, (mod_clean_pred$pred - mod_clean_pred$cr.lb) / 1.96) - .5)
    
    result_almost_iv_certain[iter, j] <- decrease_p > non_decrease_p 
    
    # Extra check to ensure no NAs produced
    if(is.na(decrease_p > non_decrease_p )){
      stop('NA produced, check objects decrease_p and non_decrease_p')
    }
    
    cat(sprintf('DECREASE-IV: %s fabricated data points, iteration %s\n', x, iter))
  }
  
  j <- j + 1
}

save(result_almost_i_certain, file = 'data/result_almost_i_certain')
save(result_almost_iv_certain, file = 'data/result_almost_iv_certain')