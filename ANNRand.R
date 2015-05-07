ann.models <- c()
for (i in 1:30) {
  hidden_layer <- c(12, 12)*sample(7:250, 1)
  rand_epochs <- runif(1, 9, 13)
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
                            rate = 0.005,
                            epochs = rand_epochs
 )
 ann.models <- c(ann.models, model)
}

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

