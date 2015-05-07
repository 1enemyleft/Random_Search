#still under working, tend to generate all the parameters that GBM model would use. 

models <- c()
for (i in 1:30) {
  rand_numtrees <- sample(1:50,1) ## 1 to 50 trees
  rand_max_depth <- sample(5:15,1) ## 5 to 15 max depth
  rand_min_rows <- sample(1:10,1) ## 1 to 10 min rows
  rand_learn_rate <- 0.025*sample(1:10,1) ## 0.025 to 0.25 learning rate
  model_name <- paste0("GBMModel_",i,
                       "_ntrees",rand_numtrees,
                       "_maxdepth",rand_max_depth,
                       "_minrows",rand_min_rows,
                       "_learnrate",rand_learn_rate
  )
  model <- h2o.gbm(x=predictors, 
                   y=response, 
                   training_frame=train_holdout.hex,
                   validation_frame=valid_holdout.hex,
                   destination_key=model_name,
                   loss="multinomial",
                   ntrees=rand_numtrees, 
                   max_depth=rand_max_depth, 
                   min_rows=rand_min_rows, 
                   learn_rate=rand_learn_rate
  )
  models <- c(models, model)
}
