######################################################################
## Random Search for H2O deep learning parameters
######################################################################

# First loop generate with a larger range of parameters 
# Second loop generate with a smaller range paramters within the first loop
# Nested loop to find the best parameter in the fastest way

ANNRand() <- function(l1, l2, l3) {
  ann.models <- c()
  for (i in 1:l1) {
  hidden_layer <- c(a, a)*sample(1:2000, 1)
  rand_epochs <- runif(1, 1, 100)
  learn_rate <- runif(1, 0.01, 0.10)
  model_name <- paste0("ANNModel_", i,
                       "_nlayer", hidden_layer,
                       "_nepochs", rand_epochs
  )
  model <- h2o.deeplearning(x=predictors,
                            y=response,
                            training_frame = train_holdout.hex,
                            validation_frame = valid_holdout.hex,
                            loss = 'CrossEntropy',
                            hidden = hidden_layer,
                            rate = learn_rate,
                            epochs = rand_epochs
  }
  ann.models <- c(ann.models, model)
  
  ## Find the best model (lowest logloss on the validation holdout set)
  best_err <- 1e3
  for (i in 1:length(ann.models)) {
    err <- h2o.performance(ann.models[[i]], valid_holdout.hex)@metrics$logloss
    if (err < best_err) {
      best_err <- err
      best_model <- ann.models[[i]]
    }
  }
  
  ## Show the "winning" parameters
  parms <- best_model@allparameters
  parms$hidden
  parms$epochs
}
