library(FFTrees)
library(dplyr)
library(mlr)
library(mlrMBO)
library(ranger)


wine_full <- wine %>% mutate(quality = quality >= 6, type = as.factor(type))

par.set <- makeParamSet(
  makeIntegerParam("num.trees", lower = 500, upper = 1500),
  makeNumericParam("mtry.perc", lower = 0, upper = 1)
)
lrn <- makeLearner("classif.ranger", predict.type = "prob")
tsk <- makeClassifTask(data = wine_full, target = "quality")

ctrl <- makeTuneControlMBO()
tuning <- tuneParams(lrn, tsk, measures = auc, control = ctrl,
                     resampling = makeResampleDesc("Holdout", stratify = TRUE), par.set = par.set)

lrn2 <- makeLearner("classif.ranger", par.vals = tuning$x)
lrn2<-train(lrn2,tsk)
save(lrn2, file = "./WineQualitäter/model.RData")
